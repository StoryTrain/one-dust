// SPDX-License-Identifier: MIT
pragma solidity 0.8.37;

import {Test} from "forge-std/Test.sol";
import {OneDust} from "../src/OneDust.sol";

contract OneDustEdgeCasesTest is Test {
    OneDust internal token;

    address internal constant ADMIN = address(0xA001);
    address internal constant MINTER = address(0xA002);
    address internal constant COMPLIANCE = address(0xA003);
    address internal constant BURNER = address(0xA004);
    address internal constant TREASURY = address(0xA005);
    address internal constant HOLDER = address(0xA006);
    address internal constant OTHER = address(0xA007);
    address internal constant SPENDER = address(0xA008);
    address internal constant RECIPIENT = address(0xA009);

    function setUp() public {
        token = new OneDust(ADMIN, MINTER, COMPLIANCE, BURNER, TREASURY);

        vm.prank(TREASURY);
        token.transfer(HOLDER, 10 ether);
        vm.prank(TREASURY);
        token.transfer(OTHER, 5 ether);
        vm.prank(HOLDER);
        token.approve(SPENDER, 4 ether);
    }

    function _freeze(address account) internal {
        vm.prank(COMPLIANCE);
        token.freeze(account);
    }

    function _unfreeze(address account) internal {
        vm.prank(COMPLIANCE);
        token.unfreeze(account);
    }

    function test_FrozenOwnerOrSpenderCannotRevokeAllowanceWithApproveZero() public {
        uint256 supply = token.totalSupply();
        uint256 holderBalance = token.balanceOf(HOLDER);

        _freeze(HOLDER);
        vm.expectRevert(bytes("OneDust: owner is frozen"));
        vm.prank(HOLDER);
        token.approve(SPENDER, 0);

        assertEq(token.allowance(HOLDER, SPENDER), 4 ether);
        assertEq(token.balanceOf(HOLDER), holderBalance);
        assertEq(token.totalSupply(), supply);

        _unfreeze(HOLDER);
        _freeze(SPENDER);
        vm.expectRevert(bytes("OneDust: spender is frozen"));
        vm.prank(HOLDER);
        token.approve(SPENDER, 0);

        assertEq(token.allowance(HOLDER, SPENDER), 4 ether);
        assertEq(token.balanceOf(HOLDER), holderBalance);
        assertEq(token.totalSupply(), supply);

        _unfreeze(SPENDER);
        vm.prank(HOLDER);
        token.approve(SPENDER, 0);

        assertEq(token.allowance(HOLDER, SPENDER), 0);
        assertEq(token.balanceOf(HOLDER), holderBalance);
        assertEq(token.totalSupply(), supply);
    }

    function test_TransferFromToFrozenRecipientRestoresFiniteAllowanceOnRevert() public {
        uint256 supply = token.totalSupply();
        _freeze(RECIPIENT);

        vm.expectRevert(bytes("OneDust: recipient is frozen"));
        vm.prank(SPENDER);
        token.transferFrom(HOLDER, RECIPIENT, 1 ether);

        assertEq(token.allowance(HOLDER, SPENDER), 4 ether);
        assertEq(token.balanceOf(HOLDER), 10 ether);
        assertEq(token.balanceOf(RECIPIENT), 0);
        assertEq(token.totalSupply(), supply);
        assertTrue(token.isFrozen(RECIPIENT));

        _unfreeze(RECIPIENT);
        vm.prank(SPENDER);
        assertTrue(token.transferFrom(HOLDER, RECIPIENT, 1 ether));

        assertEq(token.allowance(HOLDER, SPENDER), 3 ether);
        assertEq(token.balanceOf(HOLDER), 9 ether);
        assertEq(token.balanceOf(RECIPIENT), 1 ether);
        assertEq(token.totalSupply(), supply);
    }

    function test_SuccessfulFrozenBurnDoesNotEnableOrdinaryFrozenBurn() public {
        uint256 supply = token.totalSupply();
        _freeze(HOLDER);
        _freeze(OTHER);

        vm.prank(BURNER);
        token.burnFrozen(HOLDER, 3 ether);

        assertEq(token.balanceOf(HOLDER), 7 ether);
        assertEq(token.balanceOf(OTHER), 5 ether);
        assertEq(token.totalSupply(), supply - 3 ether);
        assertTrue(token.isFrozen(HOLDER));

        vm.expectRevert(bytes("OneDust: sender is frozen"));
        vm.prank(HOLDER);
        token.burn(1 ether);

        vm.expectRevert(bytes("OneDust: sender is frozen"));
        vm.prank(OTHER);
        token.burn(1 ether);

        assertEq(token.balanceOf(HOLDER), 7 ether);
        assertEq(token.balanceOf(OTHER), 5 ether);
        assertEq(token.allowance(HOLDER, SPENDER), 4 ether);
        assertEq(token.totalSupply(), supply - 3 ether);
        assertTrue(token.isFrozen(HOLDER));
        assertTrue(token.isFrozen(OTHER));

        _unfreeze(HOLDER);
        vm.prank(HOLDER);
        token.burn(1 ether);

        assertEq(token.balanceOf(HOLDER), 6 ether);
        assertEq(token.balanceOf(OTHER), 5 ether);
        assertEq(token.totalSupply(), supply - 4 ether);
        assertTrue(token.isFrozen(OTHER));
    }
}
