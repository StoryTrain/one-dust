# 1DUST — Test Log

Local development, BSC Testnet and BSC Mainnet checks for `src/OneDust.sol`.
Entries record observations at the stated UTC time, not current chain state.
PASS applies only to the stated check. This log is not an independent
security audit and does not establish mainnet Safe operational readiness.

The Development environment table below describes the historical local runs.
Later runs identify their own tools and settings where recorded.

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
| 16 | 2026-10-19T15:36:22Z | Post-drill state snapshot | BSC Testnet / 97 | Read state at block 137725881. | State agrees with the recorded drill. | Supply 50,000,490 1DUST; Treasury 49,989,000; walletA 8,790; walletB 2,200; treasury2 500. Allowance walletA to spender 400. Checked actor freeze flags cleared; temporary treasury2 role absent. | PASS — recorded snapshot |
| 17 | 2026-10-19T15:50:55Z–15:52:03Z | Restoration and access control | BSC Testnet / 97 | Run 23 independent eth_call checks. | Allowed operations succeed; forbidden operations revert as expected. | All 23 checks matched expectations, including role checks and authorized/unauthorized operation simulations. No transaction sent. | PASS — simulations |
| 18 | 2026-10-19T21:02:36Z–21:08:56Z | Frozen spender and restoration | BSC Testnet / 97 | Verify freeze/unfreeze receipts and simulate affected operations. | Frozen spender cannot spend allowance; unfreeze restores operations. | Receipt, caller, calldata and events matched. Frozen transferFrom, burnFrom and approval were rejected; restored simulations succeeded. Checked balances, supply and allowance unchanged by simulations. | PASS |
| 19 | 2026-10-19T21:35:57Z–22:01:43Z | Treasury role, freeze and cleanup | BSC Testnet / 97 | Verify temporary role grant, freeze, unfreeze and role revocation; simulate mint and burn conditions. | Mint requires an active, unfrozen Treasury recipient; failed oversized burn preserves state. | Mint to frozen treasury2 reverted. Burning 501 with balance 500 returned the expected insufficient-balance error. After unfreeze operations were restored; final role revocation blocked mint. No real mint or burn occurred during this supplementary cycle. | PASS |
| 20 | 2026-10-19T22:29:39Z–22:33:14Z | Saved artifacts and deployment verification | Local + BSC Testnet / 97 | Compare saved Remix/Standard JSON artifacts with source, runtime and original deployment. | Saved artifacts correspond to the checked contract and deployment. | Source comparisons matched, with newline normalization for embedded Remix source. Saved/current full runtime matched Remix: 10,071 bytes. Deployment input, constructor arguments and six initial events matched. No fresh compilation was performed in this check. | PASS — artifact/deployment comparison |
| 21 | 2026-10-19T22:37:40Z–22:38:03Z | Original functional transactions | BSC Testnet / 97 | Verify 15 original calls by receipts, calldata and events. | Calls and event accounting match the recorded drill. | 15/15 verified. Event accounting reproduced supply 50,000,490 and the recorded final balances. Original transactions occurred on 2026-10-04; this check reconstructed events, not historical state reads. | PASS |
| 22 | 2026-10-20T09:45:14Z–09:48:22Z | Full local regression | Local / offline | Fresh build and all test suites using verified local Solc, seed 0x1 and one worker. | Compile and pass the current test set. | Forge 1.8.3; Solc 0.8.37; 33 files compiled. Four suites: 42 passed, 0 failed, 0 skipped; exit 0. Each invariant campaign: 256 runs, depth 500, 128,000 handler calls, 0 reported reverts. Protected project files unchanged. | PASS |
| 23 | 2026-10-20T15:09:29Z–2026-10-20T15:09:29Z | Fresh compiler reproduction | Local | Compile the unchanged saved Standard JSON with verified local Solc 0.8.37. | Reproduce complete saved creation bytecode, runtime and deployment input. | All three byte comparisons matched, including metadata: creation 14627 bytes; runtime 10071 bytes; creation plus arguments 14787 bytes. Compiler diagnostic entries: 0. No network query or deployment. [Report](build-evidence/testnet/compiler-reproduction.json). | PASS |
| 24 | 2026-10-20T15:24:38Z | Explorer verification observation | BSC Testnet / 97 | Record the operator-supplied BscScan page transcription and compare displayed fields with retained evidence. | Establish the reported explorer verification status. | Source Code Verified, Exact Match; OneDust; compiler v0.8.37+commit.f401782d; optimization No with 200 runs; default evmVersion; creator and creation transaction match. Timestamp is record creation time; exact browser-observation UTC was not captured. [Record](build-evidence/testnet/explorer-verification.json). | RECORDED — operator observation |
| 25 | 2026-10-20T15:33:34Z–2026-10-20T15:33:40Z | Directed edge-case tests | Local / offline | Run only test/OneDustEdgeCases.t.sol with verified local Solc 0.8.37. | Check zero-value approval restrictions, frozen-recipient allowance rollback and freeze enforcement after successful privileged burn. | 3 passed, 0 failed, 0 skipped; exit 0. Previous source, test and configuration hashes unchanged. Separate from the full 42-test regression; [report](test-evidence/local/edge-cases.json). | PASS |
| 26 | 2026-10-20T21:42:29Z–2026-10-20T21:42:36Z | Mainnet deployment capture | BSC Mainnet / 56 | Read transaction, receipt, deployment block and runtime at a recorded block. | Match deployment identity and retain source observations. | Contract 0x3713e7f7413f01019a9f63e9541b6e3ddef72c48; deployment block 125679825; successful receipt; input 14787 bytes; six logs; runtime 10071 bytes at block 128819984. [Evidence](build-evidence/mainnet/README.md). | PASS |
| 27 | 2026-10-20T21:48:47Z | Mainnet bytecode and constructor comparison | Local / offline | Compare captured mainnet bytes with retained testnet build references. | Complete creation/runtime/input match and five expected arguments. | Four comparisons passed, including metadata; creation 14627 bytes; arguments 160 bytes; input 14787 bytes; runtime 10071 bytes. No new compilation. [Report](build-evidence/mainnet/bytecode-comparison.json). | PASS |
| 28 | 2026-10-20T21:51:28Z | Mainnet constructor events | Local decoding | Decode the captured deployment receipt. | Five role grants and the initial Treasury mint. | Five expected role recipients and creator sender matched; initial Transfer issued 50,000,000 1DUST to Treasury. [Genesis](build-evidence/mainnet/Genesis-Report.md). | PASS |
| 29 | 2026-10-20T22:06:15Z–2026-10-20T22:06:18Z | Mainnet fixed-block token state | BSC Mainnet / 56 | 47 view calls at one blockHash with requireCanonical=true. | Record supply, balances, freeze flags and listed-address roles. | Block 128823144; supply and Treasury balance 50,000,000; five matching role assignments; creator has none of five checked roles; six flags false. Block hash rechecked. [Report](test-evidence/mainnet/token-state.json). | PASS |
| 30 | 2026-10-20T22:22:31Z–2026-10-20T22:22:33Z | Mainnet Safe configuration | BSC Mainnet / 56 | Read five Safe configurations at one blockHash. | Compare owners/thresholds with baseline and capture control slots. | Block 128825311; five owner sets and thresholds matched; modules empty; standard transaction/module guard slots zero; Admin has three Safe owners. [Report](test-evidence/mainnet/safe-config.json). | PASS |
| 31 | 2026-10-20T22:27:12Z–2026-10-20T22:27:17Z | Safe singleton and fallback identity | GitHub + BSC Mainnet | Compare on-chain Keccak-256 with pinned official registry. | Both code hashes match; recheck pointers and proxy consistency. | Block 128825941; both official codeHash comparisons passed; five pointer/proxy consistency checks passed. Proxy official provenance not established. [Report](test-evidence/mainnet/safe-code-identity.json). | PASS |
| 32 | 2026-10-20T22:38:04Z–2026-10-20T22:45:47Z | Historical Safe test execution | BSC Mainnet evidence + local review | Verify earlier transactions, receipts, blocks, calldata and success events. | Confirm five native-BNB test executions with direct/nested validation. | 5/5 verified: four direct cases and nested Safe_1 to Admin execution. Transactions occurred in September 2026, before token deployment. No independent ECDSA recovery. [Report](test-evidence/mainnet/safe-execution.json). | PASS |
| 33 | 2026-10-20T22:57:11Z–2026-10-20T22:57:15Z | Admin Safe preapproval | BSC Mainnet / 56 | Verify the candidate Safe_2 approval transaction and chronology. | Admin.approveHash has the expected hash and Safe_2 owner. | All checks passed; approval at 2026-09-27T04:52:38Z preceded Admin execution; ApproveHash and Safe_2 ExecutionSuccess matched. [Report](test-evidence/mainnet/safe-admin-approval.json). | PASS |
| 34 | 2026-10-20T23:20:26Z–2026-10-20T23:27:29Z | Mainnet token event history | BSC Mainnet / 56 | Query 315 contiguous windows and compare genesis/boundary references. | Cover the recorded inclusive range and reconstruct returned role events. | Blocks 125679825-128823144; six genesis logs only; RoleGranted 5, RoleRevoked 0, RoleAdminChanged 0; role reconstruction agrees with state checks. Single-provider coverage. [Report](test-evidence/mainnet/event-history.json). | PASS |
| 35 | 2026-10-21T08:58:27Z | Mainnet explorer observation | Operator-provided page transcription | Record displayed verification fields. | Retain reported status with explicit provenance. | Reported Exact Match; OneDust; compiler v0.8.37+commit.f401782d; optimizer disabled/200 runs; default evmVersion. Time is record creation, not exact browser observation. [Record](build-evidence/mainnet/explorer-verification.json). | RECORDED — operator observation |

