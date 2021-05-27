pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

contract PupperCoinSale is Crowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale, MintedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        uint rate,
        PupperCoin token,
        address payable wallet,
        uint256 goal,             // total cap, in wei
        uint256 openingTime,     // opening time in unix epoch seconds
        uint256 closingTime    // closing time in unix epoch seconds
    )
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        MintedCrowdsale()
        CappedCrowdsale(goal)
        RefundableCrowdsale(goal)
        TimedCrowdsale(now, now + 24 weeks)
        Crowdsale(rate, wallet, token)
        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet,
        uint goal
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        
        // create the ArcadeTokenSale and tell it about the token
        PupperCoinSale token_sale = new PupperCoinSale(1, token, wallet, goal, now, now + 5 minutes);
        token_sale_address = address(token_sale);
        
        
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();

    }
}
