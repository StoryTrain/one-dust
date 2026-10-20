# One Dust — Historical Slither Findings Review

Review date: 2026-10-20.

## Scope and evidence

This reviews the five findings recorded in
[test-log entries 12 and 13](Test-Log.md).
It is not a new Slither execution.

Historical analysis:
- Slither 0.11.6.
- 13 contracts analyzed with 102 detectors.
- Five findings: one `pragma`, four `solc-version`.
- Reported impact: Informational; confidence: High.
- `--fail-none` changed the process exit behavior, not the finding count.

The retained Standard JSON and Remix metadata are available in
[the testnet build directory](build-evidence/testnet/README.md).
Remix metadata records compiler `0.8.37+commit.f401782d`.
The historical build-info check also recorded compiler 0.8.37.

## Disposition

| Finding group | Observation | Disposition for the recorded build |
|---|---|---|
| `pragma` — one finding | Five different Solidity version constraints occur across the eleven input sources. | Reviewed informational. All observed constraints permit 0.8.37; the differing directives do not establish mixed-compiler compilation. No source change required for this observation. |
| `solc-version` — constraint `^0.8.20` | Five dependency files permit a range beginning at 0.8.20. | Reviewed informational. The recorded compiler is 0.8.37, not 0.8.20; do not infer use of the lower-bound version. |
| `solc-version` — constraint `>=0.8.4` | Two dependency files allow versions from 0.8.4 upward. | Reviewed informational. The recorded compiler is 0.8.37, not 0.8.4. |
| `solc-version` — constraint `>=0.4.16` | Two interface files allow versions from 0.4.16 upward. | Reviewed informational. The recorded compiler is 0.8.37, not 0.4.16. |
| `solc-version` — constraint `>=0.6.2` | One interface file allows versions from 0.6.2 upward. | Reviewed informational. The recorded compiler is 0.8.37, not 0.6.2. |

Version pragmas constrain compiler compatibility; they do not independently
select a compiler for each imported file.

No dependency pragma was modified to suppress these findings.
The findings are not relabeled as fixed vulnerabilities or removed from
the historical analysis count.

## Exact pragma inventory

### `pragma solidity 0.8.37;`

- `OneDust.sol`

### `pragma solidity >=0.4.16;`

- `@openzeppelin/contracts@5.6.1/token/ERC20/IERC20.sol`
- `@openzeppelin/contracts@5.6.1/utils/introspection/IERC165.sol`

### `pragma solidity >=0.6.2;`

- `@openzeppelin/contracts@5.6.1/token/ERC20/extensions/IERC20Metadata.sol`

### `pragma solidity >=0.8.4;`

- `@openzeppelin/contracts@5.6.1/access/IAccessControl.sol`
- `@openzeppelin/contracts@5.6.1/interfaces/draft-IERC6093.sol`

### `pragma solidity ^0.8.20;`

- `@openzeppelin/contracts@5.6.1/access/AccessControl.sol`
- `@openzeppelin/contracts@5.6.1/token/ERC20/ERC20.sol`
- `@openzeppelin/contracts@5.6.1/token/ERC20/extensions/ERC20Burnable.sol`
- `@openzeppelin/contracts@5.6.1/utils/Context.sol`
- `@openzeppelin/contracts@5.6.1/utils/introspection/ERC165.sol`

## Boundaries and re-review conditions

This disposition addresses the reported pragma/version-constraint observations.
It does not establish that Solidity 0.8.37 has no compiler defects, or that
every defect listed by Slither was individually analyzed for applicability.

It applies to the retained input and recorded compiler. Changes to compiler
version, dependency sources, or build configuration require reassessment.

Historical descriptions of a permitted older version are not proof that
this build used that version.
