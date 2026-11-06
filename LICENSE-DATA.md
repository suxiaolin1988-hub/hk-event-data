# Data licence and attribution

The Webb-site extracts in this repository's releases are derived from the
[Webb-site Repository](https://drive.google.com/drive/folders/13mzAvvufXC3QmH8OvMVx2juUi7qdnVLL)
by David M. Webb, licensed under
[Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

## Changes made

- Only the tables listed in `scripts/webb_tables.txt` are extracted.
- Tables are converted from MySQL dump format to Parquet. Column names are kept as published.
- Identity-document number columns and exact birth month and day are removed from `people` (`HKID`, `HKIDsource`, `MOB`, `DOB`). Year of birth is kept.
- For the CCASS `holdings` table, only the last recorded row for each issue and participant is kept (`ccass__holdings_latest`).
- No values are edited.

## Original copyright and disclaimer

The following notice is reproduced from the Webb-site Repository ("Copyright and disclaimer.docx").

> **Copyright and disclaimer**
>
> If you republish or build on the Webb-site datasets or software, then please acknowledge where you got them. As a matter of law, there's no copyright in facts (data), but there is copyright in the arrangement of data and in the software that I wrote to collect the data. I make all of them available under the Creative Commons CC-BY licence – so you can make commercial or non-commercial use, with attribution. The data are provided "as is" and I and my successors do not accept any liability for their use.
>
> It is my hope that at least one public interest entity will continue my legacy by building on these datasets and making them freely available on the web.
>
> **Mirror this repository**
>
> Please feel welcome to create mirrors (copies) of this "Webb-site Repository" on your own server, ideally with public access, so that if anything happens to the original Google Drive folder after my death then copies will still be available on the internet.
>
> Your copy must include this document.
>
> Carpe diem!
>
> David M Webb MBE
