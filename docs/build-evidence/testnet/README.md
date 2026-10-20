# One Dust — Testnet Build Evidence

These files support the saved-artifact and deployment comparisons described
in [test-log entries 20 and 21](../../Test-Log.md).

## Target

- Network: BNB Smart Chain Testnet.
- Chain ID: 97.
- Contract: `0x90d12Fc13A445337285Ae94F4a83295058076E1d`.
- Original deployment date recorded in the log: 2026-10-04.
- Artifact/deployment rechecks: 2026-10-19.

This directory is not evidence of the mainnet deployment.

## Files

| File | Purpose |
|---|---|
| `OneDust_verify_standard_input.json` | Solidity Standard JSON input containing 11 inline sources and compiler settings. |
| `OneDust_Remix_compData_2026-10-04.json` | Saved Remix compilation report, including compiler input and creation bytecode. |
| `OneDust_constructor_args.hex` | ABI-encoded constructor arguments: five addresses, 160 decoded bytes. |
| `OneDust_onchain_runtime.hex` | Saved deployed runtime: 10,071 decoded bytes. |

The Standard JSON input equals the saved Remix `compilerInput` as parsed JSON.
Its embedded OneDust source matches the repository source after newline
normalization.

The constructor arguments, in contract order, are:

| Parameter | Address |
|---|---|
| Admin | `0xa42db27670fceb0f236aa5450396adcc9b5bfb01` |
| Minter | `0x8f2325d4e7c520fdf93470b73fccdeed1e5fadc4` |
| Compliance | `0xb3323caad76a0745fe6a260753fd608d89655c83` |
| Burner | `0x9823e7401126bf5ebcc21bbb6174a74365ab9ced` |
| Treasury | `0x031fc27d09bb5caa0f8d6a81b2e94c51dbcd06d2` |

The saved creation bytecode is 14,627 bytes. Appending the 160-byte
constructor arguments produces the 14,787-byte deployment input.

## Integrity

SHA-256 of the files as stored, including their existing text formatting:

- `OneDust_Remix_compData_2026-10-04.json`:
  `390992a945eb672d547cad74d374aa1976992d4de3e5c864dbb68e97a3591b6e`
- `OneDust_constructor_args.hex`:
  `c5861cf956b834d7b0e960c0cdeffd3c85463bccbd1e28ae4402e71655b1de3d`
- `OneDust_onchain_runtime.hex`:
  `5ae723f0b5f72960f13b50c9cfdf873c5567e629e76d7365b0eb3c79f46cafae`
- `OneDust_verify_standard_input.json`:
  `b36bf235241a0e761a40f3f70e9968bcc8fec1d31c8ae1a5a1b8b997192baf78`

SHA-256 of decoded hexadecimal bytes:

- Runtime:
  `5450d9d0d05826f2cc70ec600d058084aeb6740286dadd21fbe902d77f171252`.
- Constructor arguments:
  `35cf59c6bf8b373e513d7ec9c28f3ed279a69e78c1bfbe266d22ad695f48689a`.
- Creation bytecode followed by constructor arguments:
  `426aba105d66c917f8d0089c7b2a171e576767b225405f4fb2028fc526948bcf`.

## Interpretation

The saved input explicitly disables the optimizer with runs set to 200.
It omits `evmVersion`, `viaIR`, and `metadata`; the original input is retained
without adding those settings retrospectively.

The test log records comparison of the saved runtime with the testnet runtime,
and comparison of deployment input and initial events. These are recorded
comparisons, not new live-network checks performed by publishing these files.

The saved compilation report is supplemented by
[a fresh compiler reproduction](compiler-reproduction.json): the unchanged Standard JSON compiled with verified Solc 0.8.37 produced matching creation bytecode, runtime and deployment input, including metadata. This directory
does not independently establish explorer verification, mainnet equivalence,
Safe configuration, or an independent security audit.
