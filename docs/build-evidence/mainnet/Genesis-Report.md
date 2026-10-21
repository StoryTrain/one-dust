# One Dust (1DUST) — Mainnet Genesis and Verification Report

## Scope

This report identifies the BNB Smart Chain Mainnet deployment and summarizes
separately dated technical observations. It is not an independent security audit
or approval to launch liquidity. Configuration, state and historical execution
records are not one atomic snapshot.

## Deployment

| Field | Recorded value |
|---|---|
| Network / chain ID | BNB Smart Chain Mainnet / 56 |
| Contract | `0x3713e7f7413f01019a9f63e9541b6e3ddef72c48` |
| Deployment transaction | `0x0aa17ce92110056a7c5c2cf1dd1d1093b2ec3264537ab6d91ced01870a791926` |
| Deployment block | `125679825` |
| Deployment UTC | `2026-10-04T12:54:47Z` |
| Creator | `0xa42db27670fceb0f236aa5450396adcc9b5bfb01` |
| Receipt status | Success |
| Creation code | 14,627 bytes |
| Constructor arguments | 160 bytes |
| Full deployment input | 14,787 bytes |
| Runtime | 10,071 bytes at block 128819984 |
| Repository source SHA-256 | `6c0d64c392d93fde32c23ad4e990149b822b544224cdecbb9bbdc1aa0ad063ff` |

Evidence: [transaction](deployment-transaction.json),
[receipt](deployment-receipt.json),
[bytecode comparison](bytecode-comparison.json),
[constructor arguments](OneDust_constructor_args.hex) and
[runtime](OneDust_onchain_runtime.hex).

## Initial roles and issuance

The constructor receipt contains five RoleGranted events followed by the initial
Transfer from the zero address to Treasury. The initial issuance was exactly
50,000,000 1DUST, or 50,000,000 × 10^18 base units.

| Role | Initial recipient | Observed Safe threshold |
|---|---|---|
| `DEFAULT_ADMIN_ROLE` | `0x6e7153abe3d9040059cbe6861f5219cd2327bc14` | 2 of 3 |
| `MINTER_ROLE` | `0xb72609fb717f84631d6b2207e832948b1b86d9e3` | 2 of 3 |
| `COMPLIANCE_ROLE` | `0xfeb99c8d622bb3028668086be92ac7346f781a52` | 2 of 3 |
| `BURNER_ROLE` | `0x30a2681481607bb594c3d15f24a5e740484598c1` | 3 of 5 |
| `TREASURY_ROLE` | `0x60c63b66355b0107ec3faa4a916f9e956a79ddf8` | 2 of 3 |

Thresholds above come from the separate configuration observation at block
128825311, not a historical storage query at deployment.

The creator is separate from these five role recipients. At token-state block
128823144, the creator had none of the five checked token roles and a zero
token balance. This is not a statement about possession of signer keys.

## Bytecode and explorer observation

The complete mainnet creation code and runtime matched the retained testnet
artifacts. The full mainnet deployment input matched that creation code followed
by the five expected mainnet constructor arguments. Metadata was not stripped.

The retained [compiler input](../testnet/OneDust_verify_standard_input.json)
and the earlier [compiler reproduction](../testnet/compiler-reproduction.json)
are referenced by the comparison report. They are reused build references,
not newly downloaded mainnet compiler input or a new compiler execution.

The operator-provided explorer page transcription reported Source Code Verified
— Exact Match, compiler `v0.8.37+commit.f401782d`,
optimizer disabled with 200 runs, and `default evmVersion`.
See [the observation record](explorer-verification.json).
This was not an independent explorer source-code API download.

## Token state and event history

At block 128823144, timestamp 2026-10-20T22:06:16Z:

- Total supply: 50,000,000 1DUST.
- Treasury balance: 50,000,000 1DUST at `0x60c63b66355b0107ec3faa4a916f9e956a79ddf8`.
- The five listed role recipients retained their corresponding checked roles.
- `isFrozen` returned `false` for all six checked addresses, including creator.

The [event-history report](../../test-evidence/mainnet/event-history.json)
covers blocks 125679825–128823144 inclusively:
315 contiguous query windows returned only the six deployment events.
Returned role-event counts were five RoleGranted, zero RoleRevoked and zero
RoleAdminChanged. The reconstructed role holders agreed with the listed-address
state checks.

This is single-provider returned history, not independent cryptographic proof
of completeness. Event history does not rule out reverted or eventless calls.
It is not a statement about blocks after the recorded upper boundary.

## Safe configuration and execution

[Configuration](../../test-evidence/mainnet/safe-config.json) was observed
at block 128825311. All five owner sets and thresholds matched the recorded
baseline; module lists were empty and both standard guard slots were zero.

Admin Safe_0 is nested: its three owners are Safe_1, Safe_2 and Safe_3.
Its 2-of-3 threshold is at the Safe-owner level, not two EOA signatures directly.

[Code identity](../../test-evidence/mainnet/safe-code-identity.json) matched
SafeL2 and CompatibilityFallbackHandler to official registry commit
`e9cc9798ab834e7fe515d361566eb4a28c65387f` at block 128825941.
Proxy code was consistent between observations; independent official proxy-code
provenance was not established.

[Historical execution evidence](../../test-evidence/mainnet/safe-execution.json)
verified five earlier native-BNB test operations. Four were direct Safe calls.
The Admin case followed Safe_1 → Safe_0 → a 0.001 BNB transfer to Hot Operations.

[Safe_2 preapproval](../../test-evidence/mainnet/safe-admin-approval.json)
verified transaction `0xb77c8ca650c4f47bed3572b73915a665daba8abd30ca6804898ec63a778db2e8` at
2026-09-27T04:52:38Z, before Admin execution.
ApproveHash identified Safe_2 and the expected Admin Safe transaction hash.
Both the approval operation and later nested execution had the checked
ExecutionSuccess events.

These Safe operations predate token deployment and are not OneDust mint/burn tests.
No new token mint/burn smoke-test was performed for this evidence set.

## Administrative powers and limitations

- The source permits additional role-controlled minting without a hard supply cap.
  Mint recipients must satisfy the Treasury-role gate.
- Admin can grant/revoke roles, including operational roles and Treasury roles.
- Compliance can freeze/unfreeze addresses; privileged frozen-balance burning
  is available to the Burner role under the contract's conditions.
- Off-chain governance procedures are not represented as contract-enforced
  voting or timelocks.
- No independent security audit or independent ECDSA signer recovery is claimed.
- Historical owner configurations were not completely reconstructed.
  Current configuration observations are not substituted for historical state.
- Signer availability, identity independence, key custody, backups and recovery
  readiness are not established by these records.
- LP custody/locks, market integration, listings and legal/financial readiness
  are outside this report. No security, price or liquidity guarantee is given.

See [build evidence](README.md) and
[mainnet verification evidence](../../test-evidence/mainnet/README.md).
