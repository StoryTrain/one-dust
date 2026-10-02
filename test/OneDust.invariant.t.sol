// SPDX-License-Identifier: MIT
pragma solidity 0.8.37;

import {Test} from "forge-std/Test.sol";
import {OneDust} from "../src/OneDust.sol";

contract OneDustHandler is Test {
    OneDust public immutable token;
    address public immutable minter;
    address public immutable compliance;
    address public immutable burner;
    address public immutable treasury;
    address public immutable alice;
    address public immutable bob;
    address public immutable spender;

    uint256 public ghostMinted;
    uint256 public ghostBurned;
    uint256 public successfulMints;
    uint256 public successfulBurns;
    uint256 public successfulTransfers;
    uint256 public successfulApprovals;
    uint256 public successfulFreezes;
    uint256 public successfulUnfreezes;
    uint256 public successfulFrozenBurns;
    uint256 public rejectedFrozenTransfers;
    uint256 public rejectedFrozenRecipients;
    uint256 public rejectedFrozenOwnerApprovals;
    uint256 public rejectedFrozenSpenderTransfers;
    uint256 public rejectedFrozenSpenderBurns;
    uint256 public rejectedNonTreasuryMints;
    uint256 public rejectedUnfrozenBurns;

    constructor(
        OneDust token_,
        address minter_,
        address compliance_,
        address burner_,
        address treasury_,
        address alice_,
        address bob_,
        address spender_
    ) {
        token = token_;
        minter = minter_;
        compliance = compliance_;
        burner = burner_;
        treasury = treasury_;
        alice = alice_;
        bob = bob_;
        spender = spender_;
    }

    function actor(uint256 seed) public view returns (address) {
        uint256 index = seed % 4;
        if (index == 0) return treasury;
        if (index == 1) return alice;
        if (index == 2) return bob;
        return spender;
    }

    function mint(uint256 amountSeed) external {
        if (token.isFrozen(treasury)) return;
        uint256 amount = bound(amountSeed, 1, 1_000_000 ether);
        uint256 supplyBefore = token.totalSupply();
        uint256 balanceBefore = token.balanceOf(treasury);
        assertTrue(token.hasRole(token.TREASURY_ROLE(), treasury));
        vm.prank(minter);
        token.mint(treasury, amount);
        assertEq(token.totalSupply(), supplyBefore + amount);
        assertEq(token.balanceOf(treasury), balanceBefore + amount);
        ghostMinted += amount;
        successfulMints++;
    }

    function transferTokens(uint256 fromSeed, uint256 toSeed, uint256 amountSeed) external {
        address from = actor(fromSeed);
        address to = actor(toSeed);
        if (from == to || token.isFrozen(from) || token.isFrozen(to)) return;
        uint256 balance = token.balanceOf(from);
        if (balance == 0) return;
        uint256 amount = bound(amountSeed, 1, balance);
        uint256 supplyBefore = token.totalSupply();
        vm.prank(from);
        assertTrue(token.transfer(to, amount));
        assertEq(token.totalSupply(), supplyBefore);
        successfulTransfers++;
    }

    function approveSpender(uint256 ownerSeed, uint256 amountSeed) external {
        address owner = actor(ownerSeed);
        if (owner == spender || token.isFrozen(owner) || token.isFrozen(spender)) return;
        uint256 amount = bound(amountSeed, 0, 1_000_000 ether);
        uint256 supplyBefore = token.totalSupply();
        vm.prank(owner);
        assertTrue(token.approve(spender, amount));
        assertEq(token.allowance(owner, spender), amount);
        assertEq(token.totalSupply(), supplyBefore);
        successfulApprovals++;
    }

    function transferFromTokens(uint256 ownerSeed, uint256 toSeed, uint256 amountSeed) external {
        address owner = actor(ownerSeed);
        address to = actor(toSeed);
        if (owner == spender || owner == to || token.isFrozen(owner) || token.isFrozen(spender) || token.isFrozen(to)) return;
        uint256 available = token.allowance(owner, spender);
        uint256 balance = token.balanceOf(owner);
        if (available < balance) balance = available;
        if (balance == 0) return;
        uint256 amount = bound(amountSeed, 1, balance);
        uint256 supplyBefore = token.totalSupply();
        vm.prank(spender);
        assertTrue(token.transferFrom(owner, to, amount));
        assertEq(token.totalSupply(), supplyBefore);
        successfulTransfers++;
    }

    function burnTokens(uint256 ownerSeed, uint256 amountSeed) external {
        address owner = actor(ownerSeed);
        if (token.isFrozen(owner)) return;
        uint256 balance = token.balanceOf(owner);
        if (balance == 0) return;
        uint256 amount = bound(amountSeed, 1, balance);
        uint256 supplyBefore = token.totalSupply();
        uint256 balanceBefore = token.balanceOf(owner);
        vm.prank(owner);
        token.burn(amount);
        assertEq(token.totalSupply(), supplyBefore - amount);
        assertEq(token.balanceOf(owner), balanceBefore - amount);
        ghostBurned += amount;
        successfulBurns++;
    }

    function burnFromTokens(uint256 ownerSeed, uint256 amountSeed) external {
        address owner = actor(ownerSeed);
        if (owner == spender || token.isFrozen(owner) || token.isFrozen(spender)) return;
        uint256 available = token.allowance(owner, spender);
        uint256 balance = token.balanceOf(owner);
        if (available < balance) balance = available;
        if (balance == 0) return;
        uint256 amount = bound(amountSeed, 1, balance);
        uint256 supplyBefore = token.totalSupply();
        uint256 balanceBefore = token.balanceOf(owner);
        vm.prank(spender);
        token.burnFrom(owner, amount);
        assertEq(token.totalSupply(), supplyBefore - amount);
        assertEq(token.balanceOf(owner), balanceBefore - amount);
        ghostBurned += amount;
        successfulBurns++;
    }

    function freezeActor(uint256 actorSeed) external {
        address account = actor(actorSeed);
        if (token.isFrozen(account)) return;
        uint256 supplyBefore = token.totalSupply();
        vm.prank(compliance);
        token.freeze(account);
        assertTrue(token.isFrozen(account));
        assertEq(token.totalSupply(), supplyBefore);
        successfulFreezes++;
    }

    function unfreezeActor(uint256 actorSeed) external {
        address account = actor(actorSeed);
        if (!token.isFrozen(account)) return;
        uint256 supplyBefore = token.totalSupply();
        vm.prank(compliance);
        token.unfreeze(account);
        assertFalse(token.isFrozen(account));
        assertEq(token.totalSupply(), supplyBefore);
        successfulUnfreezes++;
    }

    function burnFrozenTokens(uint256 actorSeed, uint256 amountSeed) external {
        address account = actor(actorSeed);
        if (!token.isFrozen(account)) return;
        uint256 balance = token.balanceOf(account);
        if (balance == 0) return;
        uint256 amount = bound(amountSeed, 1, balance);
        uint256 supplyBefore = token.totalSupply();
        address other = account == bob ? alice : bob;
        uint256 otherBefore = token.balanceOf(other);
        vm.prank(burner);
        token.burnFrozen(account, amount);
        assertEq(token.totalSupply(), supplyBefore - amount);
        assertEq(token.balanceOf(account), balance - amount);
        assertEq(token.balanceOf(other), otherBefore);
        assertTrue(token.isFrozen(account));
        ghostBurned += amount;
        successfulFrozenBurns++;
    }

    function tryFrozenTransfer(uint256 accountSeed, uint256 amountSeed) external {
        address account = actor(accountSeed);
        if (!token.isFrozen(account)) return;
        address to = account == bob ? alice : bob;
        uint256 amount = bound(amountSeed, 1, 1_000 ether);
        uint256 supplyBefore = token.totalSupply();
        uint256 fromBefore = token.balanceOf(account);
        uint256 toBefore = token.balanceOf(to);
        uint256 allowanceBefore = token.allowance(account, spender);
        bool frozenBefore = token.isFrozen(account);
        vm.prank(account);
        try token.transfer(to, amount) returns (bool) {
            fail("frozen sender transferred");
        } catch {
            assertEq(token.totalSupply(), supplyBefore);
            assertEq(token.balanceOf(account), fromBefore);
            assertEq(token.balanceOf(to), toBefore);
            assertEq(token.allowance(account, spender), allowanceBefore);
            assertEq(token.isFrozen(account), frozenBefore);
            rejectedFrozenTransfers++;
        }
    }

    function tryFrozenRecipient(uint256 recipientSeed, uint256 amountSeed) external {
        address recipient = actor(recipientSeed);
        if (!token.isFrozen(recipient)) return;
        address from = recipient == treasury ? alice : treasury;
        if (token.isFrozen(from) || token.balanceOf(from) == 0) return;
        uint256 amount = bound(amountSeed, 1, token.balanceOf(from));
        uint256 supplyBefore = token.totalSupply();
        uint256 fromBefore = token.balanceOf(from);
        uint256 recipientBefore = token.balanceOf(recipient);
        uint256 allowanceBefore = token.allowance(from, spender);
        bool frozenBefore = token.isFrozen(recipient);
        vm.prank(from);
        try token.transfer(recipient, amount) returns (bool) {
            fail("frozen recipient received transfer");
        } catch {
            assertEq(token.totalSupply(), supplyBefore);
            assertEq(token.balanceOf(from), fromBefore);
            assertEq(token.balanceOf(recipient), recipientBefore);
            assertEq(token.allowance(from, spender), allowanceBefore);
            assertEq(token.isFrozen(recipient), frozenBefore);
            rejectedFrozenRecipients++;
        }
    }

    function tryFrozenOwnerApprove(uint256 ownerSeed, uint256 amountSeed) external {
        address owner = actor(ownerSeed);
        if (!token.isFrozen(owner)) return;
        uint256 supplyBefore = token.totalSupply();
        uint256 ownerBefore = token.balanceOf(owner);
        uint256 spenderBefore = token.balanceOf(spender);
        uint256 allowanceBefore = token.allowance(owner, spender);
        bool frozenBefore = token.isFrozen(owner);
        uint256 amount = bound(amountSeed, 0, 1_000_000 ether);
        vm.prank(owner);
        try token.approve(spender, amount) returns (bool) {
            fail("frozen owner changed allowance");
        } catch {
            assertEq(token.totalSupply(), supplyBefore);
            assertEq(token.balanceOf(owner), ownerBefore);
            assertEq(token.balanceOf(spender), spenderBefore);
            assertEq(token.allowance(owner, spender), allowanceBefore);
            assertEq(token.isFrozen(owner), frozenBefore);
            rejectedFrozenOwnerApprovals++;
        }
    }

    function tryFrozenSpenderTransfer(uint256 ownerSeed, uint256 amountSeed) external {
        if (!token.isFrozen(spender)) return;
        address owner = actor(ownerSeed);
        if (owner == spender || owner == bob || token.isFrozen(owner)) return;
        uint256 available = token.allowance(owner, spender);
        uint256 balance = token.balanceOf(owner);
        if (available < balance) balance = available;
        if (balance == 0 || token.isFrozen(bob)) return;
        uint256 amount = bound(amountSeed, 1, balance);
        uint256 supplyBefore = token.totalSupply();
        uint256 ownerBefore = token.balanceOf(owner);
        uint256 bobBefore = token.balanceOf(bob);
        uint256 allowanceBefore = token.allowance(owner, spender);
        vm.prank(spender);
        try token.transferFrom(owner, bob, amount) returns (bool) {
            fail("frozen spender transferred");
        } catch {
            assertEq(token.totalSupply(), supplyBefore);
            assertEq(token.balanceOf(owner), ownerBefore);
            assertEq(token.balanceOf(bob), bobBefore);
            assertEq(token.allowance(owner, spender), allowanceBefore);
            rejectedFrozenSpenderTransfers++;
        }
    }

    function tryFrozenSpenderBurn(uint256 ownerSeed, uint256 amountSeed) external {
        if (!token.isFrozen(spender)) return;
        address owner = actor(ownerSeed);
        if (owner == spender || token.isFrozen(owner)) return;
        uint256 available = token.allowance(owner, spender);
        uint256 balance = token.balanceOf(owner);
        if (available < balance) balance = available;
        if (balance == 0) return;
        uint256 amount = bound(amountSeed, 1, balance);
        uint256 supplyBefore = token.totalSupply();
        uint256 ownerBefore = token.balanceOf(owner);
        uint256 allowanceBefore = token.allowance(owner, spender);
        vm.prank(spender);
        try token.burnFrom(owner, amount) {
            fail("frozen spender burned");
        } catch {
            assertEq(token.totalSupply(), supplyBefore);
            assertEq(token.balanceOf(owner), ownerBefore);
            assertEq(token.allowance(owner, spender), allowanceBefore);
            rejectedFrozenSpenderBurns++;
        }
    }

    function tryNonTreasuryMint(uint256 amountSeed) external {
        assertFalse(token.hasRole(token.TREASURY_ROLE(), alice));
        uint256 amount = bound(amountSeed, 1, 1_000 ether);
        uint256 supplyBefore = token.totalSupply();
        uint256 balanceBefore = token.balanceOf(alice);
        bool frozenBefore = token.isFrozen(alice);
        bool roleBefore = token.hasRole(token.TREASURY_ROLE(), alice);
        vm.prank(minter);
        try token.mint(alice, amount) {
            fail("minted to non-treasury");
        } catch {
            assertEq(token.totalSupply(), supplyBefore);
            assertEq(token.balanceOf(alice), balanceBefore);
            assertEq(token.isFrozen(alice), frozenBefore);
            assertEq(token.hasRole(token.TREASURY_ROLE(), alice), roleBefore);
            rejectedNonTreasuryMints++;
        }
    }

    function tryBurnUnfrozen(uint256 accountSeed, uint256 amountSeed) external {
        address account = actor(accountSeed);
        if (token.isFrozen(account)) return;
        uint256 amount = bound(amountSeed, 1, 1_000 ether);
        uint256 supplyBefore = token.totalSupply();
        uint256 balanceBefore = token.balanceOf(account);
        uint256 otherBefore = token.balanceOf(account == bob ? alice : bob);
        bool frozenBefore = token.isFrozen(account);
        vm.prank(burner);
        try token.burnFrozen(account, amount) {
            fail("burned unfrozen funds");
        } catch {
            assertEq(token.totalSupply(), supplyBefore);
            assertEq(token.balanceOf(account), balanceBefore);
            assertEq(token.balanceOf(account == bob ? alice : bob), otherBefore);
            assertEq(token.isFrozen(account), frozenBefore);
            rejectedUnfrozenBurns++;
        }
    }
}

