// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface ICalculator {}

interface ICar {}

interface IRobot {}

interface ITraffic {}

interface IBook {}

contract ExamStation is Ownable {
    struct Student {
        string name;
        address wallet;
        uint256 id;
        uint256 testNumber;
        uint256 score;
    }

    bool public isStart;

    mapping(address => bool) public isWalletUsed;
    mapping(uint256 => bool) public isIdUsed;

    mapping(address => uint256) public walletToId;
    mapping(uint256 => Student) public idToStudent;

    mapping(address => bool) public isContractUsed;

    uint256[] public numberOfTest = [0, 1, 2, 3, 4, 0, 1, 2, 3, 4];

    mapping(uint256 => string) public instruction;

    constructor() {
        pause();
    }

    function register(string memory _name, uint256 _id) public {
        require(isWalletUsed[msg.sender] == false, "This wallet already used");
        require(isIdUsed[_id] == false, "This id already used");

        walletToId[msg.sender] = _id;
        idToStudent[_id] = Student(
            _name,
            msg.sender,
            _id,
            numberOfTest[_random()],
            0
        );

        isWalletUsed[msg.sender] = true;
        isIdUsed[_id] = true;
    }

    function submit(address _contract) public onlyTester {
        require(
            isContractUsed[_contract] == false,
            "This contract already used."
        );
        isContractUsed[_contract] = true;

        uint256 _id = walletToId[msg.sender];
        Student storage _student = idToStudent[_id];
    }

    function _calScore(uint256 _numTest) internal view returns (uint256) {
        if (_numTest == 0) {
            return _check0();
        }

        if (_numTest == 1) {
            return _check1();
        }

        if (_numTest == 2) {
            return _check2();
        }

        if (_numTest == 3) {
            return _check3();
        }

        if (_numTest == 4) {
            return _check4();
        }
    }

    function _check0() internal view returns (uint256) {
        uint256 score;
        return score;
    }

    function _check1() internal view returns (uint256) {
        uint256 score;
        return score;
    }

    function _check2() internal view returns (uint256) {
        uint256 score;
        return score;
    }

    function _check3() internal view returns (uint256) {
        uint256 score;
        return score;
    }

    function _check4() internal view returns (uint256) {
        uint256 score;
        return score;
    }

    function getInstruction() public view returns (string memory) {
        return instruction[_getNumTest()];
    }

    function _getNumTest() internal view returns (uint256) {
        uint256 _id = walletToId[msg.sender];
        Student memory _student = idToStudent[_id];
        uint256 _numberOfTest = _student.testNumber;
        return _numberOfTest;
    }

    function checkScore(uint256 _id) public view returns (uint256) {
        return idToStudent[_id].score;
    }

    function addTest(uint256 _no, string memory _url) public onlyOwner {
        instruction[_no] = _url;
    }

    function start() public onlyOwner {
        isStart = true;
    }

    function pause() public onlyOwner {
        isStart = false;
    }

    function _random() internal view returns (uint256) {
        uint256 number = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
            )
        ) % 10;
        return number;
    }

    modifier onlyTester() {
        require(isWalletUsed[msg.sender] == true, "Please register first.");
        _;
    }
}
