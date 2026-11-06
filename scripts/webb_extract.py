"""Stream selected tables out of a Webb-site MySQL dump into Parquet files.

The dumps are tens of gigabytes once decompressed, so nothing is written to
disk except the requested tables. Lines are read from a byte stream (for
example `7z x -so archive.7z member.sql`).

Supported table modes:
  full                      every row
  latest KEY1,KEY2 ORDERCOL keep only the row with the largest ORDERCOL per key
                            (used for CCASS holdings, which store changes only)
Every other table is measured (bytes of INSERT data) but not parsed.
"""

from __future__ import annotations

import hashlib
import json
import os
import re
from dataclasses import dataclass, field

import pyarrow as pa
import pyarrow.parquet as pq

CREATE_RE = re.compile(r"^CREATE TABLE `([^`]+)`", re.I)
COLUMN_RE = re.compile(r"^\s*`([^`]+)`\s+([A-Za-z]+)(.*)$")
INSERT_RE = re.compile(r"^INSERT INTO `([^`]+)`\s*(?:\(([^)]*)\))?\s*VALUES\s*", re.I)
TOKEN_RE = re.compile(
    r"_binary\s*'(?:[^'\\]|\\.|'')*'"
    r"|[bBxX]'[0-9A-Fa-f]*'"
    r"|'(?:[^'\\]|\\.|'')*'"
    r"|[(),]"
    r"|[^,()'\s]+"
    r"|\s+",
    re.S,
)
ESCAPES = {"0": "\0", "b": "\b", "n": "\n", "r": "\r", "t": "\t", "Z": "\x1a"}
ESC_RE = re.compile(r"\\(.)|''", re.S)

INT_TYPES = {"tinyint", "smallint", "mediumint", "int", "integer", "bigint", "bit", "year"}
FLOAT_TYPES = {"decimal", "numeric", "float", "double", "real"}
DATE_TYPES = {"date", "datetime", "timestamp", "time"}
ROWS_PER_FILE = 25_000_000
BATCH_ROWS = 200_000


def unescape(body: str) -> str:
    def repl(m: re.Match) -> str:
        if m.group(0) == "''":
            return "'"
        ch = m.group(1)
        return ESCAPES.get(ch, ch)

    return ESC_RE.sub(repl, body)


def parse_value(tok: str):
    if tok.startswith("_binary"):
        return None
    if tok.startswith("'"):
        return unescape(tok[1:-1])
    if tok.upper() == "NULL":
        return None
    if tok.startswith("b'"):
        return tok
    return tok


INT64_MIN, INT64_MAX = -(2**63), 2**63 - 1


def base_type(mysql_type: str) -> str:
    return mysql_type.split()[0].lower()


def arrow_type(mysql_type: str) -> pa.DataType:
    t = base_type(mysql_type)
    if t == "bigint" and "unsigned" in mysql_type.lower():
        return pa.string()  # values can exceed int64
    if t in INT_TYPES:
        return pa.int64()
    if t in FLOAT_TYPES:
        return pa.float64()
    return pa.string()


def convert(value, kind: str):
    if value is None:
        return None
    try:
        if kind == "int":
            if isinstance(value, str) and value.startswith("b'"):
                return int(value[2:-1] or "0", 2)
            number = int(value)
            return number if INT64_MIN <= number <= INT64_MAX else None
        if kind == "float":
            return float(value)
    except ValueError:
        return None
    return value


@dataclass
class TableSpec:
    schema: str
    table: str
    mode: str = "full"
    keys: list[str] = field(default_factory=list)
    order: str | None = None


def load_specs(path: str) -> dict[tuple[str, str], TableSpec]:
    specs: dict[tuple[str, str], TableSpec] = {}
    with open(path, encoding="utf-8") as fh:
        for raw in fh:
            line = raw.split("#", 1)[0].strip()
            if not line:
                continue
            parts = line.split()
            spec = TableSpec(schema=parts[0].lower(), table=parts[1].lower())
            if len(parts) > 2 and parts[2] == "latest":
                spec.mode = "latest"
                spec.keys = parts[3].split(",")
                spec.order = parts[4]
            specs[(spec.schema, spec.table)] = spec
    return specs


class Writer:
    def __init__(self, out_dir: str, schema: str, table: str, columns: list[tuple[str, str]]):
        self.out_dir = out_dir
        self.base = f"{schema}__{table}"
        self.names = [c for c, _ in columns]
        self.kinds = []
        fields = []
        for name, mtype in columns:
            at = arrow_type(mtype)
            fields.append(pa.field(name, at))
            self.kinds.append("int" if at == pa.int64() else "float" if at == pa.float64() else "str")
        self.arrow_schema = pa.schema(fields)
        self.part = 0
        self.rows_in_part = 0
        self.rows = 0
        self.bad = 0
        self.buffer: list[list] = [[] for _ in self.names]
        self.writer = None
        self.files: list[str] = []

    def _open(self):
        name = f"{self.base}.parquet" if self.part == 0 else f"{self.base}.part{self.part:03d}.parquet"
        path = os.path.join(self.out_dir, name)
        self.writer = pq.ParquetWriter(path, self.arrow_schema, compression="zstd")
        self.files.append(path)

    def add(self, values: list):
        if len(values) != len(self.names):
            self.bad += 1
            return
        for i, v in enumerate(values):
            self.buffer[i].append(convert(v, self.kinds[i]))
        self.rows += 1
        self.rows_in_part += 1
        if len(self.buffer[0]) >= BATCH_ROWS:
            self.flush()
        if self.rows_in_part >= ROWS_PER_FILE:
            self.flush()
            self.writer.close()
            self.writer = None
            self.part += 1
            self.rows_in_part = 0

    def flush(self):
        if not self.buffer[0]:
            return
        if self.writer is None:
            self._open()
        batch = pa.record_batch(
            [pa.array(col, type=f.type) for col, f in zip(self.buffer, self.arrow_schema)],
            schema=self.arrow_schema,
        )
        self.writer.write_batch(batch)
        self.buffer = [[] for _ in self.names]

    def close(self) -> dict:
        self.flush()
        if self.writer is None and not self.files:
            self._open()
            self.writer.write_table(self.arrow_schema.empty_table())
        if self.writer is not None:
            self.writer.close()
        out = []
        for path in self.files:
            digest = hashlib.sha256()
            with open(path, "rb") as fh:
                for chunk in iter(lambda: fh.read(1 << 20), b""):
                    digest.update(chunk)
            out.append({"file": os.path.basename(path), "bytes": os.path.getsize(path), "sha256": digest.hexdigest()})
        return {"rows": self.rows, "bad_rows": self.bad, "files": out}


