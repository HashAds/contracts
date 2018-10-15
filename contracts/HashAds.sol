pragma solidity ^0.4.24;


library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}


/**
 * @title Ad platform to directly pay out website hosts and ad viewers
 * @notice One contract will be deployed per website
 */
contract HashAds {
  using SafeMath for uint256;

  string public  adId;
  uint256 public websiteOwnerPercentage = 70;
  uint256 public viewerPercentage = 30;
  uint256 public payoutPerViewOwner;
  uint256 public payoutPerViewViewer;
  address public websiteOwner;


  /**
   * @dev Start an add program and define the number of viewers of the ad
   * @param _numViewers Number of viewers of the ad
   * @param _adId Name of the add
   */
  function startAddProgram(uint256 _numViewers, string _adId)
    public
    payable
  {
    require(_numViewers > 0);
    require(msg.value > 0);

    payoutPerViewViewer = msg.value.mul(viewerPercentage).div(100).div(_numViewers);
    payoutPerViewOwner = msg.value.mul(websiteOwnerPercentage).div(100).div(_numViewers);

    adId = _adId;
  }

  /**
   * Payout function for viewing ads
   */
  function viewAd()
    public
  {
    msg.sender.transfer(payoutPerViewViewer);
    websiteOwner.transfer(payoutPerViewOwner);
  }
}
