// SPDX-License-Identifier: MIT
pragma solidity 0.8.37;

import {ERC20} from "@openzeppelin/contracts@5.6.1/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts@5.6.1/token/ERC20/extensions/ERC20Burnable.sol";
import {AccessControl} from "@openzeppelin/contracts@5.6.1/access/AccessControl.sol";

/**
 * @title OneDust
 * @notice Immutable BEP-20 token for BNB Smart Chain with separated Safe roles,
 * restricted treasury minting, address freezing, and frozen-balance burning.
 *
 * Role layout at deployment:
 * - DEFAULT_ADMIN_ROLE: Safe_0
 * - MINTER_ROLE:        Safe_1
 * - COMPLIANCE_ROLE:    Safe_2
 * - BURNER_ROLE:        Safe_3
 * - TREASURY_ROLE:      Safe_4
 *
 * The deployer receives no role. There is no proxy, owner, upgrade mechanism,
 * supply cap, external rescue function, or admin withdrawal function.
 */
contract OneDust is ERC20, ERC20Burnable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant COMPLIANCE_ROLE = keccak256("COMPLIANCE_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant TREASURY_ROLE = keccak256("TREASURY_ROLE");

    uint256 public constant INITIAL_SUPPLY = 50_000_000 * 10 ** 18;

    mapping(address => bool) private _frozen;

    // Narrow internal execution flag used exclusively by burnFrozen().
    bool private _burningFrozenFunds;

    event AddressFrozen(address indexed account, address indexed operator);
    event AddressUnfrozen(address indexed account, address indexed operator);
    event FrozenFundsBurned(
        address indexed account,
        uint256 amount,
        address indexed operator
    );

    /**
     * @param safe0Admin Safe_0 (2-of-3): DEFAULT_ADMIN_ROLE.
     * @param safe1Minter Safe_1 (2-of-3): MINTER_ROLE.
     * @param safe2Compliance Safe_2 (2-of-3): COMPLIANCE_ROLE.
     * @param safe3Burner Safe_3 (3-of-5): BURNER_ROLE.
     * @param safe4Treasury Safe_4 (2-of-3 cold treasury): TREASURY_ROLE and
     * initial recipient of 50,000,000 1DUST.
     */
    constructor(
        address safe0Admin,
        address safe1Minter,
        address safe2Compliance,
        address safe3Burner,
        address safe4Treasury
    ) ERC20("One Dust", "1DUST") {
        require(safe0Admin != address(0), "OneDust: zero Safe_0");
        require(safe1Minter != address(0), "OneDust: zero Safe_1");
        require(safe2Compliance != address(0), "OneDust: zero Safe_2");
        require(safe3Burner != address(0), "OneDust: zero Safe_3");
        require(safe4Treasury != address(0), "OneDust: zero Safe_4");

        _grantRole(DEFAULT_ADMIN_ROLE, safe0Admin);
        _grantRole(MINTER_ROLE, safe1Minter);
        _grantRole(COMPLIANCE_ROLE, safe2Compliance);
        _grantRole(BURNER_ROLE, safe3Burner);
        _grantRole(TREASURY_ROLE, safe4Treasury);

        _mint(safe4Treasury, INITIAL_SUPPLY);
    }

    /**
     * @notice Mints only to an active holder of TREASURY_ROLE.
     * @dev No max-supply cap exists. A frozen treasury cannot receive minting.
     */
    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        require(hasRole(TREASURY_ROLE, to), "OneDust: recipient lacks treasury role");
        _mint(to, amount);
    }

    /** @notice Freezes an address and blocks its token operations. */
    function freeze(address account) external onlyRole(COMPLIANCE_ROLE) {
        require(account != address(0), "OneDust: zero address");
        require(!_frozen[account], "OneDust: already frozen");

        _frozen[account] = true;
        emit AddressFrozen(account, msg.sender);
    }

    /** @notice Removes the operational freeze from an address. */
    function unfreeze(address account) external onlyRole(COMPLIANCE_ROLE) {
        require(account != address(0), "OneDust: zero address");
        require(_frozen[account], "OneDust: not frozen");

        _frozen[account] = false;
        emit AddressUnfrozen(account, msg.sender);
    }

    function isFrozen(address account) external view returns (bool) {
        return _frozen[account];
    }

    /**
     * @notice Permanently burns tokens from an address that is frozen now.
     * @dev Does not require holder allowance or consent. Decreases totalSupply.
     */
    function burnFrozen(address account, uint256 amount)
        external
        onlyRole(BURNER_ROLE)
    {
        require(account != address(0), "OneDust: zero address");
        require(_frozen[account], "OneDust: account is not frozen");

        _burningFrozenFunds = true;
        _burn(account, amount);
        _burningFrozenFunds = false;

        emit FrozenFundsBurned(account, amount, msg.sender);
    }

    /**
     * @dev Blocks approval creation, modification, and allowance spending when
     * either the owner or spender is frozen. Checking spender also prevents a
     * previously approved frozen spender from calling transferFrom/burnFrom.
     */
    function _approve(
        address owner,
        address spender,
        uint256 value,
        bool emitEvent
    ) internal override {
        require(!_frozen[owner], "OneDust: owner is frozen");
        require(!_frozen[spender], "OneDust: spender is frozen");
        super._approve(owner, spender, value, emitEvent);
    }

    /**
     * @dev Blocks a frozen spender from using any existing allowance,
     * including an unlimited allowance that skips _approve().
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 value
    ) internal override {
        require(!_frozen[spender], "OneDust: spender is frozen");
        super._spendAllowance(owner, spender, value);
    }

    /**
     * @dev Enforces the freeze for transfers, minting, and ordinary burns.
     * The sole exception is the internal burn performed by burnFrozen().
     */
    function _update(address from, address to, uint256 value) internal override {
        bool authorizedFrozenBurn =
            _burningFrozenFunds && from != address(0) && to == address(0);

        if (from != address(0) && !authorizedFrozenBurn) {
            require(!_frozen[from], "OneDust: sender is frozen");
        }

        if (to != address(0)) {
            require(!_frozen[to], "OneDust: recipient is frozen");
        }

        super._update(from, to, value);
    }
}
