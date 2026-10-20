# One Dust — Test and Verification Coverage

## Scope and baseline

This matrix links selected contract properties to existing local tests and
recorded BSC Testnet checks. It is not a claim that every possible input,
execution sequence, or integration has been covered.

- Source: `src/OneDust.sol`.
- Source SHA-256:
  `6c0d64c392d93fde32c23ad4e990149b822b544224cdecbb9bbdc1aa0ad063ff`.
- Recorded local regression: 2026-10-20, 42 passed, 0 failed, 0 skipped.
- Testnet contract: `0x90d12Fc13A445337285Ae94F4a83295058076E1d`;
  chain ID 97.
- Mainnet checks are outside this matrix.

## Evidence references

- [Local regression summary](test-evidence/local/regression.json)
  and [log](test-evidence/local/regression.log).
- [Testnet Genesis Report](build-evidence/testnet/Genesis-Report.md).
- [Deployment verification](build-evidence/testnet/deployment-verification.json).
- [Runtime comparison](build-evidence/testnet/runtime-comparison.json).
- [Historical transaction verification](test-evidence/testnet/historical-transactions.json)
  and [transaction table](test-evidence/testnet/historical-transactions.csv).
- [Supplementary checks](test-evidence/testnet/supplementary-checks.json).
- [Dated test log](Test-Log.md).

## Behavioral coverage

Test-function references identify assertions in the test source, not separate
claims of complete coverage. Network transactions and simulations are distinct.

| Property | Local test references | Recorded network evidence / boundary | Coverage mode |
|---|---|---|---|
| Constructor, initial roles and supply | [`test_InitialStateAndRoles`](../test/OneDust.t.sol)<br>[`test_ConstructorEventsAndDeployerSeparation`](../test/OneDust.t.sol) | Deployment receipt: five RoleGranted events and initial mint; Genesis Report. | Local + deployment evidence |
| Zero-address constructor rejection | [`test_ConstructorRejectsZeroSafe0`](../test/OneDust.t.sol)<br>[`test_ConstructorRejectsZeroSafe1`](../test/OneDust.t.sol)<br>[`test_ConstructorRejectsZeroSafe2`](../test/OneDust.t.sol)<br>[`test_ConstructorRejectsZeroSafe3`](../test/OneDust.t.sol)<br>[`test_ConstructorRejectsZeroSafe4`](../test/OneDust.t.sol) | Not exercised by creating deliberately invalid network deployments. | Local |
| Transfer, approve and transferFrom; failed-operation state | [`test_TransferAndAllowanceFailuresDoNotChangeState`](../test/OneDust.t.sol) | Historical transactions 1-5. | Local + testnet |
| Ordinary burn and allowance-based burnFrom | [`test_OrdinaryBurnAndBurnFrom`](../test/OneDust.t.sol) | Historical transaction 6 covers burn; restored burnFrom is covered by supplementary simulations. | Local + testnet, different execution modes |
| Mint authorization and Treasury-recipient gate | [`test_MintAuthorizationAndTreasuryLifecycle`](../test/OneDust.t.sol)<br>[`test_MintEventsZeroRecipientAndFrozenSecondTreasury`](../test/OneDust.t.sol) | Historical transactions 7-10; supplementary Treasury grant and cleanup checks. | Local + testnet |
| Mint rejects a frozen Treasury recipient | [`test_FrozenTreasuryCannotReceiveMint`](../test/OneDust.t.sol)<br>[`test_FrozenTreasuryRoleRecipientCannotMint`](../test/OneDust.t.sol) | Supplementary frozen_treasury_and_oversized_burn. | Local + testnet simulation |
| Role grant/revoke and loss of operational permissions | [`test_AdminControlsEachOperationalRoleAndEvents`](../test/OneDust.t.sol)<br>[`test_NonAdminCannotManageRoles`](../test/OneDust.t.sol)<br>[`test_RevokedMinterCannotMint`](../test/OneDust.t.sol)<br>[`test_RevokedComplianceCannotFreezeOrUnfreeze`](../test/OneDust.t.sol) | Historical and supplementary Treasury-role grant/revoke; not every operational-role revocation was executed on chain. | Local; selected testnet role actions |
| Admin can acquire operational roles | [`test_AdminCanAcquireRolesAndRevokeBurner`](../test/OneDust.t.sol) | No claim that initial role separation is permanently enforced. | Local |
| Freeze/unfreeze authorization, transitions and events | [`test_ComplianceAuthorizationAndTransitions`](../test/OneDust.t.sol)<br>[`test_FreezeAndUnfreezeEvents`](../test/OneDust.t.sol)<br>[`test_OnlyComplianceCanFreezeAndUnfreeze`](../test/OneDust.t.sol) | Historical transactions 11, 13-15; supplementary spender and Treasury cycles. | Local + testnet |
| Frozen holder and recipient restrictions | [`test_FrozenHolderRecipientAndUnfreeze`](../test/OneDust.t.sol)<br>[`test_FrozenOwnerCannotBurnFromAndUnfreezeRestoresActions`](../test/OneDust.t.sol) | Historical freeze/unfreeze cycle; see scope notes for simulation coverage. | Local; selected testnet checks |
| Frozen owner/spender approval restrictions | [`test_FrozenOwnerAndSpenderCannotApprove`](../test/OneDust.t.sol)<br>[`test_FrozenOwnerApproveHandlerPath`](../test/OneDust.invariant.t.sol) | Supplementary frozen spender: approval to frozen spender rejected. | Local + selected testnet simulation |
| Frozen spender cannot use finite or infinite allowance | [`test_FrozenSpenderCannotSpendFiniteAllowance`](../test/OneDust.t.sol)<br>[`test_FrozenSpenderCannotSpendInfiniteAllowance`](../test/OneDust.t.sol)<br>[`test_FrozenSpenderCannotBurnExistingAllowance`](../test/OneDust.invariant.t.sol) | Supplementary frozen_spender and spender_unfreeze. | Local + testnet simulations |
| Privileged frozen burn: authorization, amount, events and accounting | [`test_BurnFrozenAuthorizationAndBounds`](../test/OneDust.t.sol)<br>[`test_BurnFrozenRequiresBurnerAndEmitsBothEvents`](../test/OneDust.t.sol)<br>[`testFuzz_BurnFrozenPreservesBalanceAndSupply`](../test/OneDust.t.sol) | Historical transaction 12; supplementary oversized-burn rejection. | Local + testnet |
| Supply accounting over operation sequences | [`invariant_SupplyMatchesGhostAccounting`](../test/OneDust.invariant.t.sol)<br>[`invariant_SupplyMatchesAllTrackedBalances`](../test/OneDust.invariant.t.sol)<br>[`invariant_SupplyTracksRoleDependentOperations`](../test/OneDust.invariant.t.sol) | Historical event reconstruction and supplementary final balance accounting. | Local invariants + recorded testnet accounting |
| Admin handover and loss of last admin | [`test_AdminHandoverBeforeRevocationPreservesControl`](../test/OneDust.invariant.t.sol)<br>[`test_RevokingSoleAdminMakesRoleManagementUnrecoverable`](../test/OneDust.invariant.t.sol)<br>[`test_SoleAdminCanRenounceRole`](../test/OneDust.invariant.t.sol) | Destructive last-admin loss is not required on the existing network contract. | Local |
| Constructor with the testnet address configuration | [`testConstructorWithTestnetEOAs`](../test/OneDustTestnetDeployment.t.sol) | Separate saved transaction and receipt establish the actual network deployment. | Local configuration test + deployment evidence |

