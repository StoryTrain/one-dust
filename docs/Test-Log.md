# 1DUST — Test Log

Local development checks for `src/OneDust.sol`. Entries record observations at the
stated UTC time, not the current state of the repository. PASS applies only to the
check described in that row. No on-chain deployment or security audit is recorded here.

## Development environment

| Field | Value |
|---|---|
| Setup start date | 2026-10-01 |
| Operating system | Windows 10 Home, 22H2, x64 |
| Git | 2.55.0.windows.5 |
| Foundry / Forge | 1.8.3 |
| Foundry commit | `cae51ad458f6abb64852b7709eb784352429825d` |
| forge-std | 1.17.0 (local `package.json`) |
| Git author | Not recorded |

## Log

| No. | UTC date/time | Stage | Network | Action | Expected result | Actual result | Status |
|---:|---|---|---|---|---|---|---|
| 1 | 2026-10-02T02:42:31Z–02:42:32Z | Repository inventory | Local | `git add -A -- ...`; `git status --short --untracked-files=normal`; `git diff --cached --name-status` | Stage project files without `lib/` or the removed standalone roles test. | Seven project files staged: `.gitignore`, `README.md`, `docs/Test-Log.md`, `foundry.toml`, `src/OneDust.sol`, `test/OneDust.t.sol`, `test/OneDust.invariant.t.sol`. `lib/` untracked; standalone roles test absent from index. No commit or push. | PASS |
| 2 | 2026-10-02T02:46:56Z | Source checksum | Local | `sha256sum src/OneDust.sol` | Record working-tree source hash. | SHA-256: `6c0d64c392d93fde32c23ad4e990149b822b544224cdecbb9bbdc1aa0ad063ff`. | PASS |
| 3 | 2026-10-02T02:49:01Z–02:49:02Z | Source/index consistency | Local | `git diff -- src/OneDust.sol` | No difference between staged and working-tree source. | No diff reported; row 2 records the working-tree hash. | PASS |
| 4 | 2026-10-02T03:02:03Z–03:02:04Z | Build settings | Local | `forge config --json`; inspect `lib/openzeppelin-contracts/package.json` | Identify compiler, settings and local dependency version. | Configured Solc `0.8.37`; optimizer off (configured runs: 200); via-IR off; EVM `osaka`; `src=src`, `out=out`, `libs=["lib"]`. Local OpenZeppelin package version `5.6.1`. | PASS |
| 5 | 2026-10-02T03:04:43Z | Source interface | Local | `sed -n '1,7p;44,81p' src/OneDust.sol` | Check constructor order, zero-address guards, role assignments, supply recipient and mint gate in the inspected source lines. | Solidity pragma `0.8.37`; OpenZeppelin import paths specify `5.6.1`. Constructor: admin, minter, compliance, burner, treasury; five zero-address guards. Initial supply goes to treasury; mint requires `MINTER_ROLE` and a recipient with active `TREASURY_ROLE`. Live Safe addresses not checked. | PASS |
| 6 | 2026-10-02T03:07:01Z | Artifact inventory | Local | Inspect `out/OneDust.sol/OneDust.json` and `out/build-info/*.json` | Check whether expected artifact fields exist before the control build. | Artifact present: 45 ABI entries, creation/deployed bytecode, metadata and rawMetadata. One build-info file reported Solc `0.8.37`. Contents and provenance not independently verified. | PASS |
| 7 | 2026-10-02T03:11:15Z–03:11:16Z | Staged paths | Local | `git diff --cached --name-only` | Check staged path list for unintended files. | Seven paths from row 1; no `.env`, `broadcast/`, `lib/`, deployment/proxy script or standalone roles test in the staged list. Path check only, not a content scan. | PASS |
| 8 | 2026-10-02T03:12:59Z–03:13:01Z | Layout and ignore rules | Local | `cat .gitignore`; bounded `find` excluding `.git/`, `lib/`, `out/`, `cache/`, `broadcast/` | Check minimum ignore rules and inspected project layout. | At the time, `.gitignore` contained `.env`, `.env.*`, `cache/`, `out/`, `broadcast/`, `node_modules/`. Bounded scan found the seven project files from row 1 and no deployment/proxy script. Excluded directories not inspected. | PASS |
| 9 | 2026-10-02T03:15:28Z–03:15:29Z | Secret-indicator scan | Local | `git grep --cached -n -I -i -E` for key, recovery, password and mnemonic terms in seven staged files; disclose path/line only | Triage matches without exposing values. | One match, `README.md:29`, inspected locally and classified by the user as an instruction, not a secret. This keyword scan is not a complete secret review. | PASS |
| 10 | 2026-10-02T03:19:30Z–03:19:35Z | Unit and fuzz tests | Local | `forge test --force --match-path test/OneDust.t.sol -vv` | Compile and pass the unit suite. | Solc `0.8.37`; 31 files compiled. `OneDustTest`: 31 passed, 0 failed, 0 skipped; fuzz test: 256 runs. Exit `0`. | PASS |
| 11 | 2026-10-02T03:21:41Z–03:22:51Z | Invariant tests | Local | `forge test --force --match-path test/OneDust.invariant.t.sol -vv` | Pass both invariant suites and directed tests. | Solc `0.8.37`; 31 files compiled. Each suite: 5 passed; invariant campaign: 256 runs, 128,000 handler calls, 0 reported reverts/discards. Total: 10 passed, 0 failed, 0 skipped; exit `0`. Seed not reported. | PASS |
| 12 | 2026-10-02T03:31:33Z–03:31:37Z | Static analysis | Local | Slither 0.11.6: analyze `.` with `--json` to a new temporary file | Produce a fresh report and enumerate findings. | Analyzed 13 contracts with 102 detectors; JSON `success: true`. Five Informational findings (High confidence): one `pragma`, four `solc-version`. Exit `127` without `--fail-none`; findings pending review. | REVIEW |
| 13 | 2026-10-02T03:36:25Z–03:36:29Z | Compiler and Slither status | Local | Check `forge config --json` and build-info; rerun Slither with `--fail-none --json` to a new temporary file | Confirm actual compiler and test exit-code behavior without dropping findings. | Compiler check at `2026-10-02T03:34:57Z`: configured/build-info Solc `0.8.37`, optimizer off, via-IR off. Rerun: 13 contracts, 102 detectors, JSON `success: true`, same five findings; exit `0` with `--fail-none`. Findings remain open for disposition. | PASS — status check only |
| 14 | 2026-10-02T03:39:17Z–03:40:24Z | Full regression | Local | `forge test --force -vv` | Run all test suites together after Slither's clean/build cycles. | Solc `0.8.37`; 32 files compiled. Unit suite: 31 passed, including fuzz test (256 runs). Two invariant suites: 5 passed each; each campaign 256 runs, 128,000 handler calls, 0 reported reverts. Total: 41 passed, 0 failed, 0 skipped; exit `0`. Seed not reported. | PASS |
| 15 | 2026-10-02T04:35:33Z–04:37:07Z | Fresh staged-tree setup | Local + dependency downloads | Archive staged tree `fa47c6dce3d579bc518e174662444bec7aa38e3c`; `forge install --no-git foundry-rs/forge-std@v1.17.0`; `forge install --no-git OpenZeppelin/openzeppelin-contracts@v5.6.1`; `forge build --force`; `forge test -vv` | Install the documented dependencies in a separate directory, compile and run all tests. | Archive/tar exits `0/0`. Both tagged dependencies installed. Solc `0.8.37`: 32 files compiled; build successful. Three suites: 41 passed, 0 failed, 0 skipped; test exit `0`. Each invariant campaign: 256 runs, 128,000 calls, 0 reported reverts. Seed not reported. The staged tree predates this log entry; no GitHub clone was tested. | PASS |
