// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

enum Status {
    Undefined,
    Open,
    Break,
    Close
}

interface ICalculator {
    function myName() external view returns (string memory);

    function id() external view returns (uint256);

    function owner() external view returns (address);

    function setStatus() external;

    function status() external view returns (Status);
}
