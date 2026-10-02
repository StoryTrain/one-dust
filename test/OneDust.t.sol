// SPDX-License-Identifier: MIT
pragma solidity 0.8.37;

import {Test, Vm} from "forge-std/Test.sol";
import {OneDust} from "../src/OneDust.sol";

contract OneDustTest is Test {
    OneDust internal token;

    address internal constant SAFE_0 = address(0x1000);
    address internal constant SAFE_1 = address(0x1001);
    address internal constant SAFE_2 = address(0x1002);
    address internal constant SAFE_3 = address(0x1003);
    address internal constant SAFE_4 = address(0x1004);
    address internal constant HOLDER = address(0x2000);
    address internal constant SPENDER = address(0x2001);
    address internal constant RECIPIENT = address(0x2002);
    address internal constant TREASURY_2 = address(0x3000);

    uint256 internal constant FUNDED = 10 ether;

    address internal constant DEPLOYER = address(0xD001);
    address internal constant WALLET_A = address(0xD007);
    address internal constant WALLET_B = address(0xD008);
    address internal constant UNAUTHORIZED = address(0xD00B);

    bytes32 internal constant MANUAL_ROLE_GRANTED = keccak256("RoleGranted(bytes32,address,address)");
    bytes32 internal constant MANUAL_ROLE_REVOKED = keccak256("RoleRevoked(bytes32,address,address)");
    bytes32 internal constant MANUAL_TRANSFER = keccak256("Transfer(address,address,uint256)");


    function setUp() public {
        token = new OneDust(SAFE_0, SAFE_1, SAFE_2, SAFE_3, SAFE_4);
    }

    function _fundHolder() internal {
        vm.prank(SAFE_4);
        token.transfer(HOLDER, FUNDED);
    }

    function _approve(uint256 amount) internal {
        vm.prank(HOLDER);
        token.approve(SPENDER, amount);
    }

    function _freeze(address account) internal {
        vm.prank(SAFE_2);
        token.freeze(account);
    }

    function _unfreeze(address account) internal {
        vm.prank(SAFE_2);
        token.unfreeze(account);
    }

    function _expectUnauthorized(address caller, bytes32 role) internal {
        vm.expectRevert(
            abi.encodeWithSignature(
                "AccessControlUnauthorizedAccount(address,bytes32)",
                caller,
                role
            )
        );
    }

function _manualTopic(address account) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(account)));
    }

    function _assertManualTransfer(Vm.Log memory entry, address emitter, address from, address to, uint256 amount) internal pure {
        assertEq(entry.emitter, emitter);
        assertEq(entry.topics.length, 3);
        assertEq(entry.topics[0], MANUAL_TRANSFER);
        assertEq(entry.topics[1], _manualTopic(from));
        assertEq(entry.topics[2], _manualTopic(to));
        assertEq(abi.decode(entry.data, (uint256)), amount);
    }

    function _assertManualRoleEvent(Vm.Log memory entry, bytes32 signature, bytes32 role, address account, address operator) internal view {
        assertEq(entry.emitter, address(token));
        assertEq(entry.topics.length, 4);
        assertEq(entry.topics[0], signature);
        assertEq(entry.topics[1], role);
        assertEq(entry.topics[2], _manualTopic(account));
        assertEq(entry.topics[3], _manualTopic(operator));
        assertEq(entry.data.length, 0);
    }

    function _fundManual(address to, uint256 amount) internal {
        vm.prank(SAFE_4);
        token.transfer(to, amount);
    }

    function _manualRole(uint256 index) internal view returns (bytes32) {
        if (index == 0) return token.MINTER_ROLE();
        if (index == 1) return token.COMPLIANCE_ROLE();
        if (index == 2) return token.BURNER_ROLE();
        return token.TREASURY_ROLE();
    }

    function _manualHolder(uint256 index) internal pure returns (address) {
        if (index == 0) return SAFE_1;
        if (index == 1) return SAFE_2;
        if (index == 2) return SAFE_3;
        return SAFE_4;
    }

    // Section 7A. Constructor and initial state

