# One Dust (1DUST) — Operational Policy

Version: 1.0

Effective date: upon publication of the approved canonical revision on the main branch of the project's official publicly readable GitHub repository

Network: BNB Smart Chain Mainnet, Chain ID 56

1DUST contract: `0x3713e7f7413f01019a9f63e9541b6e3ddef72c48`

Related documents: the current published [White Paper](White-Paper.md) and [Mint Governance](Mint-Governance.md)

Official resources: [Official Resources](Official-Resources.md)

Publication and revision history: the project's official GitHub repository

---

## 1. Purpose and scope

This policy governs additional issuance of 1DUST, the use of freeze, unfreeze and `burnFrozen`, role management, and transfers of tokens from Cold Treasury.

It applies to project operators, participants in Safe transaction execution, and those responsible for recordkeeping and public reporting.

The White Paper describes the project and its operating model. This policy establishes operational procedures. Mint Governance sets out how additional issuance is proposed, discussed and voted on.

The approved canonical revision takes effect when published on the main branch of the official public GitHub repository. Publishing a draft does not bring the policy into effect. A specific revision is identified by its version and commit.

The revisions of the rules applicable to an individual proposal and operation are retained in its record. References to current related documents do not retroactively change the terms of an open vote.

Dates and times in operational announcements and reports are stated in UTC. Policy changes are retained in the repository history and accompanied by explanations of material revisions. This policy does not impose retrospective obligations on actions taken before it became effective.

## 2. Contract, addresses and powers

### 2.1. Deployment and initial issuance

| Field | Value |
|---|---|
| Network | BNB Smart Chain Mainnet, Chain ID 56 |
| Contract | `0x3713e7f7413f01019a9f63e9541b6e3ddef72c48` |
| Deployment transaction | `0x0aa17ce92110056a7c5c2cf1dd1d1093b2ec3264537ab6d91ced01870a791926` |
| Deployment block | `125679825` |
| Deployment UTC | `2026-10-04T12:54:47Z` |
| Initial issuance | 50,000,000 1DUST |
| Initial recipient | Safe_4 Cold Treasury |

The constructor assigned five roles to their respective addresses and directed the initial issuance to Cold Treasury. Deployment details and subsequent observations are documented in the [Genesis Report](build-evidence/mainnet/Genesis-Report.md).

### 2.2. Wallet register

| Purpose | Identifier | BSC Mainnet address | Threshold | Role or function |
|---|---|---|---|---|
| Role administration | Safe_0 Admin | `0x6e7153abe3d9040059cbe6861f5219cd2327bc14` | 2 of 3 Safe owners | `DEFAULT_ADMIN_ROLE` |
| Additional issuance | Safe_1 Minter | `0xb72609fb717f84631d6b2207e832948b1b86d9e3` | 2 of 3 | `MINTER_ROLE` |
| Freezing and unfreezing | Safe_2 Compliance | `0xfeb99c8d622bb3028668086be92ac7346f781a52` | 2 of 3 | `COMPLIANCE_ROLE` |
| Burning frozen balances | Safe_3 Burner | `0x30a2681481607bb594c3d15f24a5e740484598c1` | 3 of 5 | `BURNER_ROLE` |
| Treasury custody | Safe_4 Cold Treasury | `0x60c63b66355b0107ec3faa4a916f9e956a79ddf8` | 2 of 3 | `TREASURY_ROLE`; initial issuance recipient |
| Operating expenses and liquidity | Hot Operations | `0x489e4078497c85711e86021727716d3be48a7768` | EOA, one key | Operational wallet |

The five role assignments were confirmed at deployment and, for the corresponding listed addresses, in the token-state observation at block `128823144`. Safe thresholds and owner sets were recorded separately at block `128825311`.

These records describe the specified blocks. Subsequent changes are reflected in the register with supporting transaction references.

### 2.3. Role capabilities

- `DEFAULT_ADMIN_ROLE`: granting and revoking roles, including managing holders of the administrative role itself.
- `MINTER_ROLE`: issuing additional 1DUST to an address holding `TREASURY_ROLE`.
- `COMPLIANCE_ROLE`: freezing and unfreezing addresses.
- `BURNER_ROLE`: permanently burning tokens at a frozen address through `burnFrozen`.
- `TREASURY_ROLE`: eligibility to receive additional issuance. Spending a treasury wallet's balance is controlled through the wallet itself.

Safe_0–Safe_4 are project wallet identifiers. The actual holder of the required role is checked before execution. Under this policy, critical project roles are exercised through designated Safes. Replacements follow Section 9.

### 2.4. Nested Admin Safe

At block `128825311`, Safe_0's owners were Safe_1, Safe_2 and Safe_3. Executing a Safe_0 transaction requires approval by two of its three Safe owners through the Safe execution mechanism.

