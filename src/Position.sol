// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./BasketHandler.sol";
import "./PriceConverter.sol";
import "./Coin.sol";

/**
 * @dev Position contract manages a tokenized debt position.
 *
 * This contract provides the means for an account to manage their debt position
 * through enforcing adequate collatoralization while withdrawing debt tokens.
 */
contract Position is Ownable {
    using BasketLib for Basket;
    using PriceConverter for Basket;
    // uint256 public immutable minRatio;
    // PriceFeed private immutable priceFeed;
    Coin private immutable coin;
    uint256 public debt;
    bool isInsolvent;
    Basket collateral;
    uint256 public constant RATIO = 150;
    uint256 public constant COLLATERAL_DECIMAL = 1e18;

    constructor(
        IERC20[] memory tokens,
        uint256[] memory weights,
        AggregatorV3Interface[] memory priceFeeds,
        address _coinAddress,
        address _owner
    ) {
        uint256 length = tokens.length;
        console.log(length);
        for (uint256 i = 0; i < length; ++i) {
            collateral.add(tokens[i], weights[i], priceFeeds[i]);
        }
        coin = Coin(_coinAddress);
        transferOwnership(_owner);
        debt = 0;
        isInsolvent = false;
    }

    /**
     *
     * @dev calculate the total collateral amount in USD needed to hedge against
     *      the total exposure
     */
    function calculateCollateralTotalAmount(
        uint256 _stablecoinAmount
    ) public pure returns (uint256) {
        return (_stablecoinAmount * RATIO) / 100;
    }

    // function calculateCollateralTotalAmount(
    //     uint256 _stablecoinAmount
    // ) public view returns (uint256) {
    //     return
    //         (collateral.getConversionRateOfBasket(_stablecoinAmount) * RATIO) /
    //         100;
    // }

    function TotalBalanceInUsd() public view returns (uint256) {
        return collateral.Balance(address(this));
    }

    /**
     * @dev Returns true if the contract's debt position can increase by a specified amount.
     */
    function canTake(uint256 _moreDebt) public view returns (bool) {
        require(_moreDebt > 0, "Cannot take 0");
        uint256 totalCollateralInUSD = TotalBalanceInUsd();
        console.log(totalCollateralInUSD);
        uint256 debtInCoins = debt + _moreDebt;
        return ((totalCollateralInUSD * 100) / debtInCoins) >= RATIO;
    }

    /**
     * @dev Takes out loan against collateral if the vault is solvent
     */
    function take(address _receiver, uint256 _moreDebt) public onlyOwner {
        require(canTake(_moreDebt), "Position cannot take debt");
        coin.mint(address(this), _receiver, _moreDebt);
        debt = debt + _moreDebt;
    }

    /**
     * @dev Liquidates vault if priceId points to a price record of insolvency.
     */
    function liquidate(uint256 priceId) public {
        uint256 totalCollateralInUSD = TotalBalanceInUsd();
        uint256 cRatio = (totalCollateralInUSD * 100) / debt;
        require(cRatio < RATIO, "Position is collatoralized");
        isInsolvent = true;
        // Transfer collateral to liquidator or perform necessary actions
        collateral.Transfer(msg.sender, address(this));

        //        (timestamp, price) = priceFeed.getPrice(priceId);
    }

    function RetrieveAll() public onlyOwner {
        require(coin.balanceOf(msg.sender) >= 0, "Balance is 0");
        uint256 _stablecoinAmount = coin.balanceOf(msg.sender);
        coin.burn(msg.sender, _stablecoinAmount);
        collateral.Transfer(msg.sender, address(this));
    }
}
