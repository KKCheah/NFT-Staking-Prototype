# NFT-Staking-Prototype
Staking mechanism for NFT (ERC-721) that allows stakers to earn reward tokens (ERC-20)


The goal of the staking mechanism is to allow holders of specific NFT to earn interest while staking their NFT. I will be using the ERC721 as the standard for the NFT while ERC-20 as the standard of the tokens that are rewarded to stakers after a specific timeframe of staking has been completed.

In order for NFT staking to be realized, we would require a smart contract that can hold the user’s NFT and track the duration that the NFT has been staked. Once the duration has been met, a separate smart contract containing the ERC-20 reward tokens will be claimable to the staker.

##Flow:
NFT is staked to a smart contract that is known as StakeNFT(in stake6.sol) that can hold,track and transfer ERC-721 tokens and will only accept NFT that has a specific smart contract address (hardcoded). StakeNFT will allow users to stake, check their stake status, claim the reward tokens when staking period is over and also cancel their stake. When NFT staked has completed their staking duration, claiming the reward tokens will instruct a separate smart contract known as TokenPool(in pool.sol) to distribute a set amount of reward token to the staker. Users can then take back their NFT, claim their rewards and start another session of staking if they wish to.

## How to use
1) Deploy the ERC-20 and ERC-721 token 1st
2) Hardcode the ERC-721 address to the StakeNFT contract
3) Hardcode the StakeNFT contract address and the ERC-20 token address to the TokenPool contract
4) Fiddle around

###### Important: approve(to, tokenId) has to be called by user with "to" being the StakeNFT address before calling the callStakeToken as the StakeNFT contract will need approval to call the transferFrom() function




## Features that can be added:
1) Allow NFT's of the same standard but different contract address to stake for different pool of rewards
2) Change duration of staking, which will change the amount of rewards