function test_InitialStateAndRoles() public view {
        assertEq(token.name(), "One Dust");
        assertEq(token.symbol(), "1DUST");
        assertEq(token.decimals(), 18);
        assertEq(token.INITIAL_SUPPLY(), 50_000_000 ether);
        assertEq(token.totalSupply(), token.INITIAL_SUPPLY());
        assertEq(token.balanceOf(SAFE_4), token.INITIAL_SUPPLY());

        bytes32[5] memory roles = [
            token.DEFAULT_ADMIN_ROLE(),
            token.MINTER_ROLE(),
            token.COMPLIANCE_ROLE(),
            token.BURNER_ROLE(),
            token.TREASURY_ROLE()
        ];
        address[5] memory safes = [SAFE_0, SAFE_1, SAFE_2, SAFE_3, SAFE_4];
        for (uint256 i; i < 5; ++i) {
            for (uint256 j; j < 5; ++j) {
                assertEq(token.hasRole(roles[i], safes[j]), i == j);
            }
            assertFalse(token.hasRole(roles[i], address(this)));
            assertEq(token.getRoleAdmin(roles[i]), token.DEFAULT_ADMIN_ROLE());
        }
    }

function test_ConstructorEventsAndDeployerSeparation() public {
        vm.recordLogs();
        vm.prank(DEPLOYER);
        OneDust fresh = new OneDust(SAFE_0, SAFE_1, SAFE_2, SAFE_3, SAFE_4);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 6);
        bytes32[5] memory roles = [
            fresh.DEFAULT_ADMIN_ROLE(), fresh.MINTER_ROLE(), fresh.COMPLIANCE_ROLE(),
            fresh.BURNER_ROLE(), fresh.TREASURY_ROLE()
        ];
        address[5] memory safes = [SAFE_0, SAFE_1, SAFE_2, SAFE_3, SAFE_4];
        for (uint256 i; i < 5; ++i) {
            assertEq(entries[i].emitter, address(fresh));
            assertEq(entries[i].topics.length, 4);
            assertEq(entries[i].topics[0], MANUAL_ROLE_GRANTED);
            assertEq(entries[i].topics[1], roles[i]);
            assertEq(entries[i].topics[2], _manualTopic(safes[i]));
            assertEq(entries[i].topics[3], _manualTopic(DEPLOYER));
            assertEq(entries[i].data.length, 0);
            assertFalse(fresh.hasRole(roles[i], DEPLOYER));
        }
        _assertManualTransfer(entries[5], address(fresh), address(0), SAFE_4, fresh.INITIAL_SUPPLY());
        assertEq(fresh.balanceOf(SAFE_4), fresh.INITIAL_SUPPLY());
        assertEq(fresh.balanceOf(DEPLOYER), 0);
    }

function test_ConstructorRejectsZeroSafe0() public {
        vm.expectRevert(bytes("OneDust: zero Safe_0"));
        new OneDust(address(0), SAFE_1, SAFE_2, SAFE_3, SAFE_4);
    }

function test_ConstructorRejectsZeroSafe1() public {
        vm.expectRevert(bytes("OneDust: zero Safe_1"));
        new OneDust(SAFE_0, address(0), SAFE_2, SAFE_3, SAFE_4);
    }

function test_ConstructorRejectsZeroSafe2() public {
        vm.expectRevert(bytes("OneDust: zero Safe_2"));
        new OneDust(SAFE_0, SAFE_1, address(0), SAFE_3, SAFE_4);
    }

function test_ConstructorRejectsZeroSafe3() public {
        vm.expectRevert(bytes("OneDust: zero Safe_3"));
        new OneDust(SAFE_0, SAFE_1, SAFE_2, address(0), SAFE_4);
    }

function test_ConstructorRejectsZeroSafe4() public {
        vm.expectRevert(bytes("OneDust: zero Safe_4"));
        new OneDust(SAFE_0, SAFE_1, SAFE_2, SAFE_3, address(0));
    }

    // Section 7B. Standard ERC-20