contract OneDustInvariantTest is Test {
    OneDust internal token;
    OneDustHandler internal handler;

    address internal constant ADMIN = address(0xA001);
    address internal constant MINTER = address(0xA002);
    address internal constant COMPLIANCE = address(0xA003);
    address internal constant BURNER = address(0xA004);
    address internal constant TREASURY = address(0xA005);
    address internal constant ALICE = address(0xA006);
    address internal constant BOB = address(0xA007);
    address internal constant SPENDER = address(0xA008);
    address internal constant DEPLOYER = address(0xA009);

    function setUp() public {
        vm.prank(DEPLOYER);
        token = new OneDust(ADMIN, MINTER, COMPLIANCE, BURNER, TREASURY);
        handler = new OneDustHandler(
            token, MINTER, COMPLIANCE, BURNER, TREASURY, ALICE, BOB, SPENDER
        );
        targetContract(address(handler));
        bytes4[] memory selectors = new bytes4[](16);
        selectors[0] = OneDustHandler.mint.selector;
        selectors[1] = OneDustHandler.transferTokens.selector;
        selectors[2] = OneDustHandler.approveSpender.selector;
        selectors[3] = OneDustHandler.transferFromTokens.selector;
        selectors[4] = OneDustHandler.burnTokens.selector;
        selectors[5] = OneDustHandler.burnFromTokens.selector;
        selectors[6] = OneDustHandler.freezeActor.selector;
        selectors[7] = OneDustHandler.unfreezeActor.selector;
        selectors[8] = OneDustHandler.burnFrozenTokens.selector;
        selectors[9] = OneDustHandler.tryFrozenTransfer.selector;
        selectors[10] = OneDustHandler.tryFrozenSpenderTransfer.selector;
        selectors[11] = OneDustHandler.tryFrozenSpenderBurn.selector;
        selectors[12] = OneDustHandler.tryNonTreasuryMint.selector;
        selectors[13] = OneDustHandler.tryBurnUnfrozen.selector;
        selectors[14] = OneDustHandler.tryFrozenRecipient.selector;
        selectors[15] = OneDustHandler.tryFrozenOwnerApprove.selector;
        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
    }

    function invariant_SupplyMatchesGhostAccounting() public view {
        assertEq(
            token.totalSupply() + handler.ghostBurned(),
            token.INITIAL_SUPPLY() + handler.ghostMinted()
        );
    }

    function invariant_SupplyMatchesAllTrackedBalances() public view {
        uint256 balances = token.balanceOf(TREASURY)
            + token.balanceOf(ALICE)
            + token.balanceOf(BOB)
            + token.balanceOf(SPENDER);
        assertEq(token.totalSupply(), balances);
    }

    function invariant_RolesStaySeparated() public view {
        assertTrue(token.hasRole(token.DEFAULT_ADMIN_ROLE(), ADMIN));
        assertTrue(token.hasRole(token.MINTER_ROLE(), MINTER));
        assertTrue(token.hasRole(token.COMPLIANCE_ROLE(), COMPLIANCE));
        assertTrue(token.hasRole(token.BURNER_ROLE(), BURNER));
        assertTrue(token.hasRole(token.TREASURY_ROLE(), TREASURY));
        assertFalse(token.hasRole(token.DEFAULT_ADMIN_ROLE(), DEPLOYER));
        assertFalse(token.hasRole(token.MINTER_ROLE(), DEPLOYER));
        assertFalse(token.hasRole(token.COMPLIANCE_ROLE(), DEPLOYER));
        assertFalse(token.hasRole(token.BURNER_ROLE(), DEPLOYER));
        assertFalse(token.hasRole(token.TREASURY_ROLE(), DEPLOYER));
    }

// Add the following functions INSIDE OneDustInvariantTest, after the existing
// invariant_RolesStaySeparated() function and before the final closing brace.
// This is an insertion snippet, not a replacement for the whole test file.

    function test_FrozenSpenderCannotTransferExistingAllowance() public {
        uint256 amount = 10 ether;
        vm.prank(TREASURY);
        token.transfer(ALICE, 100 ether);
        vm.prank(ALICE);
        token.approve(SPENDER, 50 ether);
        assertEq(token.allowance(ALICE, SPENDER), 50 ether);
        vm.prank(COMPLIANCE);
        token.freeze(SPENDER);

        uint256 supplyBefore = token.totalSupply();
        uint256 aliceBefore = token.balanceOf(ALICE);
        uint256 bobBefore = token.balanceOf(BOB);
        uint256 allowanceBefore = token.allowance(ALICE, SPENDER);

        vm.prank(SPENDER);
        vm.expectRevert(bytes("OneDust: spender is frozen"));
        token.transferFrom(ALICE, BOB, amount);

        assertEq(token.totalSupply(), supplyBefore);
        assertEq(token.balanceOf(ALICE), aliceBefore);
        assertEq(token.balanceOf(BOB), bobBefore);
        assertEq(token.allowance(ALICE, SPENDER), allowanceBefore);
        assertTrue(token.isFrozen(SPENDER));
    }

    function test_FrozenSpenderCannotBurnExistingAllowance() public {
        uint256 amount = 10 ether;
        vm.prank(TREASURY);
        token.transfer(ALICE, 100 ether);
        vm.prank(ALICE);
        token.approve(SPENDER, 50 ether);
        assertEq(token.allowance(ALICE, SPENDER), 50 ether);
        vm.prank(COMPLIANCE);
        token.freeze(SPENDER);

        uint256 supplyBefore = token.totalSupply();
        uint256 aliceBefore = token.balanceOf(ALICE);
        uint256 allowanceBefore = token.allowance(ALICE, SPENDER);

        vm.prank(SPENDER);
        vm.expectRevert(bytes("OneDust: spender is frozen"));
        token.burnFrom(ALICE, amount);

        assertEq(token.totalSupply(), supplyBefore);
        assertEq(token.balanceOf(ALICE), aliceBefore);
        assertEq(token.allowance(ALICE, SPENDER), allowanceBefore);
        assertTrue(token.isFrozen(SPENDER));
    }

    function test_FrozenRecipientHandlerPath() public {
        vm.prank(COMPLIANCE);
        token.freeze(BOB);
        uint256 supplyBefore = token.totalSupply();
        uint256 treasuryBefore = token.balanceOf(TREASURY);
        handler.tryFrozenRecipient(2, 1 ether);
        assertEq(handler.rejectedFrozenRecipients(), 1);
        assertEq(token.totalSupply(), supplyBefore);
        assertEq(token.balanceOf(TREASURY), treasuryBefore);
        assertEq(token.balanceOf(BOB), 0);
        assertTrue(token.isFrozen(BOB));
    }

    function test_FrozenOwnerApproveHandlerPath() public {
        vm.prank(TREASURY);
        token.transfer(ALICE, 2 ether);
        vm.prank(ALICE);
        token.approve(SPENDER, 1 ether);
        vm.prank(COMPLIANCE);
        token.freeze(ALICE);
        uint256 supplyBefore = token.totalSupply();
        handler.tryFrozenOwnerApprove(1, 3 ether);
        assertEq(handler.rejectedFrozenOwnerApprovals(), 1);
        assertEq(token.totalSupply(), supplyBefore);
        assertEq(token.balanceOf(ALICE), 2 ether);
        assertEq(token.allowance(ALICE, SPENDER), 1 ether);
        assertTrue(token.isFrozen(ALICE));
    }


}

