// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import ".deps/npm/@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface TokenPool {
        function distributePool(address) external;
    }

contract StakeNFT {

    //State variabble
    TokenPool poolAddress;
    uint private _stakingId = 0;

    //constructor
    constructor(){

    }

    //enumerator
    enum StakingStatus {Active, Claimable, Claimed, Cancelled}

    //structs
    struct Staking {
        address staker;    
        address token;
        uint tokenId;
        uint releaseTime;
        StakingStatus status;
        uint StakingId;
    }

    //mapping
    mapping(uint => Staking) private _StakedItem; 


    //event
    event tokenStaked(address indexed staker, address indexed token, uint token_id, StakingStatus status, uint StakingId);
    event tokenClaimStatus(address indexed token, uint indexed token_id, StakingStatus indexed status, uint StakingId);
    event tokenClaimComplete(address indexed token, uint indexed token_id, StakingStatus indexed status, uint StakingId);
    event tokenCancelComplete(address indexed token, uint indexed token_id, StakingStatus indexed status, uint StakingId);

    //function to call another function
    function callStakeToken(address token, uint _tokenID) public {
        require(token == 0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005, "incorrect NFT to stake"); // hardcode the NFT smart contract to allow only specific NFT into staking, assume 0xd2...d005 as NFT contract address
        stakeToken(token, _tokenID);
    }

    //function to transfer NFT from user to contract
    function stakeToken(address token, uint tokenId)private returns(Staking memory) {
        IERC721(token).transferFrom(msg.sender,address(this),tokenId); // User must approve() this contract address via the NFT ERC721 contract before NFT can be transfered
        uint256 numberOfMinutes = 5; //hardcoded as 5 minutes
        uint releaseTime = block.timestamp + (numberOfMinutes * 1 minutes);
        
        uint currentStakingId = _stakingId;

        Staking memory staking = Staking(msg.sender,token, tokenId, releaseTime, StakingStatus.Active, currentStakingId);
        

        _StakedItem[_stakingId] = staking;
        _stakingId++;

        emit tokenStaked(msg.sender, staking.token, staking.tokenId, staking.status, currentStakingId);
        
        return _StakedItem[currentStakingId];
    }

    //function to view staked NFT
    function viewStake(uint stakingId)public view returns (Staking memory) {
        return _StakedItem[stakingId];
    }

    //function to check NFT stake duration status 
    function checkStake(uint stakingId, address staker)public returns (Staking memory) {
        Staking storage staking = _StakedItem[stakingId];
        
        require(staker == msg.sender,"You cannot check this staking as it is not listed under this address");
        require(staking.status == StakingStatus.Active,"Staking is not active or claimed");
        if (block.timestamp >= staking.releaseTime) {
            staking.status = StakingStatus.Claimable;
        }

        emit tokenClaimStatus(staking.token, staking.tokenId, staking.status, staking.StakingId);
        return _StakedItem[stakingId];

 
    }

    //function to claim reward token if NFT stake duration is completed
    function claimStake(uint stakingId, address _TokenPoolAddr) public returns(Staking memory){
        Staking storage staking = _StakedItem[stakingId];

        poolAddress = TokenPool(_TokenPoolAddr);
        
        require(staking.staker == msg.sender,"You cannot cancel this staking as it is not listed under this address");
        require(staking.status == StakingStatus.Claimable,"Your reward is either not claimable yet or has been claimed");

        poolAddress.distributePool(staking.staker);

        staking.status = StakingStatus.Claimed;
        IERC721(staking.token).transferFrom(address(this), msg.sender, staking.tokenId);

        emit tokenClaimComplete(staking.token, staking.tokenId, staking.status, staking.StakingId);
        
        return _StakedItem[stakingId];
    }
    

    //function to cancel NFT stake
    function cancelStake(uint stakingId) public returns (Staking memory) {
        Staking storage staking = _StakedItem[stakingId];
        require(staking.staker == msg.sender,"You cannot cancel this staking as it is not listed under this address");
        require(staking.status == StakingStatus.Active,"Staking is either not active (Cancalled or in claiming process)");
        
        staking.status = StakingStatus.Cancelled;
        IERC721(staking.token).transferFrom(address(this), msg.sender, staking.tokenId);


        emit tokenCancelComplete(staking.token, staking.tokenId, staking.status, staking.StakingId);
        return _StakedItem[stakingId];
    }


}