function test_TransferAndAllowanceFailuresDoNotChangeState() public {
        _fundManual(WALLET_A, 10 ether);
        uint256 supply = token.totalSupply();
        vm.prank(WALLET_A);
        token.transfer(WALLET_B, 3 ether);
        assertEq(token.balanceOf(WALLET_A), 7 ether);
        assertEq(token.balanceOf(WALLET_B), 3 ether);
        assertEq(token.totalSupply(), supply);
        vm.prank(WALLET_A);
        token.approve(SPENDER, 2 ether);
        vm.prank(SPENDER);
        token.transferFrom(WALLET_A, WALLET_B, 1 ether);
        assertEq(token.balanceOf(WALLET_A), 6 ether);
        assertEq(token.balanceOf(WALLET_B), 4 ether);
        assertEq(token.allowance(WALLET_A, SPENDER), 1 ether);
        vm.expectRevert();
        vm.prank(WALLET_A);
        token.transfer(WALLET_B, 7 ether);
        vm.expectRevert();
        vm.prank(SPENDER);
        token.transferFrom(WALLET_A, WALLET_B, 2 ether);
        vm.expectRevert();
        vm.prank(SPENDER);
        token.burnFrom(WALLET_A, 2 ether);
        assertEq(token.balanceOf(WALLET_A), 6 ether);
        assertEq(token.balanceOf(WALLET_B), 4 ether);
        assertEq(token.allowance(WALLET_A, SPENDER), 1 ether);
        assertEq(token.totalSupply(), supply);
    }

function test_OrdinaryBurnAndBurnFrom() public {
        _fundHolder();
        uint256 supply = token.totalSupply();
        vm.prank(HOLDER);
        token.burn(1 ether);
        assertEq(token.balanceOf(HOLDER), FUNDED - 1 ether);
        assertEq(token.totalSupply(), supply - 1 ether);
        _approve(4 ether);
        vm.prank(SPENDER);
        token.burnFrom(HOLDER, 3 ether);
        assertEq(token.balanceOf(HOLDER), FUNDED - 4 ether);
        assertEq(token.totalSupply(), supply - 4 ether);
        assertEq(token.allowance(HOLDER, SPENDER), 1 ether);
    }

    // Section 7C. Mint and TREASURY_ROLE

function test_MintAuthorizationAndTreasuryLifecycle() public {
        bytes32 treasuryRole = token.TREASURY_ROLE();
        uint256 initial = token.totalSupply();

        _expectUnauthorized(SAFE_4, token.MINTER_ROLE());
        vm.prank(SAFE_4);
        token.mint(SAFE_4, 1 ether);

        vm.expectRevert(bytes("OneDust: recipient lacks treasury role"));
        vm.prank(SAFE_1);
        token.mint(TREASURY_2, 1 ether);

        vm.prank(SAFE_0);
        token.grantRole(treasuryRole, TREASURY_2);
        vm.prank(SAFE_1);
        token.mint(TREASURY_2, 5 ether);
        assertEq(token.balanceOf(TREASURY_2), 5 ether);
        assertEq(token.totalSupply(), initial + 5 ether);

        vm.prank(SAFE_0);
        token.revokeRole(treasuryRole, TREASURY_2);
        vm.expectRevert(bytes("OneDust: recipient lacks treasury role"));
        vm.prank(SAFE_1);
        token.mint(TREASURY_2, 1 ether);
        assertEq(token.balanceOf(TREASURY_2), 5 ether);
        assertEq(token.totalSupply(), initial + 5 ether);

        vm.prank(SAFE_1);
        token.mint(SAFE_4, 2 ether);
        assertEq(token.balanceOf(SAFE_4), initial + 2 ether);
        assertEq(token.totalSupply(), initial + 7 ether);
    }

