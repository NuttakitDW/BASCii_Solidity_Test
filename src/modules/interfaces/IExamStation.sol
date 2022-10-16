// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

struct Student {
    string name;
    address wallet;
    uint256 id;
    uint256 testNumber;
    uint256 score;
}

interface IExamStation {
    function register(string memory _name, uint256 _id) external;

    function submit(address _contract) external;
}
