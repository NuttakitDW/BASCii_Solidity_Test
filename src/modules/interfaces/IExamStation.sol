// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

struct Student {
    string name;
    address wallet;
    uint256 id;
    uint256 testNumber;
    uint256 score;
}

struct Answer {
    bool ans1;
    bool ans2;
    bool ans3;
    bool ans4;
    bool ans5;
    bool ans6;
    bool ans7;
}

interface IExamStation {
    function register(string memory _name, uint256 _id) external;

    function submit(address _contract) external;

    function checkScore(uint256 _id) external view returns (uint256);

    function getInstruction() external view returns (string memory);

    function unpause() external;

    function checkAns(uint256 _id) external view returns (Answer memory);
}