function test_MintEventsZeroRecipientAndFrozenSecondTreasury() public {
        uint256 supply = token.totalSupply();
        vm.recordLogs();
        vm.prank(SAFE_1);
        token.mint(SAFE_4, 4 ether);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        _assertManualTransfer(entries[0], address(token), address(0), SAFE_4, 4 ether);
        assertEq(token.balanceOf(SAFE_4), supply + 4 ether);
        assertEq(token.totalSupply(), supply + 4 ether);
        vm.expectRevert(bytes("OneDust: recipient lacks treasury role"));
        vm.prank(SAFE_1);
        token.mint(address(0), 1 ether);
        vm.expectRevert();
        vm.prank(UNAUTHORIZED);
        token.mint(SAFE_4, 1 ether);
        bytes32 treasuryRole = token.TREASURY_ROLE();
        vm.prank(SAFE_0);
        token.grantRole(treasuryRole, TREASURY_2);
        vm.prank(SAFE_2);
        token.freeze(TREASURY_2);
        vm.expectRevert(bytes("OneDust: recipient is frozen"));
        vm.prank(SAFE_1);
        token.mint(TREASURY_2, 1 ether);
        assertEq(token.balanceOf(TREASURY_2), 0);
        assertEq(token.totalSupply(), supply + 4 ether);
    }

function test_FrozenTreasuryCannotReceiveMint() public {
        uint256 supply = token.totalSupply();
        _freeze(SAFE_4);
        vm.expectRevert(bytes("OneDust: recipient is frozen"));
        vm.prank(SAFE_1);
        token.mint(SAFE_4, 1 ether);
        assertEq(token.balanceOf(SAFE_4), supply);
        assertEq(token.totalSupply(), supply);
    }

function test_FrozenTreasuryRoleRecipientCannotMint() public {
        bytes32 treasuryRole = token.TREASURY_ROLE();
        vm.prank(SAFE_0);
        token.grantRole(treasuryRole, WALLET_A);
        vm.prank(SAFE_2);
        token.freeze(WALLET_A);
        uint256 supply = token.totalSupply();
        vm.expectRevert(bytes("OneDust: recipient is frozen"));
        vm.prank(SAFE_1);
        token.mint(WALLET_A, 1 ether);
        assertEq(token.totalSupply(), supply);
        assertEq(token.balanceOf(WALLET_A), 0);
    }

    // Section 7D. Role management

function test_AdminControlsEachOperationalRoleAndEvents() public {
        for (uint256 i; i < 4; ++i) {
            bytes32 role = _manualRole(i);
            vm.recordLogs();
            vm.prank(SAFE_0);
            token.grantRole(role, UNAUTHORIZED);
            Vm.Log[] memory granted = vm.getRecordedLogs();
            assertEq(granted.length, 1);
            _assertManualRoleEvent(granted[0], MANUAL_ROLE_GRANTED, role, UNAUTHORIZED, SAFE_0);
            assertTrue(token.hasRole(role, UNAUTHORIZED));
            vm.recordLogs();
            vm.prank(SAFE_0);
            token.revokeRole(role, UNAUTHORIZED);
            Vm.Log[] memory revoked = vm.getRecordedLogs();
            assertEq(revoked.length, 1);
            _assertManualRoleEvent(revoked[0], MANUAL_ROLE_REVOKED, role, UNAUTHORIZED, SAFE_0);
            assertFalse(token.hasRole(role, UNAUTHORIZED));
            for (uint256 j; j < 4; ++j) {
                address caller = _manualHolder(j);
                vm.expectRevert();
                vm.prank(caller);
                token.grantRole(role, UNAUTHORIZED);
                vm.expectRevert();
                vm.prank(caller);
                token.revokeRole(role, SAFE_0);
            }
            vm.expectRevert();
            vm.prank(UNAUTHORIZED);
            token.grantRole(role, UNAUTHORIZED);
            vm.expectRevert();
            vm.prank(UNAUTHORIZED);
            token.revokeRole(role, _manualHolder(i));
            assertTrue(token.hasRole(role, _manualHolder(i)));
        }
    }

