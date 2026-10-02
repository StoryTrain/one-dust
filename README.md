# One Dust (1DUST) — Contract

Foundry project for the One Dust token contract and its local tests. This
repository is a work in progress, not an audit or a deployment record.
No deployment is documented here.

## Requirements

- Foundry with Solc 0.8.37 available.
- Network access to install the dependencies below.

## Setup

Clone the repository, then run these commands from its root:

```sh
forge install --no-git foundry-rs/forge-std@v1.17.0
forge install --no-git OpenZeppelin/openzeppelin-contracts@v5.6.1
forge build --force
forge test -vv
```

Do not run `forge init` in the cloned repository; the Foundry project files
are already present. Dependencies are installed under `lib/`, which is ignored
by Git. The commands above specify release tags, but a clean-checkout build
and resolved dependency commit hashes have not yet been independently
verified.

## Project files

- `src/OneDust.sol` — token contract.
- `test/OneDust.t.sol` — unit and fuzz tests.
- `test/OneDust.invariant.t.sol` — invariant and directed tests.
- `foundry.toml` — compiler and build settings.
- `docs/Test-Log.md` — dated local checks and their results.

BNB Smart Chain is the intended network. Consult `foundry.toml` for the
build configuration; successful local tests do not establish deployment
readiness or security.

## Security

Never commit recovery phrases, private keys, passwords, API keys, keystores,
or `.env` files. Do not sign deployment or administrative transactions based
on this README.