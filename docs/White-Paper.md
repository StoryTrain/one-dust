# WHITE PAPER
## One Dust (1DUST)

Version: 1.0

Effective date: upon publication of the approved canonical revision on the main branch of the project's official publicly readable GitHub repository

Issuance network: BNB Smart Chain Mainnet, Chain ID 56

Contract: `0x3713e7f7413f01019a9f63e9541b6e3ddef72c48`

Related documents: the current published [Operational Policy](Operational-Policy.md) and [Mint Governance](Mint-Governance.md)

Official resources: [Official Resources](Official-Resources.md)

Revision history: the project's official GitHub repository

---

## 1. Project overview

One Dust begins with a simple thought: a working coin deserves a chance at a working market.

A PoW project may represent years of development, the computational work of miners, and a community that continues to believe in its network. Yet none of that turns into liquidity on its own. There can be a gap between a living technology and a living market. That is the gap we want to work on.

One Dust (1DUST) is a volatile cryptocurrency token created to support and revitalize selected markets for mineable coins. Our idea is to connect fragmented trading opportunities through pairs with 1DUST, liquidity provision and consistent market work.

Rather than wait for every small market to find its own way, we want to look for connections between them. To create places where trading interest and capital can meet.

The technical foundation already exists: the 1DUST contract is deployed on BNB Smart Chain Mainnet, and the initial 50,000,000 tokens were directed to the project's Cold Treasury. The next step is to turn that foundation into practical work: orders, pools, trading pairs and results that can be checked.

The model combines sellback and subsequent buyback with the development of DEX liquidity. The team makes operational decisions; additional issuance requires a community vote in Discord and execution through Safe under published rules.

1DUST is not positioned as a stablecoin. Its price is determined by the market. No ICO or airdrop is planned, and the token itself charges a 0% transfer fee.

We do not promise “to the moon”. We want talk of liquidity to be backed by work people can see and verify.

## 2. The market problem

A coin can still be mined. Developers can still maintain its code. A community can still discuss its future. Yet someone opening its market to buy or sell may find little more than empty space between orders.

These are the markets One Dust is interested in: not the entire PoW sector at once, but the places where trading life lags behind the life of the project itself.

The signs are familiar:

- a wide bid–ask spread;
- shallow market depth;
- substantial price movement from an individual trade;
- few available trading pairs;
- liquidity scattered across venues;
- a difficult entry and an even more difficult exit.

A perception gap emerges: the network is working, but its market looks abandoned. A prospective participant sees not the project's history or its community's effort, but the terms on which a trade can actually be made.

Our starting point is simple: keeping a project technically alive and keeping its market alive are different tasks. Working technology deserves attention, but usable trading needs infrastructure of its own.

One Dust is being built to work on that part of the problem.

## 3. Project vision

We want to see the PoW segment not as a collection of isolated markets, each fighting for attention alone, but as a more connected trading environment.

An environment where a new pair opens another route between assets. Where provided liquidity helps a participant make a trade. Where the results of the work can support the next market, the next pair, the next step.

1DUST is intended as a connecting link in that work: a liquidity bridge between selected mineable assets. Here, “bridge” describes trading connections, not an already deployed cross-chain bridge.

Our aims are to:

- connect fragmented markets through pairs with 1DUST;
- work on spreads, depth and trading accessibility;
- develop liquidity where we see a practical opportunity to use it;
- put results back into further building;
- make project rules and actions understandable to the community.

What matters to us is not an impressive list of supported coins, but the purpose of each new connection. Not a venue's logo for its own sake, but a market we can actually work with.

This path takes capital, time and decisions that must be tested in practice. We choose consistent work over a promise to transform an entire sector with one token.

Not promising a miracle. Creating conditions in which markets have more opportunities to live.

## 4. Core token parameters