function test_AdminCanAcquireRolesAndRevokeBurner() public {
        bytes32 minterRole = token.MINTER_ROLE();
        bytes32 burnerRole = token.BURNER_ROLE();

        vm.prank(SAFE_0);
        token.grantRole(minterRole, SAFE_0);

        vm.prank(SAFE_0);
        token.grantRole(burnerRole, SAFE_0);

        assertTrue(token.hasRole(minterRole, SAFE_0));
        assertTrue(token.hasRole(burnerRole, SAFE_0));

        uint256 supply = token.totalSupply();

        vm.prank(SAFE_0);
        token.mint(SAFE_4, 1 ether);

        assertEq(token.totalSupply(), supply + 1 ether);

        _fundHolder();
        _freeze(HOLDER);

        vm.prank(SAFE_0);
        token.revokeRole(burnerRole, SAFE_3);

        assertFalse(token.hasRole(burnerRole, SAFE_3));

        _expectUnauthorized(SAFE_3, burnerRole);
        vm.prank(SAFE_3);
        token.burnFrozen(HOLDER, 1 ether);

        assertEq(token.balanceOf(HOLDER), FUNDED);
        assertEq(token.totalSupply(), supply + 1 ether);
    }

function test_NonAdminCannotManageRoles() public {
        bytes32 adminRole = token.DEFAULT_ADMIN_ROLE();
        bytes32 burnerRole = token.BURNER_ROLE();
        bytes32 treasuryRole = token.TREASURY_ROLE();
        _expectUnauthorized(SAFE_1, adminRole);
        vm.prank(SAFE_1);
        token.grantRole(burnerRole, SAFE_1);
        _expectUnauthorized(SAFE_1, adminRole);
        vm.prank(SAFE_1);
        token.grantRole(treasuryRole, TREASURY_2);
        assertFalse(token.hasRole(burnerRole, SAFE_1));
        assertFalse(token.hasRole(treasuryRole, TREASURY_2));
    }

function test_RevokedMinterCannotMint() public {
        bytes32 minterRole = token.MINTER_ROLE();
        vm.prank(SAFE_0);
        token.revokeRole(minterRole, SAFE_1);
        uint256 supply = token.totalSupply();
        vm.expectRevert();
        vm.prank(SAFE_1);
        token.mint(SAFE_4, 1 ether);
        assertEq(token.totalSupply(), supply);
    }

function test_RevokedComplianceCannotFreezeOrUnfreeze() public {
        vm.prank(SAFE_2);
        token.freeze(WALLET_A);
        bytes32 complianceRole = token.COMPLIANCE_ROLE();
        vm.prank(SAFE_0);
        token.revokeRole(complianceRole, SAFE_2);
        vm.expectRevert();
        vm.prank(SAFE_2);
        token.unfreeze(WALLET_A);
        vm.expectRevert();
        vm.prank(SAFE_2);
        token.freeze(WALLET_B);
        assertTrue(token.isFrozen(WALLET_A));
        assertFalse(token.isFrozen(WALLET_B));
    }

function test_RevokingSoleAdminPreventsRecovery() public {
        bytes32 adminRole = token.DEFAULT_ADMIN_ROLE();
        bytes32 minterRole = token.MINTER_ROLE();

        vm.prank(SAFE_0);
        token.revokeRole(adminRole, SAFE_0);

        assertFalse(token.hasRole(adminRole, SAFE_0));

        _expectUnauthorized(SAFE_0, adminRole);
        vm.prank(SAFE_0);
        token.grantRole(adminRole, TREASURY_2);

        _expectUnauthorized(SAFE_0, adminRole);
        vm.prank(SAFE_0);
        token.grantRole(minterRole, TREASURY_2);

        assertFalse(token.hasRole(adminRole, TREASURY_2));
        assertFalse(token.hasRole(minterRole, TREASURY_2));
        assertTrue(token.hasRole(minterRole, SAFE_1));
    }

    // Section 7E. Freeze / unfreeze

