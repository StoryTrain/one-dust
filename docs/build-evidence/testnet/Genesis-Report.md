# One Dust (1DUST) — Testnet Genesis Report

## Scope

This report identifies the testnet deployment and its constructor events.
It does not report mainnet validation or constitute an independent audit.
The recorded deployment verification was performed on 2026-10-19.

## Deployment

| Field | Value |
|---|---|
| Network / chain ID | BNB Smart Chain Testnet / 97 |
| Contract | `0x90d12fc13a445337285ae94f4a83295058076e1d` |
| Deployment transaction | `0x276f6766b3cfee5dc4482cc2dddee3a8756f87d536a0b44606a60296fb0a5ab6` |
| Block | `134768448` |
| Block hash | `0xf21ee39a81bb08d93f7bb4ffd7732e4d017e905ff0e886f4c38466f4e79193fc` |
| Deployer | `0xe64619eeadce3ec495991a5f7fcc57cfb82b47cc` |
| Receipt status | Success |
| Transaction value | 0 |
| Creation bytecode | 14,627 bytes |
| Constructor arguments | 160 bytes |
| Full deployment input | 14,787 bytes |

Transaction and receipt fields are retained in
[deployment-transaction.json](deployment-transaction.json) and
[deployment-receipt.json](deployment-receipt.json).
These are structured objects extracted from recorded responses, not new
network queries or cryptographic inclusion proofs.

## Initial roles and supply

The five constructor recipients are distinct and separate from the deployer.
The receipt contains five RoleGranted events, with the deployer as operator,
followed by one initial mint Transfer.

| Role | Initial recipient |
|---|---|
| `DEFAULT_ADMIN_ROLE` | `0xa42db27670fceb0f236aa5450396adcc9b5bfb01` |
| `MINTER_ROLE` | `0x8f2325d4e7c520fdf93470b73fccdeed1e5fadc4` |
| `COMPLIANCE_ROLE` | `0xb3323caad76a0745fe6a260753fd608d89655c83` |
| `BURNER_ROLE` | `0x9823e7401126bf5ebcc21bbb6174a74365ab9ced` |
| `TREASURY_ROLE` | `0x031fc27d09bb5caa0f8d6a81b2e94c51dbcd06d2` |

The initial Transfer is from the zero address to the Treasury above,
for exactly 50,000,000 × 10^18 base units (50,000,000 1DUST).
Post-drill balances and supply are not the genesis state.

These constructor recipients are the testnet EOA configuration, not the
mainnet Safe configuration.

## Explorer source verification

The operator reported BscScan Testnet `Source Code Verified — Exact Match`
for this address, with compiler `v0.8.37+commit.f401782d` and optimization
`No with 200 runs`. See the [observation record](explorer-verification.json)
for provenance and scope. This is distinct from the bytecode reproduction.

## Source and compilation evidence

- Repository source SHA-256:
  `6c0d64c392d93fde32c23ad4e990149b822b544224cdecbb9bbdc1aa0ad063ff`.
- Full deployment-input SHA-256:
  `426aba105d66c917f8d0089c7b2a171e576767b225405f4fb2028fc526948bcf`.
- Retained creation bytecode plus constructor arguments exactly matches
  the transaction input.
- See [the build description](README.md),
  [deployment verification](deployment-verification.json), and
  [runtime comparison](runtime-comparison.json).
- The original saved-artifact comparison did not perform fresh compiler reproduction.
- A later [fresh compiler reproduction](compiler-reproduction.json) matched the complete creation bytecode, runtime and deployment input, including metadata.

## Subsequent testing

Later operations are documented separately in
[the test log](../../Test-Log.md) and
[the functional transaction report](../../test-evidence/testnet/historical-transactions.json).

Historical observations do not establish the current role memberships,
balances, or freeze flags.
