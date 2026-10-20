// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import {Test} from "forge-std/Test.sol";
import {OneDust} from "../src/OneDust.sol";

contract OneDustTestnetDeploymentTest is Test {
    address constant ADMIN = 0xA42dB27670Fceb0F236aa5450396Adcc9B5BFB01;
    address constant MINTER = 0x8F2325D4E7c520FDF93470b73fccdEED1e5FAdc4;
    address constant COMPLIANCE = 0xb3323caAD76A0745FE6a260753fd608d89655C83;
    address constant BURNER = 0x9823e7401126BF5eBcC21Bbb6174a74365ab9CED;
    address constant TREASURY = 0x031fC27d09bB5cAA0f8D6a81B2e94C51DBcd06D2;
    address constant DEPLOYER = 0xe64619eEadce3eC495991a5f7FCC57Cfb82B47Cc;

    function testConstructorWithTestnetEOAs() public {
        vm.chainId(97);
        vm.deal(DEPLOYER, 1 ether);
        vm.prank(DEPLOYER);

        OneDust token = new OneDust(
            ADMIN, MINTER, COMPLIANCE, BURNER, TREASURY
        );

        assertEq(token.name(), "One Dust");
        assertEq(token.symbol(), "1DUST");
        assertTrue(token.hasRole(token.DEFAULT_ADMIN_ROLE(), ADMIN));
        assertTrue(token.hasRole(token.MINTER_ROLE(), MINTER));
        assertTrue(token.hasRole(token.COMPLIANCE_ROLE(), COMPLIANCE));
        assertTrue(token.hasRole(token.BURNER_ROLE(), BURNER));
        assertTrue(token.hasRole(token.TREASURY_ROLE(), TREASURY));
        assertEq(token.balanceOf(TREASURY), token.totalSupply());
        assertEq(token.balanceOf(DEPLOYER), 0);
    }
}