| Parameter | Value |
|---|---|
| Name | One Dust |
| Ticker | 1DUST |
| Asset type | Volatile cryptocurrency token |
| Issuance network | BNB Smart Chain Mainnet |
| Chain ID | 56 |
| Standard | BEP-20 |
| Contract | `0x3713e7f7413f01019a9f63e9541b6e3ddef72c48` |
| Initial issuance | 50,000,000 1DUST |
| Initial recipient | Safe_4 Cold Treasury |
| Token transfer fee | 0% |
| ICO | Not planned |
| Airdrop | Not planned |
| Predetermined maximum-supply cap | None |
| Additional issuance | Role-controlled treasury minting under published procedures |
| Baseline sell-order reference | 1.015 USD-equivalent per 1DUST |
| Baseline buyback-order reference | 0.985 USD-equivalent per 1DUST |
| Placement limit on one CEX | Up to 10% of total supply |
| Aggregate CEX placement limit | Up to 30% of total supply |
| Separate quantitative DEX-liquidity limit | None established |
| Governance | Mandatory vote on additional issuance; team operational decisions; critical roles exercised through Safe |

Price references and placement limits belong to the project's operating model. Their description does not establish that markets, orders or listings are already active.

## 5. Terms and definitions

### 5.1. One Dust / 1DUST

The One Dust project's token, issued on BNB Smart Chain. Use of the token does not mean that 1DUST itself is mined through PoW.

### 5.2. PoW and mineable coins

Proof of Work is a consensus mechanism involving computational work by miners. In this document, a mineable coin means an asset of a network using PoW.

### 5.3. Liquidity, spread and depth

Liquidity is the ability to trade with acceptable price impact. The spread is the difference between the best bid and ask. Depth is the quantity of orders available at different price levels.

### 5.4. CEX and DEX

A CEX is a centralized trading venue. A DEX is decentralized trading infrastructure using smart contracts and the mechanisms of its protocol.

### 5.5. Total supply

The overall quantity of existing 1DUST after minting and burning, available through the contract's `totalSupply()`. Transfers redistribute tokens between addresses without changing total supply.

### 5.6. Maximum supply

A predetermined upper issuance limit. The 1DUST contract has no such economic cap. Additional issuance is governed by roles and the project's public procedures.

### 5.7. Mint

Issuance of new tokens, increasing total supply. The executing address must hold `MINTER_ROLE`, and the recipient must hold `TREASURY_ROLE` and be unfrozen.

### 5.8. Freeze and unfreeze

Freeze is the restriction applied to an address by a holder of `COMPLIANCE_ROLE`. Unfreeze removes that restriction. Operational Policy governs their use and reporting.

### 5.9. User burning

Ordinary burn functions allow users to destroy their own tokens or tokens covered by an allowance, subject to contract conditions. Burning reduces total supply.

### 5.10. burnFrozen

Administrative, irreversible destruction of a specified token quantity at a frozen address by a holder of `BURNER_ROLE`. It requires no approval from the balance holder and reduces both that balance and total supply.

### 5.11. Safe

A wallet with designated owners and an approval threshold. The project uses both Safes with EOA owners and a nested Admin Safe owned by other Safes.

### 5.12. Buyback and sellback

Buyback means purchasing 1DUST from the market. In the project's terminology, sellback means placing 1DUST for sale through a limit order.

### 5.13. Project treasury and Cold Treasury

The project treasury comprises assets managed by the project. Safe_4 Cold Treasury is a treasury-custody wallet and the recipient of the initial 1DUST issuance. Token movements and proceeds are accounted for according to the asset and purpose of the operation.

### 5.14. Liquidity pool

A pool of assets in a DEX protocol used for trading under that protocol's rules. CEX orders and DEX-pool liquidity are different forms of market participation.

### 5.15. Community vote

The official Discord decision procedure for additional issuance. Advisory polls and discussions are separate and do not replace a mint vote.

## 6. The liquidity problem

A weak market has an unfortunate property: a shortage of liquidity can perpetuate itself.

A wide spread discourages a participant. The participant leaves, and trading activity falls. In a less active market, maintaining depth becomes harder. The next person sees even less attractive conditions and moves on as well.

A market can become trapped in this cycle even while its network continues to work.

One Dust proposes moving in the opposite direction: liquidity should not only wait for demand, but help create conditions in which demand can emerge.