function test_ComplianceAuthorizationAndTransitions() public {
        bytes32 role = token.COMPLIANCE_ROLE();
        _expectUnauthorized(SAFE_1, role);
        vm.prank(SAFE_1);
        token.freeze(HOLDER);
        assertFalse(token.isFrozen(HOLDER));

        vm.expectRevert(bytes("OneDust: not frozen"));
        vm.prank(SAFE_2);
        token.unfreeze(HOLDER);
        _freeze(HOLDER);
        vm.expectRevert(bytes("OneDust: already frozen"));
        vm.prank(SAFE_2);
        token.freeze(HOLDER);
        _expectUnauthorized(SAFE_1, role);
        vm.prank(SAFE_1);
        token.unfreeze(HOLDER);
        assertTrue(token.isFrozen(HOLDER));
        _unfreeze(HOLDER);
        assertFalse(token.isFrozen(HOLDER));

        vm.expectRevert(bytes("OneDust: zero address"));
        vm.prank(SAFE_2);
        token.freeze(address(0));
        vm.expectRevert(bytes("OneDust: zero address"));
        vm.prank(SAFE_2);
        token.unfreeze(address(0));
    }

function test_FreezeAndUnfreezeEvents() public {
        vm.expectEmit(true, true, false, false, address(token));
        emit OneDust.AddressFrozen(HOLDER, SAFE_2);
        _freeze(HOLDER);
        vm.expectEmit(true, true, false, false, address(token));
        emit OneDust.AddressUnfrozen(HOLDER, SAFE_2);
        _unfreeze(HOLDER);
    }

function test_FrozenHolderRecipientAndUnfreeze() public {
        _fundHolder();
        _approve(type(uint256).max);
        uint256 supply = token.totalSupply();
        _freeze(HOLDER);

        vm.expectRevert(bytes("OneDust: sender is frozen"));
        vm.prank(HOLDER);
        token.transfer(RECIPIENT, 1 ether);
        vm.expectRevert(bytes("OneDust: sender is frozen"));
        vm.prank(SPENDER);
        token.transferFrom(HOLDER, RECIPIENT, 1 ether);
        vm.expectRevert(bytes("OneDust: sender is frozen"));
        vm.prank(HOLDER);
        token.burn(1 ether);
        assertEq(token.balanceOf(HOLDER), FUNDED);
        assertEq(token.balanceOf(RECIPIENT), 0);
        assertEq(token.allowance(HOLDER, SPENDER), type(uint256).max);
        assertEq(token.totalSupply(), supply);

        _unfreeze(HOLDER);
        vm.prank(HOLDER);
        token.transfer(RECIPIENT, 1 ether);
        assertEq(token.balanceOf(HOLDER), FUNDED - 1 ether);
        assertEq(token.balanceOf(RECIPIENT), 1 ether);
        assertEq(token.totalSupply(), supply);

        _freeze(RECIPIENT);
        vm.expectRevert(bytes("OneDust: recipient is frozen"));
        vm.prank(HOLDER);
        token.transfer(RECIPIENT, 1 ether);
        assertEq(token.balanceOf(RECIPIENT), 1 ether);
        assertEq(token.balanceOf(HOLDER), FUNDED - 1 ether);
    }

function test_FrozenOwnerAndSpenderCannotApprove() public {
        _approve(2 ether);
        _freeze(HOLDER);
        vm.expectRevert(bytes("OneDust: owner is frozen"));
        vm.prank(HOLDER);
        token.approve(SPENDER, 3 ether);
        assertEq(token.allowance(HOLDER, SPENDER), 2 ether);
        _unfreeze(HOLDER);
        _freeze(SPENDER);
        vm.expectRevert(bytes("OneDust: spender is frozen"));
        vm.prank(HOLDER);
        token.approve(SPENDER, 3 ether);
        assertEq(token.allowance(HOLDER, SPENDER), 2 ether);
    }