def fast_rows(values_text: str):
    """Split a VALUES list that contains no quoted text other than dates."""
    body = values_text.strip().rstrip(";").strip()
    if body.startswith("(") and body.endswith(")"):
        body = body[1:-1]
    for chunk in body.split("),("):
        yield [None if v == "NULL" else (v[1:-1] if v.startswith("'") else v) for v in chunk.split(",")]


def slow_rows(values_text: str):
    row = None
    for m in TOKEN_RE.finditer(values_text):
        tok = m.group(0)
        if tok.isspace():
            continue
        if tok == "(":
            row = []
        elif tok == ")":
            if row is not None:
                yield row
            row = None
        elif tok == ",":
            continue
        elif row is not None:
            row.append(parse_value(tok))


class DumpReader:
    def __init__(self, schema: str, specs: dict, out_dir: str, ddl_path: str):
        self.schema = schema
        self.specs = {k[1]: v for k, v in specs.items() if k[0] == schema}
        self.out_dir = out_dir
        self.ddl_path = ddl_path
        self.columns: dict[str, list[tuple[str, str]]] = {}
        self.insert_bytes: dict[str, int] = {}
        self.writers: dict[str, Writer] = {}
        self.latest: dict[str, dict] = {}
        self.fast: dict[str, bool] = {}

    def _ddl(self, lines: list[str]):
        with open(self.ddl_path, "a", encoding="utf-8") as fh:
            fh.write("".join(lines).rstrip() + "\n\n")

    def read(self, stream):
        in_create = None
        create_lines: list[str] = []
        for raw in stream:
            line = raw.decode("utf-8", errors="replace")
            if in_create is not None:
                create_lines.append(line)
                m = COLUMN_RE.match(line)
                if m:
                    unsigned = " unsigned" if "unsigned" in m.group(3).lower() else ""
                    self.columns[in_create].append((m.group(1), m.group(2) + unsigned))
                if line.startswith(")"):
                    self._ddl(create_lines)
                    in_create = None
                continue
            m = CREATE_RE.match(line)
            if m:
                in_create = m.group(1).lower()
                self.columns[in_create] = []
                create_lines = [line]
                continue
            m = INSERT_RE.match(line)
            if not m:
                continue
            table = m.group(1).lower()
            self.insert_bytes[table] = self.insert_bytes.get(table, 0) + len(raw)
            spec = self.specs.get(table)
            if spec is None:
                continue
            cols = self.columns.get(table)
            if m.group(2):
                names = [c.strip().strip("`") for c in m.group(2).split(",")]
                known = dict(cols or [])
                cols = [(n, known.get(n, "varchar")) for n in names]
            if not cols:
                continue
            values_text = line[m.end():]
            if table not in self.fast:
                self.fast[table] = all(base_type(t) in INT_TYPES | FLOAT_TYPES | DATE_TYPES for _, t in cols)
            rows = fast_rows(values_text) if self.fast[table] else slow_rows(values_text)
            if spec.mode == "latest":
                self._latest(table, spec, cols, rows)
            else:
                writer = self.writers.get(table)
                if writer is None:
                    writer = self.writers[table] = Writer(self.out_dir, self.schema, table, cols)
                for row in rows:
                    writer.add(row)

    def _latest(self, table: str, spec: TableSpec, cols, rows):
        state = self.latest.setdefault(table, {"cols": cols, "rows": {}, "seen": 0})
        names = [c for c, _ in cols]
        key_idx = [names.index(k) for k in spec.keys]
        order_idx = names.index(spec.order)
        store = state["rows"]
        for row in rows:
            state["seen"] += 1
            if len(row) != len(names):
                continue
            key = tuple(row[i] for i in key_idx)
            prev = store.get(key)
            if prev is None or (row[order_idx] or "") >= (prev[order_idx] or ""):
                store[key] = row

    def finish(self) -> dict:
        report = {}
        for table, writer in self.writers.items():
            report[table] = {"mode": "full", **writer.close()}
        for table, state in self.latest.items():
            writer = Writer(self.out_dir, self.schema, f"{table}_latest", state["cols"])
            for row in state["rows"].values():
                writer.add(row)
            report[f"{table}_latest"] = {"mode": "latest", "source_rows": state["seen"], **writer.close()}
        return report


def summary(reader: DumpReader) -> dict:
    return {
        "tables_seen": sorted(set(reader.columns) | set(reader.insert_bytes)),
        "insert_bytes": dict(sorted(reader.insert_bytes.items(), key=lambda kv: -kv[1])),
        "columns": {t: [f"{c} {k}" for c, k in cols] for t, cols in sorted(reader.columns.items())},
    }


def dump_json(obj, path: str):
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(obj, fh, ensure_ascii=False, indent=1, sort_keys=False)
        fh.write("\n")
