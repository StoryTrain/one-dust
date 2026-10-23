# One Dust (1DUST) — Mint Governance

Version: 1.0

Effective date: upon publication of the approved canonical revision on the main branch of the project's official publicly readable GitHub repository

Network: BNB Smart Chain Mainnet, Chain ID 56

1DUST contract: `0x3713e7f7413f01019a9f63e9541b6e3ddef72c48`

Related documents: the current published [White Paper](White-Paper.md) and [Operational Policy](Operational-Policy.md)

Official Discord server: see [Official Resources](Official-Resources.md)

Revision history: the project's official GitHub repository

---

## 1. Purpose and scope

Mint Governance defines how additional 1DUST issuance is proposed, discussed, voted on and executed.

The initial 50,000,000 1DUST were issued at deployment. That issuance is part of deployment history and does not require a new vote under this procedure.

The team makes operational decisions about trading orders, PoW-asset selection, liquidity work and use of existing assets. Community discussion may inform these decisions; a separate mandatory vote is not required for every operation.

Transferring already issued 1DUST from Cold Treasury is use of an existing treasury balance under Operational Policy, not additional issuance.

Additional minting requires a vote under this document and execution through a Safe holding `MINTER_ROLE`. The recipient must hold `TREASURY_ROLE` and be unfrozen. The ordinary recipient is Safe_4 Cold Treasury.

## 2. Official venue and proposal publication

### 2.1. Discord

Official additional-issuance voting takes place on the project's official Discord server. Only the official vote announced by the team for a specific proposal counts toward its result.

Before voting opens, publish:

- the unique proposal ID;
- the complete proposal text;
- a reference to the proposal message and a reference to the poll;
- participation and counting rules;
- opening and closing times in UTC;
- how supporting materials will be retained.

The text, settings, opening and closing times, result and supporting materials are archived outside Discord.

### 2.2. Telegram, X and other discussions

Telegram and X are used for announcements, references and discussion. Polls on those platforms are advisory and carry this explanation:

> Advisory poll. Its result does not count toward the mint vote. Official voting takes place in Discord.

Votes from different platforms are not combined. An advisory poll does not replace or overturn the official result.

### 2.3. Voting tool

The official poll has two choices: “For” and “Against”. One Discord account may select one choice. Votes are not weighted by token holdings.

Voting uses Discord Poll with two answer options and multiple-answer selection disabled.

The voting and counting method remains unchanged throughout the vote. If a technical failure prevents a reliable result, the vote is recorded as inconclusive; a new vote is held to obtain a decision.

## 3. Additional-issuance proposal

Each proposal has a unique ID in the form `MINT-PROPOSAL-[number]` and states:

1. The exact quantity of new 1DUST.
2. The purpose, justification and why existing treasury tokens are insufficient for the task.
3. The network and token contract address.
4. The treasury recipient and confirmation of its `TREASURY_ROLE` when the proposal is prepared.
5. The intended executing Safe holding `MINTER_ROLE`.
6. The intended categories of subsequent token use.
7. Total supply at a stated date or block and the increase proposed by this mint.
8. Opening and closing times in UTC.
9. Participation, counting and approval rules.
10. The intended execution process, the 48-hour wait following the complete positive result, and known risks.
11. The archiving method and channel for comments.

The quantity of existing tokens is obtained from the contract's `totalSupply()`. The proposal states the increase this mint would cause. Actual pre- and post-execution figures are recorded in the report.

### 3.1. Proposal changes

The published terms remain fixed after voting opens.

Changing the amount, recipient, purpose, approval threshold, schedule, participation rules or counting rules requires cancellation of the previous proposal and a new vote. The cancelled record remains in the log; the new proposal receives a separate ID and references the previous one.

Editorial corrections that preserve the meaning and terms are recorded with a date and explanation.

A material change to approved terms after a positive result also requires a new vote. Restarting the waiting period does not replace renewed approval.

## 4. Participants, timing and counting

### 4.1. Participants

Members of the official Discord server who can access the official poll under its previously announced access settings may participate.

One Discord account has one vote: “For” or “Against”. The participant's 1DUST holdings do not affect voting weight.

### 4.2. Voting duration

The ordinary voting duration is 72 hours.

A 24-hour vote is permitted if the specific reason for urgency, expected harm from waiting the ordinary 72 hours, and exact closing time in UTC are published before it opens.

Duration is set before opening. It is not shortened during voting because of an interim result. Closing a poll early does not establish approval.

If the grounds for urgency cease to apply before opening, the ordinary 72-hour duration is used.

### 4.3. Turnout and approval

There is no minimum turnout requirement. The result record states actual turnout.

A proposal is approved if “For” votes are at least 51% of the sum of valid “For” and “Against” votes.

The share is calculated from final vote counts without rounding upward to meet the threshold. The check is:

```text
Total votes = For + Against
Approved if:
    Total votes > 0
    and 100 × For >= 51 × Total votes
```

A tie, a result below 51%, or no valid votes means “not approved”.

The outcome is determined after voting closes. Interim results are not a decision.

### 4.4. Result verification

The team retains the text, settings, announced times, final vote counts and supporting materials.

Reports of technical failures are reviewed using the retained voting materials.

If a reliable result cannot be established, approval is not recorded. The voting status and reason remain in the log; the proposal may be submitted to a new vote.

### 4.5. Other polls

Polls on pairs, venues, PoW assets and other operational matters are advisory unless a different process was announced in advance for that particular matter.

In a multi-option advisory poll, the highest vote count identifies the most supported option. A tie between leading options does not identify a sole winner.

Additional issuance is approved through a separate “For / Against” vote on a specific token amount, recipient and purpose.

## 5. Publishing the result