function test_FrozenOwnerCannotBurnFromAndUnfreezeRestoresActions() public {
        _fundManual(WALLET_A, 10 ether);
        vm.prank(WALLET_A);
        token.approve(SPENDER, 5 ether);
        vm.prank(SAFE_2);
        token.freeze(WALLET_A);
        uint256 supply = token.totalSupply();
        vm.expectRevert(bytes("OneDust: owner is frozen"));
        vm.prank(SPENDER);
        token.burnFrom(WALLET_A, 2 ether);
        assertEq(token.allowance(WALLET_A, SPENDER), 5 ether);
        assertEq(token.balanceOf(WALLET_A), 10 ether);
        assertEq(token.totalSupply(), supply);
        vm.prank(SAFE_2);
        token.unfreeze(WALLET_A);
        vm.prank(WALLET_A);
        token.approve(SPENDER, 3 ether);
        vm.prank(WALLET_A);
        token.burn(1 ether);
        assertEq(token.allowance(WALLET_A, SPENDER), 3 ether);
        assertEq(token.balanceOf(WALLET_A), 9 ether);
        assertEq(token.totalSupply(), supply - 1 ether);
        vm.prank(SPENDER);
        token.burnFrom(WALLET_A, 2 ether);
        assertEq(token.allowance(WALLET_A, SPENDER), 1 ether);
        assertEq(token.balanceOf(WALLET_A), 7 ether);
        assertEq(token.totalSupply(), supply - 3 ether);
    }

function test_FrozenSpenderCannotSpendFiniteAllowance() public {
        _fundHolder();
        _approve(4 ether);
        _freeze(SPENDER);
        vm.expectRevert(bytes("OneDust: spender is frozen"));
        vm.prank(SPENDER);
        token.transferFrom(HOLDER, RECIPIENT, 1 ether);
        assertEq(token.allowance(HOLDER, SPENDER), 4 ether);
        assertEq(token.balanceOf(HOLDER), FUNDED);
        assertEq(token.balanceOf(RECIPIENT), 0);

        _unfreeze(SPENDER);
        vm.prank(SPENDER);
        token.transferFrom(HOLDER, RECIPIENT, 1 ether);
        assertEq(token.allowance(HOLDER, SPENDER), 3 ether);
        assertEq(token.balanceOf(HOLDER), FUNDED - 1 ether);
        assertEq(token.balanceOf(RECIPIENT), 1 ether);
    }

function test_FrozenSpenderCannotSpendInfiniteAllowance() public {
        _fundHolder();
        _approve(type(uint256).max);
        _freeze(SPENDER);
        uint256 supply = token.totalSupply();
        vm.expectRevert(bytes("OneDust: spender is frozen"));
        vm.prank(SPENDER);
        token.transferFrom(HOLDER, RECIPIENT, 1 ether);
        vm.expectRevert(bytes("OneDust: spender is frozen"));
        vm.prank(SPENDER);
        token.burnFrom(HOLDER, 1 ether);
        assertEq(token.allowance(HOLDER, SPENDER), type(uint256).max);
        assertEq(token.balanceOf(HOLDER), FUNDED);
        assertEq(token.balanceOf(RECIPIENT), 0);
        assertEq(token.totalSupply(), supply);
    }

function test_OnlyComplianceCanFreezeAndUnfreeze() public {
        address[4] memory callers = [SAFE_1, SAFE_3, SAFE_4, UNAUTHORIZED];
        for (uint256 i; i < callers.length; ++i) {
            vm.expectRevert();
            vm.prank(callers[i]);
            token.freeze(WALLET_A);
        }
        vm.prank(SAFE_2);
        token.freeze(WALLET_A);
        for (uint256 i; i < callers.length; ++i) {
            vm.expectRevert();
            vm.prank(callers[i]);
            token.unfreeze(WALLET_A);
        }
        assertTrue(token.isFrozen(WALLET_A));
    }

    // Section 7F. burnFrozen

