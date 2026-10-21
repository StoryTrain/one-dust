# One Dust — Mainnet Verification Evidence

## Scope

This directory contains completed, separately dated observations for
`0x3713e7f7413f01019a9f63e9541b6e3ddef72c48` on BNB Smart Chain Mainnet, chain ID 56.

See the [Genesis Report](../../build-evidence/mainnet/Genesis-Report.md)
for deployment context. Documentation export time is not a new chain-state read.

## Evidence index

| Record | Scope |
|---|---|
| [token-state.json](token-state.json) | 47 view calls at one fixed block |
| [safe-config.json](safe-config.json) | Five Safe owner/threshold/configuration observations |
| [safe-code-identity.json](safe-code-identity.json) | Singleton/fallback official codeHash comparisons |
| [safe-execution.json](safe-execution.json) | Five historical native-BNB Safe test executions |
| [safe-transactions.json](safe-transactions.json) | Six transaction/receipt pairs and selected block-header fields |
| [safe-admin-approval.json](safe-admin-approval.json) | Safe_2 preapproval preceding nested Admin execution |
| [event-history.json](event-history.json) | Contiguous window coverage and reconstructed role holders |
| [token-events.json](token-events.json) | Six returned token events |

## Observation blocks

| Observation | Block | Block UTC |
|---|---|---|
| Token state | 128823144 | 2026-10-20T22:06:16Z |
| Safe configuration | 128825311 | 2026-10-20T22:22:31Z |
| Code identity/pointer consistency | 128825941 | 2026-10-20T22:27:15Z |

These are different observations, not one atomic snapshot.
Token event history ends at block 128823144.

At the token-state block, total supply and Treasury balance were both
50,000,000 1DUST. The five corresponding token roles were present at the
listed Safe addresses. The creator held none of the five checked token roles.
All six checked addresses were unfrozen.

## Observed Safe configuration

| Safe | Threshold / owner count | Reported VERSION | Nonce |
|---|---|---|---|
| Safe_0 Admin | 2 of 3 | `1.5.0` | 1 |
| Safe_1 Minter | 2 of 3 | `1.5.0` | 2 |
| Safe_2 Compliance | 2 of 3 | `1.5.0` | 2 |
| Safe_3 Burner | 3 of 5 | `1.5.0` | 1 |
| Safe_4 Treasury | 2 of 3 | `1.5.0` | 1 |

Owners, modules and standard storage slots are retained in the configuration
record. Admin's owners are the three operational Safe addresses, not three
EOA addresses. Empty modules and zero guard slots describe the recorded block.

Singleton and fallback code matched the pinned official Safe registry.
Proxy code was checked for consistency, not independent official provenance.

## Historical execution

| Safe case | Transaction block UTC | Transaction | Result |
|---|---|---|---|
| Safe_0 Admin | 2026-09-27T04:59:32+00:00 | `0x6eebd6159bec20690d1d9659c76dd9d893e906cdc35e4d27309c598b5ebb6912` | PASS |
| Safe_1 Minter | 2026-09-25T07:43:25+00:00 | `0x53e26a41fd3a347a249af449a917047b0b5df0502b2ebb94c040b970f811b993` | PASS |
| Safe_2 Compliance | 2026-09-25T08:21:55+00:00 | `0x0caa670afbf02f13a037e9ce44f8ef6047c021d7fea90f3fd0db053adc4b9e97` | PASS |
| Safe_3 Burner | 2026-09-25T09:06:32+00:00 | `0xdf2731b4dcae911bacde899b5e8d10e1f8e22637eb790d4ceadc64d621a161b0` | PASS |
| Safe_4 Treasury | 2026-09-25T09:34:46+00:00 | `0x9cd47a8888849ba878203d3741c700a77fb52713eabf9d00514e35214ddb3369` | PASS |

Each test transfers 0.001 native BNB at the appropriate inner execution level.
The Admin case uses nested Safe_1 → Safe_0 execution. Safe_2 preapproved the
Admin hash in a separate earlier transaction. Calldata, receipt/block references
and the relevant success events are documented.

These September 2026 wallet tests predate the October token deployment.
They are not new transactions, token transfers or OneDust mint/burn smoke-tests.

## Event history

Inclusive range: 125679825–128823144.
All 315 contiguous windows completed. Six events were returned, matching the
deployment receipt. There were no non-genesis events in the returned history.

Role-event counts: RoleGranted 5; RoleRevoked 0; RoleAdminChanged 0.
The reconstructed role holders agree with the token-state record.

The window table retains ranges, counts and response digests. The event array
is a separate aggregate. Single-provider coverage is not an independent
cryptographic completeness proof and does not exclude reverted/eventless calls.

## Interpretation limits

- Independent ECDSA signer recovery and full historical owner-state reconstruction
  were not performed.
- Successful historical execution does not establish current signer availability,
  person-level independence, key custody, backups or recovery readiness.
- Standard storage interpretation is used for Safe configuration; proxy official
  provenance remains outside the completed code-identity claim.
- State observations are bounded by their blocks and are not current-state guarantees.
- Explorer Exact Match is an operator-transcribed observation documented
  [separately](../../build-evidence/mainnet/explorer-verification.json).
- No independent security audit, LP custody/lock assessment, market-integration
  approval or legal/financial readiness conclusion is established.

The local [42-test regression](../local/regression.json) and
[three directed tests](../local/edge-cases.json) remain separate local executions.
They were not rerun during documentation export.