## Scope and limitations

- Rows 1-25 are earlier local/Testnet records. Testnet contract:
  `0x90d12Fc13A445337285Ae94F4a83295058076E1d`, chain ID 97.
  Mainnet-specific records begin at row 26 and do not change those earlier scopes.
- For the earlier Testnet records, apart from the stated fixed-block snapshot,
  state reads and independent eth_call simulations generally used latest state.
  Those reads do not form one atomic snapshot; simulated changes were not persisted.
- Testnet role holders were EOAs. Those Testnet checks do not verify mainnet
  Safe configuration or nested execution; mainnet rows document separate observations.
- Row 22 used optimizer=false, optimizer_runs=200, via_ir=false and
  evm_version=osaka. Fuzz runs=256; invariant fail_on_revert=false;
  call_override=false; threads=1; invariant_workers=1.
  Handler-call counts include early returns without a token operation.
- Local package metadata reports OpenZeppelin 5.6.1 and forge-std 1.17.0.
  This cleanup did not independently verify all dependency files against
  official releases. The local regression is not a deployed-bytecode
  reproduction or proof of target-network EVM compatibility.
- Historical Slither findings in rows 12-13 are reviewed for the pinned
  compiler and saved input in [Slither-Review.md](Slither-Review.md).
  The five historical findings remain recorded. Later test results do not
  replace the historical 41-test results.
- Saved-artifact comparisons are separate from fresh compiler reproduction
  and explorer verified-source status.
- The documented testnet set is not a claim that no other transactions exist.
- Mainnet token state, Safe configuration and code identity use different fixed
  blocks. Documentation export is not a new state observation.
- Historical Safe native-BNB tests are not OneDust mint/burn smoke-tests.
- Mainnet signature recovery and complete historical owner-state reconstruction
  were not independently performed. Proxy code consistency is not official provenance.
- Mainnet event history is bounded by its block range and provider responses;
  reverted/eventless calls and later blocks are outside that claim.
- These results are not a security guarantee or approval to launch liquidity.