function test_BurnFrozenAuthorizationAndBounds() public {
        _fundHolder();
        uint256 supply = token.totalSupply();
        _expectUnauthorized(SAFE_1, token.BURNER_ROLE());
        vm.prank(SAFE_1);
        token.burnFrozen(HOLDER, 1 ether);
        vm.expectRevert(bytes("OneDust: account is not frozen"));
        vm.prank(SAFE_3);
        token.burnFrozen(HOLDER, 1 ether);
        vm.expectRevert(bytes("OneDust: zero address"));
        vm.prank(SAFE_3);
        token.burnFrozen(address(0), 1 ether);
        _freeze(HOLDER);
        vm.expectRevert(
            abi.encodeWithSignature(
                "ERC20InsufficientBalance(address,uint256,uint256)",
                HOLDER,
                FUNDED,
                FUNDED + 1
            )
        );
        vm.prank(SAFE_3);
        token.burnFrozen(HOLDER, FUNDED + 1);
        assertEq(token.balanceOf(HOLDER), FUNDED);
        assertEq(token.totalSupply(), supply);
        assertTrue(token.isFrozen(HOLDER));
        vm.expectRevert(bytes("OneDust: sender is frozen"));
        vm.prank(HOLDER);
        token.transfer(RECIPIENT, 1 ether);
        vm.expectRevert(bytes("OneDust: owner is frozen"));
        vm.prank(HOLDER);
        token.approve(SPENDER, 1 ether);
        vm.expectRevert(bytes("OneDust: sender is frozen"));
        vm.prank(HOLDER);
        token.burn(1 ether);
        assertEq(token.allowance(HOLDER, SPENDER), 0);
        assertEq(token.balanceOf(HOLDER), FUNDED);
        assertEq(token.totalSupply(), supply);

        vm.prank(SAFE_3);
        token.burnFrozen(HOLDER, 3 ether);
        assertEq(token.balanceOf(HOLDER), FUNDED - 3 ether);
        assertEq(token.totalSupply(), supply - 3 ether);
        assertTrue(token.isFrozen(HOLDER));
        vm.expectRevert(bytes("OneDust: sender is frozen"));
        vm.prank(HOLDER);
        token.transfer(RECIPIENT, 1 ether);
    }

function test_BurnFrozenEvent() public {
        _fundHolder();
        _freeze(HOLDER);
        vm.expectEmit(true, true, false, true, address(token));
        emit OneDust.FrozenFundsBurned(HOLDER, 3 ether, SAFE_3);
        vm.prank(SAFE_3);
        token.burnFrozen(HOLDER, 3 ether);
        assertEq(token.balanceOf(HOLDER), FUNDED - 3 ether);
    }

function test_BurnFrozenRequiresBurnerAndEmitsBothEvents() public {
        _fundManual(WALLET_A, 10 ether);
        vm.prank(SAFE_2);
        token.freeze(WALLET_A);
        uint256 supply = token.totalSupply();
        vm.expectRevert();
        vm.prank(SAFE_2);
        token.burnFrozen(WALLET_A, 1 ether);
        vm.recordLogs();
        vm.prank(SAFE_3);
        token.burnFrozen(WALLET_A, 2 ether);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 2);
        _assertManualTransfer(entries[0], address(token), WALLET_A, address(0), 2 ether);
        assertEq(entries[1].emitter, address(token));
        assertEq(entries[1].topics.length, 3);
        assertEq(entries[1].topics[0], keccak256("FrozenFundsBurned(address,uint256,address)"));
        assertEq(entries[1].topics[1], _manualTopic(WALLET_A));
        assertEq(entries[1].topics[2], _manualTopic(SAFE_3));
        assertEq(abi.decode(entries[1].data, (uint256)), 2 ether);
        assertEq(token.balanceOf(WALLET_A), 8 ether);
        assertEq(token.totalSupply(), supply - 2 ether);
        assertTrue(token.isFrozen(WALLET_A));
    }

function testFuzz_BurnFrozenPreservesBalanceAndSupply(uint256 requested) public {
        uint256 amount = bound(requested, 1, FUNDED);
        _fundHolder();
        _freeze(HOLDER);
        uint256 supply = token.totalSupply();
        vm.prank(SAFE_3);
        token.burnFrozen(HOLDER, amount);
        assertEq(token.balanceOf(HOLDER), FUNDED - amount);
        assertEq(token.totalSupply(), supply - amount);
        assertTrue(token.isFrozen(HOLDER));
    }
}