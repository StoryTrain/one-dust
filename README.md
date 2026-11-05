# One Dust (1DUST) — Contract

Foundry project containing the One Dust token contract, local tests,
and documented BNB Smart Chain Testnet and Mainnet evidence.

The token has been deployed on BNB Smart Chain Testnet and Mainnet.
Network-specific evidence covers deployment comparisons, scoped state
observations and selected historical executions. Limits are documented
separately; deployment is not equivalent to public-launch readiness.

The contract provides role-controlled minting to Treasury-role recipients,
address freezing, ordinary burns, and privileged burning of frozen balances.
Additional minting has no supply cap. Administrative powers and their
operational controls must be considered separately from test results.

## Scope

Documented testnet contract:
`0x90d12Fc13A445337285Ae94F4a83295058076E1d` (chain ID 97).

Documented mainnet contract:
`0x3713e7f7413f01019a9f63e9541b6e3ddef72c48` (chain ID 56).
See the [Mainnet Genesis Report](docs/build-evidence/mainnet/Genesis-Report.md).

See [the test log](docs/Test-Log.md) for dated checks and limitations.
The latest recorded local regression completed on 2026-10-20:
42 tests passed, 0 failed, 0 skipped.

A subsequent targeted run passed three additional edge-case tests,
with 0 failures and 0 skipped. These are separate executions, not one
recorded full 45-test run. See the
[edge-case report](docs/test-evidence/local/edge-cases.json).

Mainnet Safe configuration and selected historical executions are documented.
This does not establish signer availability, key custody, recovery readiness,
or approval to launch liquidity. Test results are not an independent security
audit or a security guarantee.

## Project documentation

- [White Paper](docs/White-Paper.md)
- [Operational Policy](docs/Operational-Policy.md)
- [Mint Governance](docs/Mint-Governance.md)
- [Official Resources](docs/Official-Resources.md)

## Requirements and setup

- Foundry; the recorded regression used Forge 1.8.3.
- Solc 0.8.37.
- Network access for dependency installation and compiler download if needed.

From the cloned repository root:

```sh
forge install --no-git foundry-rs/forge-std@v1.17.0
forge install --no-git OpenZeppelin/openzeppelin-contracts@v5.6.1
forge build --force
forge test -vv
```

Do not run `forge init`: the project files are already present.
Dependencies are installed under `lib/`, which Git ignores.
The installation commands select release tags; local package version labels
alone do not prove that dependency contents are unmodified.

The commands above run the project; they do not reproduce every override
of the recorded control run. Its settings are documented in the test log.

## Project files

- `src/OneDust.sol` — token contract.
- `test/OneDust.t.sol` — unit and fuzz tests.
- `test/OneDust.invariant.t.sol` — invariant campaigns and directed tests.
- `test/OneDustEdgeCases.t.sol` — directed checks for zero-value approvals,
  frozen-recipient allowance rollback, and post-burn freeze enforcement.
- `test/OneDustTestnetDeployment.t.sol` — local constructor test using
  the testnet role-holder addresses; it does not deploy to a live network.
- `foundry.toml` — compiler and build configuration.
- `docs/Test-Log.md` — dated checks, results, and limitations.
- [Coverage matrix](docs/Test-Coverage.md) — properties, test references,
  network evidence, and open items.
- [Slither review](docs/Slither-Review.md) — disposition of the five
  historical informational findings.
- [Testnet build evidence](docs/build-evidence/testnet/README.md) — saved
  compilation and deployment comparisons.
- [Mainnet build evidence](docs/build-evidence/mainnet/README.md) and
  [mainnet verification evidence](docs/test-evidence/mainnet/README.md) —
  deployment, fixed-block observations, Safe execution and token history.

## Security

Never commit recovery phrases, private keys, passwords, API keys, keystores,
or `.env` files. Do not sign deployment or administrative transactions based
solely on this README.

## License

The One Dust token contract source code in `src/OneDust.sol` is
licensed under the MIT License. See [LICENSE](LICENSE).

Third-party dependencies remain subject to their respective licenses.
This license notice does not grant rights to the One Dust name, logos,
or other branding, and does not apply to the project's policy documents
or verification records.