An order gives the market a concrete price and quantity. A pool provides another route for exchange. A new pair connects assets that previously lacked a convenient trading path. Each is a small action on its own; together, they may be the beginning of a more connected market environment.

We want to build it step by step: choose a direction, provide liquidity, examine the actual result and decide where to go next.

One order will not revive an entire sector. But a real order, a real pool and a real trade are where work begins to differ from waiting.

## 7. Buyback / sellback mechanics

### 7.1. Basic principle

The project operator sets the parameters of a limit order to sell 1DUST. As the order fills, proceeds are accounted for, and the project then places a buyback order.

In this model, an “equivalent buyback” means an order to purchase the same quantity of 1DUST as was actually sold. It refers to token quantity, not the same amount of USDT or another settlement asset.

The approach is applied with regard to available balances, fees, venue conditions and actual fills. Its purpose is to organize liquidity work, not to fix the token's price.

### 7.2. Baseline price references

The initial model references are:

- sale: 1.015 USD-equivalent per 1DUST;
- buyback: 0.985 USD-equivalent per 1DUST.

These are references for the team's orders, not guaranteed quotes for every participant or a commitment to keep the market price permanently within that range.

The team may adjust prices, quantities and order duration as conditions change. Community discussion may inform decisions; a separate vote is not required for each order.

### 7.3. Operational sequence

1. Select the venue, settlement asset, sale amount and price.
2. Place the limit sell order.
3. Account for the amount actually filled and proceeds received.
4. Prepare and place an equivalent buyback order.
5. Monitor fills, available balances and results.
6. Amend, cancel or replace orders as needed.
7. Include the work performed in project reporting.

### 7.4. Results and use of funds

A positive financial result may arise when sale and buyback orders actually fill, after costs. The difference between the two quoted reference prices is not itself realized profit.

Funds required for placed buyback orders are accounted for separately from funds available for other project activities.

### 7.5. Implementing the model

The team implements the model through operations on selected venues. The deployed 1DUST contract provides token functions; market-order placement and DEX-position management belong to separate trading infrastructure.

Placing an order does not guarantee a fill. Token holders gain no right to demand redemption at the reference price. The team may change or suspend operations, disclosing changes in approach through reporting.

## 8. Tokenomics and use of assets

### 8.1. Issuance and accounting

The initial 50,000,000 1DUST were issued at deployment to Safe_4 Cold Treasury.

Total supply represents existing tokens. Additional minting increases it; user or administrative burning reduces it. Individual wallet balances are available through `balanceOf(address)`.

Published supply and balance figures state their observation date or block. This document uses total supply to describe the overall quantity of tokens.

### 8.2. Additional issuance and allocation

Ordinary additional issuance goes to Safe_4 Cold Treasury. Another treasury recipient is disclosed under Operational Policy and included in the mint proposal.

The team decides subsequent allocation of existing tokens to liquidity, trading venues and other activities. Treasury transfers are recorded and reflected in reporting.

Minting new tokens and subsequently transferring existing tokens are different operations. A vote on additional issuance does not replace operational management of treasury assets.

### 8.3. Sources of proceeds and expenses

The project model envisages proceeds from:

- buyback / sellback results;
- liquidity-provision fees, where actually received.

After accounting for funds required by placed buyback orders, available assets may be used to acquire PoW assets, create or replenish liquidity, work with venues and maintain infrastructure.

The team decides individual expenditures. Results and asset-use directions are reflected in reporting. Market operations may produce positive or negative outcomes.

### 8.4. CEX placement limits

The team uses the following limits as stop signals for additional 1DUST placement:

- one CEX: up to 10% of current total supply;
- all CEX venues combined: up to 30% of current total supply.

If the 1DUST held on a particular exchange reaches or exceeds 10% of current total supply, the team does not add more tokens to that exchange. If the combined amount reaches or exceeds 30%, the team does not add more tokens to CEX venues overall. Additional placement must not itself exceed the applicable limit.

Checks use blockchain-explorer data for reliably identified exchange-wallet addresses or exchange-published reserve reports containing 1DUST holdings.