## Additional directed edge-case checks

A separate targeted execution passed three tests, with no failures or skipped
tests. It supplements, rather than replaces, the recorded full 42-test run.

| Property | Test reference | Checked result |
|---|---|---|
| Zero-value allowance revocation while owner or spender is frozen | [`test_FrozenOwnerOrSpenderCannotRevokeAllowanceWithApproveZero`](../test/OneDustEdgeCases.t.sol) | Expected rejection preserves allowance; unfreezing permits approve(0). |
| transferFrom to a frozen recipient | [`test_TransferFromToFrozenRecipientRestoresFiniteAllowanceOnRevert`](../test/OneDustEdgeCases.t.sol) | Expected rejection restores finite allowance and balances; transfer works after unfreeze. |
| Ordinary burn after successful burnFrozen | [`test_SuccessfulFrozenBurnDoesNotEnableOrdinaryFrozenBurn`](../test/OneDustEdgeCases.t.sol) | Ordinary burn remains blocked for both frozen holders; unfreezing restores ordinary burn. |

Evidence: [summary](test-evidence/local/edge-cases.json) and
[log](test-evidence/local/edge-cases.log).

## Important interpretation limits

- The testnet constructor test uses local execution and caller impersonation.
  It does not exercise actual Safe signatures or thresholds.
- Invariant handlers explore selected actions and addresses. Early returns
  count as handler calls without necessarily executing a token operation.
- `invariant_RolesStaySeparated` checks retained initial assignments and
  deployer exclusions, not the absence of every cross-role assignment.
- Some negative handlers accept any revert. Directed tests provide more
  specific error checks for selected paths; a revert count alone is insufficient.
- Supplementary state reads used independent latest calls, not an atomic
  fixed-block snapshot. Before/after fields describe simulation-batch observations.
- Historical balances are reconstructed from verified events, not historical
  state reads. They are not a statement of current chain state.

## Open items and decisions

| Item | Present evidence | Remaining work |
|---|---|---|
| Slither findings | Five historical Informational findings: one pragma and four solc-version. | [Disposition documented](Slither-Review.md): reviewed for the recorded 0.8.37 compiler and saved input; no pragma changes. Not a new analysis or a comprehensive compiler-bug assessment. |
| Fresh deployed-bytecode reproduction | Fresh compilation of the unchanged saved Standard JSON with verified Solc 0.8.37. | [PASS: reproduction report](build-evidence/testnet/compiler-reproduction.json). Full creation bytecode, runtime and deployment input match, including metadata. Compared with retained artifacts and the saved transaction; no new network query. |
| Explorer verified-source status | Operator reported BscScan Testnet Source Code Verified, Exact Match, with matching compiler and optimizer settings. | [Observation recorded](build-evidence/testnet/explorer-verification.json). Based on an operator-supplied page transcription, not an independent API/source download. |
| Directed edge-case assertions | Three additional tests passed in a separate targeted run. | [Report](test-evidence/local/edge-cases.json) and [log](test-evidence/local/edge-cases.log). Original source, tests and config hashes remained unchanged; this was not a new full-suite run. |
| Evidence navigation | Core local, deployment, historical and supplementary records exist. | Completed README navigation and staged content review. 81 relative Markdown file links resolved; heading anchors and external websites were not checked. |

An item is closed only by evidence or an explicit, documented scope/risk
decision. This document does not silently mark open items as passed.