Safe_0's “2 of 3” threshold refers to three Safe wallets, not directly to three EOAs. The operational Safes have their own owner sets and thresholds; their participation in Safe_0 is part of the project's overall governance structure.

### 2.5. Infrastructure addresses

As infrastructure is used, the project adds DEX pools and pairs, routers, LP-position custody addresses, bridges and identified exchange wallets to its public address register.

Each entry identifies the network, purpose, identification source and reconciliation date. Uncertain attribution is marked as unconfirmed.

## 3. General execution principles

1. Each critical operation has a documented basis, an initiator and a retained execution record.
2. Before signing, participants check the network, contract, function, calldata, amount, recipient or affected address, and expected outcome.
3. Address and material-parameter verification includes a separate participant involved in preparation or signing.
4. Additional issuance requires a vote under Mint Governance. Trading operations and the use of already issued tokens are operational decisions of the team.
5. For ordinary minting, the waiting period starts when the complete positive voting result is published. For ordinary `burnFrozen`, it starts with the affected address's successful on-chain freeze.
6. Completion is established by a successful on-chain outcome, verification of the expected state, and retention of the transaction hash.
7. Cancelled operations, rejected proposals and material technical errors remain in the relevant log.
8. Emergency exceptions are documented with their grounds, decision and outcome.

## 4. Issuance and supply accounting

### 4.1. Initial issuance and existing supply

The initial 50,000,000 1DUST were issued at deployment to Safe_4 Cold Treasury. This issuance is part of deployment history, not a proposal for additional issuance.

The contract's `totalSupply()` is the basis for accounting for all existing tokens. Minting increases this figure and burning reduces it. Transfers between wallets redistribute existing tokens without changing total supply.

Reports identify the overall quantity of existing tokens as total supply and state the observation date or block. Treasury and other balances may be shown separately using `balanceOf(address)`.

### 4.2. Additional issuance

The contract supports additional issuance through `mint`. The executing address must hold `MINTER_ROLE`, and the recipient must hold `TREASURY_ROLE` and be unfrozen.

The contract has no predetermined maximum-supply cap. Additional issuance follows this policy and Mint Governance.

The ordinary recipient is Safe_4 Cold Treasury. Using another treasury recipient requires separate disclosure of its purpose and prior assignment of `TREASURY_ROLE`.

### 4.3. Ordinary mint procedure

1. Publish a uniquely identified proposal stating the new 1DUST amount, purpose, justification for new issuance, recipient, executing Safe, intended use, change in total supply and voting schedule.
2. Conduct discussion and voting under Mint Governance. Retain the proposal and result with archivable references.
3. After the vote closes, publish the complete result and approved parameters.
4. Ordinary minting may occur no earlier than 48 hours after publication of the complete positive result.
5. Before execution, check `hasRole(MINTER_ROLE, executingSafe)`, `hasRole(TREASURY_ROLE, recipient)`, the recipient's unfrozen status and consistency of calldata with the approved terms.
6. Execute the agreed transaction through the Safe.
7. After confirming the outcome, prepare and publish a report with the transaction hash, amount, recipient, total supply before and after, and a reference to the decision.

A positive vote is a necessary procedural condition for additional issuance. Technical, legal or security obstacles may lead to postponement or cancellation, with the reason disclosed.

### 4.4. Changes to a mint proposal

Changing the token amount, recipient, purpose or decision rules after voting opens requires cancellation of the previous proposal and a new vote.

A material change to approved terms after a positive result also requires a new vote. Restarting the 48-hour waiting period does not replace renewed approval.

Editorial corrections that preserve the meaning and terms are recorded with a date and explanation.

### 4.5. Emergency reduction of the waiting period

A documented security threat or infrastructure-recovery need may justify reducing the 48-hour period after a positive vote.

The initiator describes the threat, expected harm from waiting, grounds for reduction, minimum necessary issuance, treasury recipient and intended use.

The Safe holding `MINTER_ROLE` decides on execution. Safe_0 participates in reviewing the grounds where technically and practically possible within the available time.

A positive vote remains mandatory. Additional issuance is not executed after a negative result or where a vote cannot be conducted and its result confirmed.

Before execution, publish a notice to the extent compatible with responding to the threat. After execution, disclose the grounds for reducing the wait, issuance parameters, transaction hash and outcome.

## 5. Cold Treasury, Hot Operations and liquidity

Safe_4 Cold Treasury holds treasury tokens and receives issuance.

The team decides how already issued tokens are allocated to liquidity provision, trading venues and other project activities.

Hot Operations is used for operating expenses and liquidity work. Transfers from Cold Treasury use an existing balance; they are not additional issuance.

Outgoing Cold Treasury operations are recorded internally with their purpose, token quantity or asset amount, recipient, authorization, transaction hash and remaining balance.

Treasury operations and liquidity results are included in consolidated project reports. Individual operations may also receive separate explanations or reports.

