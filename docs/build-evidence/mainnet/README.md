# One Dust — Mainnet Build and Deployment Evidence

## Target

- Network / chain ID: BNB Smart Chain Mainnet / 56.
- Contract: `0x3713e7f7413f01019a9f63e9541b6e3ddef72c48`.
- Deployment: `0x0aa17ce92110056a7c5c2cf1dd1d1093b2ec3264537ab6d91ced01870a791926`, block 125679825, 2026-10-04T12:54:47Z.
- Runtime observation: block 128819984; this is not a deployment-block code query.

Start with the [Genesis Report](Genesis-Report.md).
Separately scoped state, Safe and history records are indexed in
[mainnet verification evidence](../../test-evidence/mainnet/README.md).

## Files

| File | Purpose |
|---|---|
| [Genesis-Report.md](Genesis-Report.md) | Deployment, results, administrative powers and limits |
| [deployment-transaction.json](deployment-transaction.json) | Recorded transaction result object |
| [deployment-receipt.json](deployment-receipt.json) | Recorded receipt, including constructor logs |
| [OneDust_constructor_args.hex](OneDust_constructor_args.hex) | Five encoded mainnet addresses |
| [OneDust_onchain_runtime.hex](OneDust_onchain_runtime.hex) | Runtime at the recorded observation block |
| [bytecode-comparison.json](bytecode-comparison.json) | Complete creation/runtime/input comparisons |
| [explorer-verification.json](explorer-verification.json) | Operator-transcribed Exact Match observation |

The JSON transaction/receipt objects are structured RPC results, not independent
cryptographic inclusion proofs.

## Build references

The [retained Standard JSON](../testnet/OneDust_verify_standard_input.json)
and [earlier reproduction](../testnet/compiler-reproduction.json) are shared
references. No duplicate Remix report is required here.

Mainnet creation code: 14,627 bytes.
Arguments: 160 bytes.
Full input: 14,787 bytes.
Runtime: 10,071 bytes.

The retained input disables optimization with 200 runs. Its omitted settings
were not retrospectively inserted. Explorer text `default evmVersion` is not
replaced with the explicit EVM target of a separate local regression.

## Integrity domains

SHA-256 of the exported files as stored:

- Constructor-argument file:
  `d3e91bc984e613898ea5eb4b637181b6c7e4d52ab1f42710e6820bbe7250ed25`.
- Runtime file:
  `5ae723f0b5f72960f13b50c9cfdf873c5567e629e76d7365b0eb3c79f46cafae`.

SHA-256 of decoded byte sequences:

- Creation code: `0dd3f6aad16a7394cbbdbb5d2344aa1a5fc492536650f366cbf04af9adff3880`.
- Constructor arguments: `8c773ee8fc34fba32d46ab537a807ebb934e39b061f31bd529b50d4cf2619135`.
- Deployment input: `43a5dd8e5ecc11775c6f5035deb843da12b1cdc900c868932eebe5bf5ae07f02`.
- Runtime: `5450d9d0d05826f2cc70ec600d058084aeb6740286dadd21fbe902d77f171252`.

The directory's .gitattributes disables line-ending conversion for HEX files
and fixes JSON/Markdown text to LF.

## Boundaries

Bytecode reproduction, explorer observation, token-state reads and Safe execution
checks are distinct forms of evidence. None constitutes an independent audit,
guarantees signer/key security, or authorizes a liquidity launch.
