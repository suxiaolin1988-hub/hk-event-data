# hk-event-data

港股事件研究用的公开数据。这里只放允许公开再发布的数据，不放投资判断、观察名单或持仓。

## 数据

| 数据 | 来源 | 许可 | 位置 |
| --- | --- | --- | --- |
| Webb-site 数据库抽取：公司、证券、董事和高管任职、顾问（核数师、财务顾问、包销商等）、公司行动、股权记录、CCASS 参与者、每日集中度、历史行情、每个参与者最后一次记录的 CCASS 持股 | [Webb-site Repository](https://drive.google.com/drive/folders/13mzAvvufXC3QmH8OvMVx2juUi7qdnVLL)，David M. Webb | CC BY 4.0 | Release `webb-<快照日期>`；表清单、行数和校验值见 `data/webb/manifest.json`，建表语句见 `data/webb/schema/` |

Webb 的董事和顾问数据人工维护到 2025-03-31，CCASS 和行情数据到快照日期为止。

## 不放什么

- 港交所网站的数据，包括披露易和 CCASS 持股查询。港交所网站使用条款禁止程序化访问、数据挖掘和汇编数据库。
- 证监会网站的内容。证监会只允许个人使用，不允许分发给第三方。
- 任何投资判断、概率、观察名单或持仓。

## 更新

`.github/workflows/webb-mirror.yml` 每月 2 日检查 Webb 的 Drive 文件夹有没有新快照，有就重新抽取。也可以在 Actions 页面手动运行。

要增减表，改 `scripts/webb_tables.txt`。

## 读取

```python
import pandas as pd

base = "https://github.com/suxiaolin1988-hub/hk-event-data/releases/download/webb-251227"
people = pd.read_parquet(f"{base}/enigma__people.parquet")
```

## 致谢

Data: Webb-site Repository by David M. Webb, licensed [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). 原始版权声明和本仓库所做的修改见 [LICENSE-DATA.md](LICENSE-DATA.md)。