Approval of additional issuance does not automatically instruct the team to spend other project assets. The team makes operational decisions about existing assets under the published rules.

CEX placement parameters and the approach to DEX liquidity are described in the White Paper.

## 6. Freezing and unfreezing

Freeze is used in response to a documented security incident, distribution error or specific applicable compliance ground.

The basis, affected address and consequences are checked before execution. Infrastructure attribution under Section 8 is assessed separately.

### 6.1. Freeze procedure

1. Create an incident record with an ID, address, confirmed facts, reason and discovery time.
2. Have the initiator and a separate reviewing participant verify the address and basis.
3. Reconcile the address against the infrastructure register.
4. Check the executing Safe's `COMPLIANCE_ROLE`.
5. Record the decision and permissible scope of public disclosure.
6. Execute `freeze(account)` through the Safe.
7. Verify success, `isFrozen(account)`, the event and transaction hash.
8. Prepare and publish a record of the operation, its basis to the extent disclosable, and any determined follow-up actions.

Freeze suspends transfers from and to the address, receipt of issuance, ordinary burning, and the approval and allowance operations covered by the contract. A frozen spender also loses the ability to spend a previously granted allowance.

### 6.2. Unfreeze

Unfreeze is considered when the basis is resolved or a mistaken freeze is identified.

The executing Safe checks the address, decision basis and required role, executes `unfreeze(account)`, and confirms the outcome through contract state and events.

The log retains the original freeze, review findings, decision and unfreeze transaction hash.

## 7. Burning a frozen balance

`burnFrozen` allows the holder of `BURNER_ROLE` to permanently burn a specified quantity of 1DUST at a frozen address. It reduces the address's balance and total supply without requiring the holder's approval.

The designated Safe_3 Burner uses a 3-of-5 threshold. This threshold belongs to that Safe; role-holder changes follow Section 9.

Ordinary user burning follows the contract's functions and is separate from the administrative `burnFrozen` procedure.

### 7.1. Ordinary burnFrozen procedure

At least 72 hours must pass between the address's successful on-chain freeze and ordinary execution of `burnFrozen`.

1. Document the basis: a confirmed security incident, distribution error or specific applicable compliance ground.
2. Check the address, freeze transaction and time, current frozen status, balance and exact burn amount.
3. Consider alternatives, including unfreeze and correcting the distribution.
4. Record the decision, parameters and reason for choosing an irreversible action.
5. After 72 hours, recheck the address state, `BURNER_ROLE` and consistency of calldata with the decision.
6. Execute `burnFrozen(account, amount)` through Safe_3.
7. Prepare and publish a report with the basis, freeze and burn transaction hashes, amount burned and change in total supply.

Unfreezing ends the basis for executing the prepared operation. A subsequent new freeze starts a new 72-hour period from that new freeze transaction.

Changing the affected address or materially changing the burn amount requires a new decision and parameter review.

### 7.2. Emergency reduction of the waiting period

The 72-hour period may be reduced for a documented active exploit or a specific legal necessity that genuinely requires earlier execution. The legal basis is reviewed by a qualified specialist.

The decision describes the threat or basis, why waiting is not possible, considered alternatives, address and amount.

Safe_3 executes the burn while holding `BURNER_ROLE`, after checking the address's frozen status.

After execution, prepare and publish a report with the exception's grounds, chronology, freeze and burn transaction hashes, amount and result. Any limitation on disclosing individual details is accompanied by an explanation.

## 8. Protecting liquidity infrastructure

In ordinary operations, freeze is not applied to DEX pairs and pools, routers, LP-position custody addresses, bridges, CEX hot wallets or other critical infrastructure interacting with 1DUST.

Before a freeze, consult the public and internal registers, explorer information and reliable attribution sources.

An emergency exception is considered for a documented threat, with assessment of consequences for users, trading and infrastructure. The executing Safe approves the decision, which is retained in the log.

After the operation, disclose the address, reason, transaction hash, restriction timing, known impact and plan to restore normal operation.

Where advance disclosure would worsen an active threat, publication follows execution with the delay explained.

Applying `burnFrozen` to an infrastructure address requires a separate decision, consequence assessment and basis under Section 7. Approval of a freeze is not approval to burn.

## 9. Role management

Safe_0, holding `DEFAULT_ADMIN_ROLE`, administers role grants and revocations. Records identify the addresses, powers, basis and consequences.

### 9.1. Granting and revoking roles

1. Prepare a decision for `grantRole` or `revokeRole`.
2. Check the current role administrator, target address and expected result.
3. For a new Safe, check owners, threshold, modules, guards and suitability for the intended execution.
4. Execute the verified transaction through Safe_0.
5. Confirm the result using `hasRole`, events and the transaction hash.
6. Update the public register.

