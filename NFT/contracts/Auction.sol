pragma solidity ^0.8.9;

contract Auction {
    address payable public beneficiary; // 卖家地址  
    uint public auctionEnd; // 拍卖结束时间 
    address public highestBidder; // 当前出最高价的人的地址  
    uint public highestBid; // 当前最高价 
    mapping(address => uint) pendingReturns;
    bool ended;

    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    /// 以受益者地址 `_beneficiary` 的名义，
    /// 创建一个简单的拍卖，拍卖时间为秒。
    constructor(
        uint _biddingTime,
        uint _startingPrice,
        address payable _beneficiary
    ) public {
        beneficiary = _beneficiary;
        highestBid = _startingPrice;
        auctionEnd = block.timestamp + _biddingTime;
    }

    /// 对拍卖进行出价。
    /// 如果没有在拍卖中胜出，则返还出价。
    function bid() public payable {
      
        require(
            block.timestamp <= auctionEnd,
            "Auction already ended."
        );

        require(
            msg.value > highestBid,
            "There already is a higher bid."
        );

        if (highestBid != 0 ) {
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    /// 取回出价（当该出价已被超越）
    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            // send执行失败会返回false
            if (!payable(msg.sender).send(amount)) {
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }
 
    /// 结束拍卖，并把最高的出价发送给受益人
    function aucEnd() public {
        require(block.timestamp >= auctionEnd, "Auction not yet ended.");
        require(!ended, "auctionEnd has already been called.");
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);
        beneficiary.transfer(highestBid);
    }
}