// SPDX-License-Identifier: MIT

pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract DoNotBuyToken is Context, AccessControlEnumerable, ERC20Burnable, ERC20Pausable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
		bytes32 public constant CAP_UPDATER_ROLE = keccak256(("CAP_UPDATER_ROLE"));

		uint256 private tokenCap;

    /**
     * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE`, `CAP_UPDATER_ROLE` and `PAUSER_ROLE` to the
     * account that deploys the contract.
     */
    constructor(uint256 _cap)
			ERC20("Do Not Buy", "DNB") {
				require(_cap > 0, "ERC20Capped: cap is 0");
        tokenCap = _cap;

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());
				_setupRole(CAP_UPDATER_ROLE, _msgSender());
    }

    /**
     * @dev Creates `amount` new tokens for `to`.
     *
     * Requirements:
     *
     * - the caller must have the `MINTER_ROLE`.
		 * - the total supply after adding the mint amount should not exceed the `tokenCap`
     */
    function mint(address to, uint256 amount) public {
        require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
				require(totalSupply() + amount <= tokenCap, "ERC20Capped: cap exceeded");

        _mint(to, amount);
    }

    /**
     * @dev Pauses all token transfers.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function pause() public {
        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");

        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function unpause() public {
        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");

        _unpause();
    }

		/**
     * @dev Returns the current cap of the token.
     *
     */
		function cap() public view returns (uint256) {
        return tokenCap;
    }

		/**
     * @dev Updates the cap to the given `_cap` amount
     *
     * Requirements:
     *
     * - the caller must have the `CAP_UPDATER_ROLE`.
     */
		function updateCap(uint256 _cap) public {
			require(hasRole(CAP_UPDATER_ROLE, _msgSender()), "Must have cap updater role to update the cap.");
			require(_cap > totalSupply(), "New token cap must be greater than the current total supply.");

			tokenCap = _cap;
		}

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }
}