### 8.5. DEX liquidity

No separate quantitative limit is established for placing 1DUST in DEX liquidity.

The team sets position parameters according to the assets, protocol and available funds. As markets are created, the project discloses addresses and information on LP-position custody and any locks used.

## 9. Contract, administrative roles and Safe

### 9.1. Implemented capabilities

The contract supports transfers, approvals and allowances, user burning, additional treasury issuance, freeze, unfreeze and `burnFrozen`.

Roles separate issuance, compliance actions, administrative burning, receipt of issuance and administration of permissions.

### 9.2. Deployment and evidence

| Field | Value |
|---|---|
| Deployment transaction | `0x0aa17ce92110056a7c5c2cf1dd1d1093b2ec3264537ab6d91ced01870a791926` |
| Deployment block | `125679825` |
| Deployment UTC | `2026-10-04T12:54:47Z` |
| Initial recipient | Safe_4 Cold Treasury |
| Initial issuance | 50,000,000 1DUST |

The retained [Genesis Report](build-evidence/mainnet/Genesis-Report.md) describes deployment, bytecode comparison, token-state and Safe-configuration observations, and historical wallet execution.

The evidence package was recorded in commit `6ddc9df21942735cc0e78a97141933101658dea1`. Key materials are the [token source](../src/OneDust.sol), [Genesis Report](build-evidence/mainnet/Genesis-Report.md) and [mainnet verification evidence](test-evidence/mainnet/README.md).

### 9.3. Assigned roles

| Role | Safe and address | Observed threshold | Power |
|---|---|---|---|
| `DEFAULT_ADMIN_ROLE` | Safe_0 — `0x6e7153abe3d9040059cbe6861f5219cd2327bc14` | 2 of 3 Safe owners | Granting and revoking roles, including the administrative role |
| `MINTER_ROLE` | Safe_1 — `0xb72609fb717f84631d6b2207e832948b1b86d9e3` | 2 of 3 | Additional treasury minting |
| `COMPLIANCE_ROLE` | Safe_2 — `0xfeb99c8d622bb3028668086be92ac7346f781a52` | 2 of 3 | Freeze and unfreeze |
| `BURNER_ROLE` | Safe_3 — `0x30a2681481607bb594c3d15f24a5e740484598c1` | 3 of 5 | Burning a frozen balance |
| `TREASURY_ROLE` | Safe_4 — `0x60c63b66355b0107ec3faa4a916f9e956a79ddf8` | 2 of 3 | Receipt of issuance |

Roles were assigned at deployment and confirmed for the corresponding addresses at block `128823144`. Safe thresholds and owners were observed separately at block `128825311`; this is not a historical configuration query at deployment.

At block `128823144`, the creator held none of the five checked roles and had a zero 1DUST balance.

### 9.4. Nested Admin Safe

At the observation block, Safe_0's owners were Safe_1, Safe_2 and Safe_3. The Admin threshold requires approval by two of three Safe owners, not two direct EOA signatures.

Separate roles are assigned to different addresses, while operational Safes participate in Admin Safe governance. Describing this structure does not establish independence of controlling persons.

### 9.5. Freeze and burnFrozen

Freeze suspends the affected address's contract-covered operations, including transfers, receipt of issuance, ordinary burning, and approval and allowance operations. A frozen spender also loses the ability to use previously granted allowance.

Unfreeze restores ordinary operations subject to the contract's other conditions.

`burnFrozen` irreversibly destroys a specified token quantity at a frozen address without the balance holder's approval.

Operational Policy sets the grounds, approval process and reporting. In ordinary operations, it protects trading and other critical infrastructure addresses from freeze; emergency cases are considered separately.

### 9.6. Public procedures

Operational Policy sets preparation and execution procedures for critical actions, ordinary waiting periods, emergency exceptions, role management and reporting.

Ordinary minting requires a 48-hour wait after publication of the complete positive voting result. Ordinary `burnFrozen` requires at least 72 hours after the successful on-chain freeze. Emergency exceptions are specified in Operational Policy and require separate documentation.