After closing and verifying the vote, the team publishes a result record containing:

- the proposal ID and reference to its text;
- the official poll reference;
- applicable rule revisions;
- opening and closing times in UTC;
- settings and voting tool used;
- “For” and “Against” counts;
- total valid votes and the “For” share;
- the approval threshold and absence of a minimum turnout requirement;
- any disputed circumstances reviewed;
- final status and the supporting-material archive.

The complete positive result includes the approved amount, purpose and recipient. Its publication starts the ordinary 48-hour period before execution.

Participants' personal information is not disclosed beyond what is necessary to substantiate the result through the voting mechanism used.

## 6. Execution through Safe

### 6.1. Execution decision

A positive result provides the procedural basis for executing the approved mint. During preparation, the Safe checks technical feasibility, security and applicability of the decision.

Execution may be postponed or cancelled because of a technical, legal or security obstacle. The decision and reason are published.

Only the approved token amount, recipient and purpose may be executed under that proposal. Material changes follow Section 3.1.

### 6.2. Waiting period

Ordinary minting occurs no earlier than 48 hours after publication of the complete positive result.

Voting duration and the pre-execution wait are distinct stages:

- voting first runs for 72 hours or a previously justified 24 hours;
- the complete positive result is then published;
- the 48-hour ordinary execution wait starts after that publication.

The 72-hour period before `burnFrozen` belongs to Operational Policy; it is not an additional mint waiting period.

### 6.3. Checks before signing

Before execution, check:

- the network and contract address;
- the executing Safe's `MINTER_ROLE`;
- the recipient's `TREASURY_ROLE`;
- the recipient's unfrozen status;
- exact calldata for `mint(recipient, amount)`;
- consistency of amount, recipient and purpose with the approved proposal;
- compliance with the applicable waiting period.

The ordinary execution is through Safe_1 Minter to Safe_4 Cold Treasury. Any other treasury recipient is disclosed under Operational Policy and included in the proposal.

If a required role is revoked or another execution condition no longer matches, the operation is paused for review and resolution under the applicable rules. Voting does not itself assign roles.

### 6.4. Confirmation and report

After execution, verify transaction status, the mint outcome, total supply and recipient balance.

The report includes the transaction hash, execution time in UTC, amount issued, recipient, total supply before and after, the recipient treasury-role check, and references to the proposal and vote.

Reports are published as materials are prepared and checked under Operational Policy.

## 7. Emergency procedure

Operational Policy permits reducing the 48-hour wait following a positive result in documented emergency circumstances.

This is separate from choosing a 24-hour vote:

- a 24-hour vote requires grounds published before opening under Section 4.2;
- reducing the wait after the result requires a separate decision under Operational Policy.

A positive vote remains mandatory. The emergency process does not permit minting after a negative result, with no valid votes, or where the outcome cannot be verified.

When an exception is used, retain its grounds, the Safe decision, operation parameters and execution confirmation. Include these in the report.

## 8. Proposal log

The log retains proposals and outcomes, including cancelled, rejected, inconclusive, approved, postponed and executed proposals.

Each record retains the proposal text, applicable rules, references, supporting materials and subsequent decisions.

### 8.1. Proposal template

```text
ID: MINT-PROPOSAL-[number]
Status:
Network: BNB Smart Chain Mainnet, Chain ID 56
Contract: 0x3713e7f7413f01019a9f63e9541b6e3ddef72c48
Applicable rule revisions:
New 1DUST amount:
Purpose:
Why new issuance is needed:
Executing Safe:
Treasury recipient:
Recipient TREASURY_ROLE check, date / block:
Total supply at date / block:
Proposed increase in total supply:
Intended use:
Known risks:
Voting opens UTC:
Voting closes UTC:
Duration: 72 hours / justified 24 hours
Grounds for urgency, if applicable:
Participants and access settings:
Voting tool:
Choices: For / Against, one vote per account
Threshold: at least 51% of valid votes
Minimum turnout: none
Proposal reference:
Official poll reference:
Archiving method:
Channel for comments:
Execution process and 48-hour wait after the complete result:
```

### 8.2. Result and execution template

```text
Proposal ID:
Proposal and official poll references:
Opening / closing UTC:
For:
Against:
Total valid votes:
For share:
51% threshold check:
Disputed circumstances reviewed:
Final status:
Supporting-material archive:
Approved amount, recipient and purpose:
Complete result publication time UTC:
Earliest ordinary mint time UTC:
Execution / postponement / cancellation decision:
Emergency exception and grounds, if used:
Role, frozen-status and calldata checks:
Transaction hash, status and execution time UTC:
Total supply before / after:
Recipient balance after:
Report publication date:
```

## 9. Publication and procedure changes

The approved canonical revision takes effect when published on the main branch of the project's official public GitHub repository. Drafts are used for review and do not bring this procedure into effect.

The current published White Paper and Operational Policy are referenced without fixing their version numbers in the header. References or identifiers for the revisions applicable to a particular proposal are retained in that proposal's record.

A new approved canonical revision takes effect upon publication. Repository history retains prior revisions and explanations of changes.

A procedure change does not alter the terms of an open vote. Deviations from applicable rules are recorded separately, not concealed through subsequent document edits.

## 10. Voting status and material features

Mint Governance establishes the public decision procedure for additional issuance. A role holder executes the transaction through the token contract; voting and waiting periods are team procedures, not a contract-enforced voting mechanism or timelock.

Voting counts Discord accounts, not proven unique individuals. Without a minimum turnout requirement, a small number of participants may approve a proposal. Actual turnout is disclosed with the result.

Additional issuance increases total supply. Voting does not guarantee price, returns or liquidity, or create a right to demand token redemption from the project.
