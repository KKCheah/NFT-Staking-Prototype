// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface ERC20 {

  function transfer(address to, uint value) external returns (bool);

}

contract TokenPool {

    address _stakeAddress = 0x358AA13c52544ECCEF6B0ADD0f801012ADAD5eE3; //hardcoded
    
    function distributePool(address receiver) public {
        require(msg.sender == _stakeAddress, "incorrect stake address");
        ERC20(0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47).transfer(receiver, 1);
    }

}