When replacing an executor, verify the new wallet's readiness and the handover process, then carry out the agreed sequence of grants and revocations.

When granting `TREASURY_ROLE`, disclose the treasury address's purpose and intended receipt of issuance or custody of tokens.

Granting `TREASURY_ROLE` is a separate administrative action. Subsequent minting follows its own voting and execution procedure.

Under this policy, trading, user and infrastructure addresses are not assigned `TREASURY_ROLE` to bypass the treasury issuance procedure.

### 9.2. Transferring DEFAULT_ADMIN_ROLE

1. Create and verify the new administrative Safe.
2. Have the current administrator grant it `DEFAULT_ADMIN_ROLE`.
3. Confirm the successful transaction and role assignment.
4. Have the new Safe execute an agreed safe administrative verification operation.
5. Revoke the previous administrator's role after confirming readiness.
6. Verify the final role distribution and continued administrative access.
7. Publish a record with the reasons, addresses, checks and transaction hashes.

The current administrator may use `renounceRole` only after a confirmed handover to another verified Safe. The last acting administrator does not renounce the role.

## 10. Records, public reporting and revisions

### 10.1. Reporting

Records of additional issuance, role changes, freeze, unfreeze and `burnFrozen` are prepared and published with their basis, parameters and execution confirmation.

Treasury operations and liquidity results are reflected in consolidated project reports.

Reports are published as materials are prepared and checked.

Public materials may omit personal data, investigation sources and details whose disclosure would directly worsen an active threat. The on-chain action and its economic outcome remain reflected in reporting.

### 10.2. Policy revisions

The effective revision is published on the main branch of the official public GitHub repository. Repository history retains previous revisions and explanations of changes.

An updated approved canonical revision takes effect when published on the main branch. New rules are disclosed before the operations to which they apply.

An open mint vote retains the rules published when it opened. Material proposal changes follow Section 4.4.

Execution that deviates from the applicable policy is recorded separately. A new revision does not replace the history of prior actions.

### 10.3. Mint record

```text
Proposal ID:
Status:
Rule revisions applicable to the proposal:
Network and token contract:
Purpose and justification:
1DUST amount:
Executing Safe:
Recipient:
Proposal and voting references:
Voting result:
Complete result publication time UTC:
Earliest ordinary execution time UTC:
Role, recipient and calldata checks:
Emergency exception and grounds, if used:
Transaction hash, result and execution time UTC:
Total supply before / after:
Recipient balance after:
Intended use:
Report publication date:
```

### 10.4. Freeze, unfreeze and burnFrozen record

```text
Incident ID:
Status:
Applicable Operational Policy revision:
Network and token contract:
Affected address and purpose:
Basis and confirmed facts:
Infrastructure attribution check:
Decision and time UTC:
Executing Safe and role check:
Freeze transaction and time UTC:
Frozen-status check result:
Alternatives considered:
Follow-up decision:
Earliest ordinary burnFrozen time UTC:
Emergency exception and grounds, if used:
Unfreeze / burn transaction and time UTC:
Amount burned, if applicable:
Total supply before / after burning:
Result and any determined follow-up actions:
Disclosure limitations and reason:
Report publication date:
```

### 10.5. Role-change record

```text
Change ID:
Applicable Operational Policy revision:
Network and token contract:
Role:
Action:
Reason:
Executing administrative Safe:
Previous holder / target address:
New wallet purpose:
Configuration and readiness checks:
Transaction hash and time UTC:
hasRole result:
Check of continued required powers:
Additional treasury-recipient details, if applicable:
Updated register reference:
Report publication date:
```

### 10.6. Emergency-exception record

```text
Incident ID:
Applicable Operational Policy revision:
Exception used:
Threat or other permitted basis:
Why the ordinary procedure cannot be followed:
Alternatives and consequences considered:
Decision:
Executing Safe:
Addresses, function and amount:
Pre-execution checks:
Transaction hash, result and time UTC:
Public disclosure time and location:
Withheld details and reason:
Recovery plan and subsequent review:
```

## 11. Material features and risks

The contract supports additional issuance, role-holder changes, address freezing and burning of frozen balances. These capabilities form the project's administrative model.

The token implementation has no code-upgrade mechanism; roles, address states and managing-wallet configurations may change.

Voting, the 48-hour ordinary mint wait, the 72-hour ordinary `burnFrozen` wait and infrastructure-protection rules are team procedures. The contract executes operations according to its technical conditions, not compliance with those procedures.

Safe and role separation organize transaction approval. Key compromise, signing errors, unavailable participants and improper exercise of powers remain risks. Safe thresholds and distinct owner addresses do not by themselves prove independence of the controlling persons.

The published verification package documents specific observations and historical executions; it is not an independent audit. Historical BNB transfers through Safe are separate from token-function testing.

The project does not guarantee price, returns, permanent liquidity or token redemption.