## 10. Governance and community participation

### 10.1. Mandatory mint vote

Official additional-issuance voting takes place in Discord under Mint Governance. Telegram and X support announcements, discussion and advisory polls.

Mint Governance provides for:

- one “For” or “Against” vote per Discord account;
- no weighting by token balance;
- an ordinary 72-hour vote or a previously justified 24-hour vote;
- approval at no less than 51% of valid votes;
- no minimum turnout requirement;
- proposal and result retention outside Discord.

A positive result is a procedural condition for minting. The Safe may postpone or cancel execution because of a technical, legal or security obstacle, disclosing the reason.

Material changes to the approved amount, recipient or purpose require a new vote. Mint Governance provides the detailed rules.

### 10.2. Operational decisions and consultation

| Topic | Decision process |
|---|---|
| Additional issuance | Mandatory official vote under Mint Governance |
| Listings and venues | Team decision, potentially informed by consultation |
| Pairs, pools and liquidity amounts | Team operational decision |
| Order prices and quantities | Team operational decision |
| PoW-asset selection and use of available funds | Team decision |
| New networks and development directions | Team decision, potentially informed by discussion |
| Document updates | Approval and publication of a new revision; applicable rules of existing proposals remain in place |

Participation follows the Discord procedure rather than token ownership alone. The project combines public discussion with team responsibility for operational execution.

## 11. The token's role

1DUST is not intended merely to exist as another line in a wallet. Its role in the project is to take part in the work of markets.

To become the other side of a pair. To connect a selected PoW asset with another trading opportunity. To participate in orders and pools through which people can buy, sell and exchange assets.

The project therefore intends to use 1DUST:

- in pairs with selected PoW assets;
- for liquidity provision on CEX and DEX venues;
- in sellback and buyback operations;
- as a connecting link between markets being developed.

Where venue support and technical compatibility allow a “PoW asset / 1DUST” pair, there is an opportunity to turn an idea into concrete market work. Each opportunity still has to be assessed and implemented.

The community's role in additional issuance is defined separately: decisions go through Mint Governance. In this model, vote weight does not depend on the number of tokens in a wallet.

For us, the meaning of 1DUST lies in what can be built with it, not in a promise that simply holding it will solve someone's problems.

## 12. Where the project applies

One Dust does not aim to be an answer to everything. It has a particular field of work: mineable coins, related assets and markets that could benefit from an additional trading connection.

We are interested in directions where an asset has a working idea and people behind it, and its market faces a concrete task: depth, accessible exchange or new trading pairs.

These may include:

- PoW coins for which trading with 1DUST can be organized;
- tokens and asset representations connected with PoW ecosystems;
- venues where these pairs and liquidity can be developed.

We want to choose directions not for the number of names in a presentation, but for a clear answer to a question: what can be improved here, and how will we work on it?

Every market has its own technical conditions, participants and risks. Expansion therefore starts with assessment and preparation. We describe a pair, pool or integration as launched only after it actually exists.

Our task is not to cover everything at once. Build one working connection, then the next. Give individual markets more points of contact, and gradually assemble a more connected environment.

## 13. Reporting, documents and transparency

The team records treasury operations and prepares reports on work performed, asset movements and liquidity results.

Additional issuance, role changes, freeze, unfreeze and `burnFrozen` are disclosed under Operational Policy. Reports are published as materials are prepared and checked.

Public materials connect descriptions of actions with addresses, transactions and observation dates. Certain details may be withheld to protect personal information or respond to an active threat; on-chain actions and their economic outcomes remain reflected in reporting.

Approved canonical documents are published on the main branch of the official public GitHub repository. Repository history retains previous revisions. Related documents are referenced without fixing their version numbers; the rules applicable to a particular proposal are retained in its record.

Publishing drafts does not bring public rules into effect.

## 14. Roadmap

The roadmap describes a sequence of work, not guaranteed deadlines or outcomes. Details may be refined as technical conditions and resources are assessed.

### Stage 1. Technical foundation

Token deployment and preparation of the retained local, testnet and mainnet evidence package have been completed within their documented scope. Results and limitations are recorded in technical documentation.