contract OneDustRoleHandler is Test {
    OneDust public immutable token;
    address public immutable admin;
    address public immutable minter;
    address public immutable compliance;
    address public immutable burner;
    address public immutable treasury;
    address public immutable candidate;
    address public immutable outsider;

    uint256 public ghostMinted;
    uint256 public ghostBurned;
    uint256 public mintSucceeded;
    uint256 public mintRejected;
    uint256 public freezeSucceeded;
    uint256 public freezeRejected;
    uint256 public unfreezeSucceeded;
    uint256 public unfreezeRejected;
    uint256 public burnFrozenSucceeded;
    uint256 public burnFrozenRejected;
    uint256 public outsiderGrantRejected;

    constructor(
        OneDust token_, address admin_, address minter_, address compliance_,
        address burner_, address treasury_, address candidate_, address outsider_
    ) {
        token = token_;
        admin = admin_;
        minter = minter_;
        compliance = compliance_;
        burner = burner_;
        treasury = treasury_;
        candidate = candidate_;
        outsider = outsider_;
    }

    function managedRole(uint256 seed) public view returns (bytes32) {
        uint256 index = seed % 4;
        if (index == 0) return token.MINTER_ROLE();
        if (index == 1) return token.COMPLIANCE_ROLE();
        if (index == 2) return token.BURNER_ROLE();
        return token.TREASURY_ROLE();
    }

    function grantCandidate(uint256 roleSeed) external {
        bytes32 role = managedRole(roleSeed);
        vm.prank(admin);
        token.grantRole(role, candidate);
        assertTrue(token.hasRole(role, candidate));
    }

    function revokeCandidate(uint256 roleSeed) external {
        bytes32 role = managedRole(roleSeed);
        vm.prank(admin);
        token.revokeRole(role, candidate);
        assertFalse(token.hasRole(role, candidate));
    }

    function revokeOriginal(uint256 roleSeed) external {
        bytes32 role = managedRole(roleSeed);
        address holder = _originalHolder(roleSeed);
        vm.prank(admin);
        token.revokeRole(role, holder);
        assertFalse(token.hasRole(role, holder));
    }

    function grantOriginal(uint256 roleSeed) external {
        bytes32 role = managedRole(roleSeed);
        address holder = _originalHolder(roleSeed);
        vm.prank(admin);
        token.grantRole(role, holder);
        assertTrue(token.hasRole(role, holder));
    }

    function mintTo(
        uint256 minterSeed,
        uint256 recipientSeed,
        uint256 amountSeed
    ) external {
        address caller = minterSeed % 2 == 0 ? minter : candidate;
        address recipient = recipientSeed % 2 == 0 ? treasury : candidate;
        uint256 amount = bound(amountSeed, 1, 1_000 ether);

        bool allowed = token.hasRole(token.MINTER_ROLE(), caller)
            && token.hasRole(token.TREASURY_ROLE(), recipient)
            && !token.isFrozen(recipient);

        uint256 supplyBefore = token.totalSupply();
        uint256 recipientBefore = token.balanceOf(recipient);
        bool recipientFrozenBefore = token.isFrozen(recipient);
        bool callerMinterBefore = token.hasRole(token.MINTER_ROLE(), caller);
        bool recipientTreasuryBefore = token.hasRole(token.TREASURY_ROLE(), recipient);
        bool succeeded;

        vm.prank(caller);
        try token.mint(recipient, amount) {
            succeeded = true;
        } catch {
            succeeded = false;
        }

        assertEq(succeeded, allowed, "mint result differs from active roles");
        if (succeeded) {
            mintSucceeded++;
        } else {
            mintRejected++;
        }
        if (succeeded) {
            assertEq(token.totalSupply(), supplyBefore + amount);
            assertEq(token.balanceOf(recipient), recipientBefore + amount);
            ghostMinted += amount;
        } else {
            assertEq(token.totalSupply(), supplyBefore);
            assertEq(token.balanceOf(recipient), recipientBefore);
            assertEq(token.isFrozen(recipient), recipientFrozenBefore);
            assertEq(token.hasRole(token.MINTER_ROLE(), caller), callerMinterBefore);
            assertEq(token.hasRole(token.TREASURY_ROLE(), recipient), recipientTreasuryBefore);
        }
    }

    function freezeCandidate(uint256 callerSeed) external {
        address caller = callerSeed % 2 == 0 ? compliance : candidate;
        bool wasFrozen = token.isFrozen(candidate);
        bool allowed = token.hasRole(token.COMPLIANCE_ROLE(), caller)
            && !wasFrozen;

        uint256 supplyBefore = token.totalSupply();
        bool succeeded;

        vm.prank(caller);
        try token.freeze(candidate) {
            succeeded = true;
        } catch {
            succeeded = false;
        }

        assertEq(succeeded, allowed, "freeze result differs from active role");
        if (succeeded) {
            freezeSucceeded++;
        } else {
            freezeRejected++;
        }
        assertEq(token.isFrozen(candidate), succeeded ? true : wasFrozen);
        assertEq(token.totalSupply(), supplyBefore);
    }

    function unfreezeCandidate(uint256 callerSeed) external {
        address caller = callerSeed % 2 == 0 ? compliance : candidate;
        bool wasFrozen = token.isFrozen(candidate);
        bool allowed = token.hasRole(token.COMPLIANCE_ROLE(), caller)
            && wasFrozen;

        uint256 supplyBefore = token.totalSupply();
        bool succeeded;

        vm.prank(caller);
        try token.unfreeze(candidate) {
            succeeded = true;
        } catch {
            succeeded = false;
        }

        assertEq(succeeded, allowed, "unfreeze result differs from active role");
        if (succeeded) {
            unfreezeSucceeded++;
        } else {
            unfreezeRejected++;
        }
        assertEq(token.isFrozen(candidate), succeeded ? false : wasFrozen);
        assertEq(token.totalSupply(), supplyBefore);
    }

    function burnCandidate(
        uint256 callerSeed,
        uint256 amountSeed
    ) external {
        address caller = callerSeed % 2 == 0 ? burner : candidate;
        uint256 balanceBefore = token.balanceOf(candidate);
        uint256 amount = bound(amountSeed, 1, 1_000 ether);

        bool allowed = token.hasRole(token.BURNER_ROLE(), caller)
            && token.isFrozen(candidate)
            && balanceBefore >= amount;

        uint256 supplyBefore = token.totalSupply();
        uint256 treasuryBefore = token.balanceOf(treasury);
        bool frozenBefore = token.isFrozen(candidate);
        bool burnerRoleBefore = token.hasRole(token.BURNER_ROLE(), caller);
        bool succeeded;

        vm.prank(caller);
        try token.burnFrozen(candidate, amount) {
            succeeded = true;
        } catch {
            succeeded = false;
        }

        assertEq(
            succeeded,
            allowed,
            "frozen burn result differs from role, freeze or balance"
        );
        if (succeeded) {
            burnFrozenSucceeded++;
        } else {
            burnFrozenRejected++;
        }
        if (succeeded) {
            assertEq(token.balanceOf(candidate), balanceBefore - amount);
            assertEq(token.totalSupply(), supplyBefore - amount);
            assertEq(token.balanceOf(treasury), treasuryBefore);
            assertEq(token.isFrozen(candidate), frozenBefore);
            ghostBurned += amount;
        } else {
            assertEq(token.balanceOf(candidate), balanceBefore);
            assertEq(token.balanceOf(treasury), treasuryBefore);
            assertEq(token.totalSupply(), supplyBefore);
            assertEq(token.isFrozen(candidate), frozenBefore);
            assertEq(token.hasRole(token.BURNER_ROLE(), caller), burnerRoleBefore);
        }
    }

    function outsiderGrant(uint256 roleSeed) external {
        bytes32 role = managedRole(roleSeed);
        bool hadRole = token.hasRole(role, candidate);
        uint256 supplyBefore = token.totalSupply();
        uint256 treasuryBefore = token.balanceOf(treasury);
        uint256 candidateBefore = token.balanceOf(candidate);
        bool frozenBefore = token.isFrozen(candidate);

        vm.prank(outsider);
        try token.grantRole(role, candidate) {
            fail("outsider granted a role");
        } catch {
            assertEq(token.hasRole(role, candidate), hadRole);
            assertEq(token.totalSupply(), supplyBefore);
            assertEq(token.balanceOf(treasury), treasuryBefore);
            assertEq(token.balanceOf(candidate), candidateBefore);
            assertEq(token.isFrozen(candidate), frozenBefore);
            outsiderGrantRejected++;
        }
    }

    function _originalHolder(uint256 seed) internal view returns (address) {
        uint256 index = seed % 4;
        if (index == 0) return minter;
        if (index == 1) return compliance;
        if (index == 2) return burner;
        return treasury;
    }
}

