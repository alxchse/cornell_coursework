# PS1 data and provenance

All files in this directory are instructor-generated synthetic teaching values, not
experimental observations.

- `atomic-masses.csv` holds 33 element symbols with atomic masses in amu, abridged to
  three decimals from the IUPAC standard atomic weights. It is the only mass table the
  problem set uses, so every published checksum is defined against this file.
- `test_part_1.txt` and `test_part_2.txt` are small worked manifests whose line-by-line
  molecular weights appear in the top-level README.
- `production_part_1.txt` and `production_part_2.txt` each hold 150 formulas: a few
  recognizable molecules plus deterministic random compositions (seed 2026). Part 1
  uses single-letter element symbols only; Part 2 draws on all 33 entries in the supplied table.

SHA-256 digests of the authored files:

```
b3a9751e8c5c97292a292fdf8e45f60b230a15c8c7c33d6b8e96c0743fb30d71  atomic-masses.csv
5e93fff649a5ec647079c50f77f9cdf791612849f5b4114f3141811bf1dcb614  test_part_1.txt
b3d9a6d54c339bd4019e29cc6f83cc7af2a55b943ae7cb6be120a18fce4efa25  test_part_2.txt
ac27f4086b2b7c62c64349e7731b86f8f2ad85c9a1dbe920c24b8946e36c3b46  production_part_1.txt
eabd88bb0b26bb3f6fe3e3f55a4047da0f7d37cd5d03c6088f8b171d276fcb53  production_part_2.txt
```