### Stage 2. Public documentation

Align the White Paper, Operational Policy and Mint Governance, prepare canonical revisions and cross-references, and publish the coordinated package.

### Stage 3. Public infrastructure

Update the existing website, its structure and content; align communication channels and references; organize mint votes and archiving under the published rules.

### Stage 4. First market

Prepare initial DEX liquidity on BNB Smart Chain, select a protocol and pair, determine LP-position custody, check integration and disclose the actual launch parameters.

### Stage 5. Venues and market data

Prepare applications to suitable trading and information platforms, including consideration of CEX venues and market-data services. Submitting an application and receiving approval are separate events.

### Stage 6. PoW directions

Select assets and develop technically and economically suitable pairs and pools involving 1DUST.

### Stage 7. Scaling

Assess new networks, integrations and directions. Each expansion requires its own implementation and risk review.

## 15. Team

The project is created and managed by two founders represented under pseudonyms:

- StoryTrain;
- Mayday.

Public materials use a pseudonymous format. The team intends to communicate through public accounts. This presentation does not establish verified legal identities.

Developers, analysts, designers, moderators and other contributors may become involved as the project develops.

## 16. Risks and material features

### 16.1. Market and operational risks

Price and available liquidity may change substantially. Orders may remain unfilled, and market and liquidity operations may produce losses.

Limited capital, execution errors, unavailable venues, withdrawal problems, technical failures and discontinued market support remain risks.

Team price references do not establish an asset-backed token value. Holding 1DUST creates no entitlement to treasury assets or guaranteed redemption.

### 16.2. Powers and governance

The token implementation has no code-upgrade mechanism. However, the administrator can change role holders, including `TREASURY_ROLE` recipients and `BURNER_ROLE` holders.

Issuance has no predetermined economic cap. Freeze can restrict an address's operations, while `burnFrozen` can permanently destroy its frozen balance without the holder's consent.

Safe_3's threshold belongs to that wallet; it is not an immutable condition applying to every future `BURNER_ROLE` holder.

Voting, waiting periods and rules on the use of powers are team commitments. The contract checks technical conditions, not compliance with off-chain procedures.

### 16.3. Keys, Safe and integrations

Key compromise, signing mistakes, unavailable participants and wallet misconfiguration remain risks. Different addresses and thresholds do not by themselves establish independence of controlling persons.

CEX use adds dependence on venue rules and asset custody. DEX operations, LP positions and future cross-chain integrations depend on the chosen protocols' security and operational management.

### 16.4. Limits of technical evidence

The technical package contains separately dated observations and historical executions, not a single current-state snapshot. It is not an independent audit.

Historical Safe BNB transfers predate token deployment and are not mainnet mint or burn tests. State checks at specific blocks do not guarantee that future state remains unchanged.

Users should reconcile the token address, assigned roles, Safes and current public materials before interacting with the project.

## 17. Informational nature

This White Paper describes the project, its technical foundation and intended operations. It is not investment advice and promises no return, price appreciation or fixed 1DUST value.

It does not replace a separate assessment of applicable legal requirements. Publication alone does not establish regulatory approval, the token's legal classification or listing readiness.

## 18. Conclusion

One Dust grew out of a desire to work on a part of the crypto market that can disappear behind large numbers and famous names. Markets where coins are still mined, networks still run and communities still gather, but trading lacks movement and connections.

We want to do more than talk about it.

1DUST already has a deployed contract and a recorded technical foundation. Ahead lies the work it was created for: trading pairs, liquidity, infrastructure and decisions whose results can be checked.

Neither a token nor a white paper brings a market to life on its own. Actions do: consistent, considered actions that match the project's capabilities.

We do not promise an easy path. We choose to take it openly: explain the rules, show the work and build further on real experience.

Our goal is not to create an illusion, but to build infrastructure.\
Not to promise a miracle, but to improve how markets work.\
Not to sell a dream, but to make liquidity a reality.

One Dust. One connection between markets, and another step toward a more vibrant ecosystem.
