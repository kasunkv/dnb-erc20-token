// SPDX-License-Identifier: MIT

pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DoNotBuyToken is ERC20 {

	constructor()
		ERC20("Do Not Buy", "DNB") {
			_mint(msg.sender, 10000);
	}
}