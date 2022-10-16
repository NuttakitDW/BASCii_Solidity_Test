// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

enum Status {
    undefined,
    open,
    lunch,
    close
}

struct Calculator {
    string model;
    uint256 price;
}

interface ICalculator {
    function name() external view returns (string memory);

    function id() external view returns (uint256);

    function owner() external view returns (address);

    function setStatus() external;

    function getStatus() external view returns (Status);

    function calculate(
        string memory _operator,
        uint256 _x,
        uint256 _y
    ) external view returns (uint256);

    function loop(uint256[] memory listOfNum) external view returns (uint256);

    function createCalculator(string memory, uint256) external;

    function deleteCalculator(uint256 _index) external;

    function calculators(uint256 _index)
        external
        view
        returns (string memory, uint256);
}
