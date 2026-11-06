"""Download the latest Webb-site snapshot from Google Drive and extract tables.

Writes Parquet files to --out and metadata to data/webb/. Prints GitHub
Actions outputs (snapshot=..., skip=...) on stdout.
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import webb_extract as wx  # noqa: E402

FOLDERS = {
    # schema: (Google Drive folder id, fallback file name, fallback file id)
    "enigma": ("17cxw-QzMrV-35pdzsskJ1Lnfkod0BpvV", "enigma251227.7z", "1AUpdv6nXd5G46dyUU-ydDL4rEUjbeoz5"),
    "ccass": ("1tCWQbh-abLsoVlD0ONmyeqv2QjkD_3y4", "ccass251227.7z", "1Kj8U5ToOH8AOyMf00oYAZr-rZNpjedmj"),
}
SNAP_RE = re.compile(r"(\d{6})\.7z$")
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
META_DIR = os.path.join(ROOT, "data", "webb")


def log(msg: str):
    print(msg, file=sys.stderr, flush=True)


def latest_archive(schema: str) -> tuple[str, str]:
    folder, fb_name, fb_id = FOLDERS[schema]
    try:
        import gdown

        files = gdown.download_folder(id=folder, skip_download=True, quiet=True) or []
        archives = [(f.path, f.id) for f in files if SNAP_RE.search(f.path)]
        if archives:
            return max(archives, key=lambda a: SNAP_RE.search(a[0]).group(1))
        log(f"{schema}: no .7z found in folder listing; using fallback")
    except Exception as exc:  # listing is best effort
        log(f"{schema}: folder listing failed ({exc}); using fallback")
    return fb_name, fb_id


def members(archive: str) -> list[str]:
    out = subprocess.run(["7z", "l", "-slt", archive], check=True, capture_output=True, text=True).stdout
    names = [line[7:] for line in out.splitlines() if line.startswith("Path = ")]
    return [n for n in names if n.lower().endswith(".sql")]


def member_order(name: str) -> int:
    low = name.lower()
    if "struct" in low:
        return 0
    if "trigger" in low:
        return 2
    return 1


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", required=True)
    ap.add_argument("--work", default=os.environ.get("RUNNER_TEMP", "/tmp") + "/webb")
    ap.add_argument("--force", action="store_true")
    args = ap.parse_args()

    os.makedirs(args.out, exist_ok=True)
    os.makedirs(args.work, exist_ok=True)
    os.makedirs(os.path.join(META_DIR, "schema"), exist_ok=True)

    manifest_path = os.path.join(META_DIR, "manifest.json")
    previous = {}
    if os.path.exists(manifest_path):
        with open(manifest_path, encoding="utf-8") as fh:
            previous = json.load(fh)

    chosen = {schema: latest_archive(schema) for schema in FOLDERS}
    snaps = {s: SNAP_RE.search(name).group(1) for s, (name, _) in chosen.items()}
    snapshot = max(snaps.values())
    log(f"latest archives: {chosen}")
    if not args.force and previous.get("snapshots") == snaps:
        print(f"snapshot={snapshot}")
        print("skip=true")
        log("snapshot unchanged; nothing to do")
        return 0

    specs = wx.load_specs(os.path.join(ROOT, "scripts", "webb_tables.txt"))
    report = {
        "source": "Webb-site Repository by David M. Webb, CC BY 4.0",
        "source_url": "https://drive.google.com/drive/folders/13mzAvvufXC3QmH8OvMVx2juUi7qdnVLL",
        "built_at": dt.datetime.now(dt.timezone.utc).isoformat(timespec="seconds"),
        "snapshots": snaps,
        "archives": {s: {"name": n, "drive_id": i} for s, (n, i) in chosen.items()},
        "tables": {},
        "dump_summary": {},
    }

    import gdown

    for schema, (name, file_id) in chosen.items():
        path = os.path.join(args.work, name)
        if not os.path.exists(path):
            log(f"downloading {name}")
            gdown.download(id=file_id, output=path, quiet=False)
        ddl_path = os.path.join(META_DIR, "schema", f"{schema}_tables.sql")
        open(ddl_path, "w").close()
        reader = wx.DumpReader(schema, specs, args.out, ddl_path)
        for member in sorted(members(path), key=member_order):
            if member_order(member) == 2:
                continue
            log(f"streaming {name}:{member}")
            proc = subprocess.Popen(["7z", "x", "-so", path, member], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
            reader.read(proc.stdout)
            if proc.wait() != 0:
                raise RuntimeError(f"7z failed on {member}")
        for table, info in reader.finish().items():
            report["tables"][f"{schema}.{table}"] = info
        report["dump_summary"][schema] = wx.summary(reader)
        os.remove(path)

    wx.dump_json(report, manifest_path)
    print(f"snapshot={snapshot}")
    print("skip=false")
    return 0


if __name__ == "__main__":
    sys.exit(main())