contract OneDustRolesInvariantTest is Test {
    OneDust internal token;
    OneDustRoleHandler internal handler;

    address internal constant ADMIN = address(0xB001);
    address internal constant MINTER = address(0xB002);
    address internal constant COMPLIANCE = address(0xB003);
    address internal constant BURNER = address(0xB004);
    address internal constant TREASURY = address(0xB005);
    address internal constant CANDIDATE = address(0xB006);
    address internal constant OUTSIDER = address(0xB007);
    address internal constant DEPLOYER = address(0xB008);

    function setUp() public {
        vm.prank(DEPLOYER);
        token = new OneDust(ADMIN, MINTER, COMPLIANCE, BURNER, TREASURY);
        handler = new OneDustRoleHandler(
            token, ADMIN, MINTER, COMPLIANCE, BURNER,
            TREASURY, CANDIDATE, OUTSIDER
        );
        targetContract(address(handler));
        bytes4[] memory selectors = new bytes4[](9);
        selectors[0] = OneDustRoleHandler.grantCandidate.selector;
        selectors[1] = OneDustRoleHandler.revokeCandidate.selector;
        selectors[2] = OneDustRoleHandler.revokeOriginal.selector;
        selectors[3] = OneDustRoleHandler.grantOriginal.selector;
        selectors[4] = OneDustRoleHandler.mintTo.selector;
        selectors[5] = OneDustRoleHandler.freezeCandidate.selector;
        selectors[6] = OneDustRoleHandler.unfreezeCandidate.selector;
        selectors[7] = OneDustRoleHandler.burnCandidate.selector;
        selectors[8] = OneDustRoleHandler.outsiderGrant.selector;
        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
    }

    function invariant_SupplyTracksRoleDependentOperations() public view {
        assertEq(
            token.totalSupply() + handler.ghostBurned(),
            token.INITIAL_SUPPLY() + handler.ghostMinted()
        );
        assertEq(
            token.totalSupply(),
            token.balanceOf(TREASURY) + token.balanceOf(CANDIDATE)
        );
    }

    function invariant_AdminAndOutsiderCannotChangeByTheseActions() public view {
        assertTrue(token.hasRole(token.DEFAULT_ADMIN_ROLE(), ADMIN));
        assertFalse(token.hasRole(token.DEFAULT_ADMIN_ROLE(), OUTSIDER));
        assertFalse(token.hasRole(token.DEFAULT_ADMIN_ROLE(), DEPLOYER));
        assertFalse(token.hasRole(token.MINTER_ROLE(), OUTSIDER));
        assertFalse(token.hasRole(token.COMPLIANCE_ROLE(), OUTSIDER));
        assertFalse(token.hasRole(token.BURNER_ROLE(), OUTSIDER));
        assertFalse(token.hasRole(token.TREASURY_ROLE(), OUTSIDER));
        assertFalse(token.hasRole(token.MINTER_ROLE(), DEPLOYER));
        assertFalse(token.hasRole(token.COMPLIANCE_ROLE(), DEPLOYER));
        assertFalse(token.hasRole(token.BURNER_ROLE(), DEPLOYER));
        assertFalse(token.hasRole(token.TREASURY_ROLE(), DEPLOYER));
    }

    function test_RoleHandlerCountersReachExpectedPaths() public {
        // 1. Mint to the candidate must fail without TREASURY_ROLE.
        handler.mintTo(0, 1, 1 ether);
        assertEq(handler.mintRejected(), 1);
        assertEq(handler.mintSucceeded(), 0);

        // 2. Once the admin grants TREASURY_ROLE to the candidate, mint succeeds.
        handler.grantCandidate(3);
        handler.mintTo(0, 1, 2 ether);
        assertEq(handler.mintSucceeded(), 1);
        assertEq(token.balanceOf(CANDIDATE), 2 ether);

        // 3. Only an active COMPLIANCE_ROLE permits freeze and unfreeze.
        handler.freezeCandidate(1);
        assertEq(handler.freezeRejected(), 1);

        handler.freezeCandidate(0);
        assertEq(handler.freezeSucceeded(), 1);
        assertTrue(token.isFrozen(CANDIDATE));

        handler.unfreezeCandidate(1);
        assertEq(handler.unfreezeRejected(), 1);

        handler.unfreezeCandidate(0);
        assertEq(handler.unfreezeSucceeded(), 1);
        assertFalse(token.isFrozen(CANDIDATE));

        // 4. burnFrozen fails without a freeze and succeeds after the freeze.
        handler.burnCandidate(0, 1 ether);
        assertEq(handler.burnFrozenRejected(), 1);

        handler.freezeCandidate(0);
        handler.burnCandidate(0, 1 ether);
        assertEq(handler.burnFrozenSucceeded(), 1);
        assertEq(token.balanceOf(CANDIDATE), 1 ether);

        // 5. The outsider cannot grant roles.
        handler.outsiderGrant(0);
        assertEq(handler.outsiderGrantRejected(), 1);
        assertFalse(token.hasRole(token.MINTER_ROLE(), OUTSIDER));

        // Final supply reflects the successful mint and burn.
        assertEq(
            token.totalSupply(),
            token.INITIAL_SUPPLY() + 2 ether - 1 ether
        );
    }

    function test_AdminHandoverBeforeRevocationPreservesControl() public {
        bytes32 adminRole = token.DEFAULT_ADMIN_ROLE();
        bytes32 minterRole = token.MINTER_ROLE();

        vm.prank(ADMIN);
        token.grantRole(adminRole, CANDIDATE);

        assertTrue(token.hasRole(adminRole, ADMIN));
        assertTrue(token.hasRole(adminRole, CANDIDATE));

        vm.prank(CANDIDATE);
        token.revokeRole(adminRole, ADMIN);

        assertFalse(token.hasRole(adminRole, ADMIN));
        assertTrue(token.hasRole(adminRole, CANDIDATE));

        vm.prank(CANDIDATE);
        token.revokeRole(minterRole, MINTER);
        assertFalse(token.hasRole(minterRole, MINTER));

        vm.prank(CANDIDATE);
        token.grantRole(minterRole, MINTER);
        assertTrue(token.hasRole(minterRole, MINTER));

        assertFalse(token.hasRole(adminRole, DEPLOYER));
        assertFalse(token.hasRole(adminRole, OUTSIDER));
    }

    function test_RevokingSoleAdminMakesRoleManagementUnrecoverable() public {
        bytes32 adminRole = token.DEFAULT_ADMIN_ROLE();
        bytes32 minterRole = token.MINTER_ROLE();

        assertTrue(token.hasRole(adminRole, ADMIN));
        assertFalse(token.hasRole(adminRole, CANDIDATE));

        vm.prank(ADMIN);
        token.revokeRole(adminRole, ADMIN);

        assertFalse(token.hasRole(adminRole, ADMIN));
        assertFalse(token.hasRole(adminRole, CANDIDATE));

        vm.prank(ADMIN);
        vm.expectRevert();
        token.grantRole(adminRole, ADMIN);

        vm.prank(CANDIDATE);
        vm.expectRevert();
        token.grantRole(adminRole, CANDIDATE);

        vm.prank(OUTSIDER);
        vm.expectRevert();
        token.grantRole(minterRole, OUTSIDER);

        assertFalse(token.hasRole(adminRole, ADMIN));
        assertFalse(token.hasRole(adminRole, CANDIDATE));
        assertFalse(token.hasRole(minterRole, OUTSIDER));

        // Losing the admin role does not revoke an existing MINTER_ROLE.
        assertTrue(token.hasRole(minterRole, MINTER));
    }

    function test_SoleAdminCanRenounceRole() public {
        bytes32 adminRole = token.DEFAULT_ADMIN_ROLE();

        assertTrue(token.hasRole(adminRole, ADMIN));
        assertFalse(token.hasRole(adminRole, CANDIDATE));

        vm.prank(ADMIN);
        token.renounceRole(adminRole, ADMIN);

        assertFalse(token.hasRole(adminRole, ADMIN));

        vm.prank(ADMIN);
        vm.expectRevert();
        token.grantRole(adminRole, ADMIN);

        assertTrue(token.hasRole(token.MINTER_ROLE(), MINTER));
    }
}