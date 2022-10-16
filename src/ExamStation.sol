// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./modules/libraries/EnumerableSetUint.sol";

interface ICalculator {}

interface ICar {}

interface IRobot {}

interface ITraffic {}

interface IBook {}

struct Student {
    string name;
    address wallet;
    uint256 id;
    uint256 testNumber;
    uint256 score;
}

contract ExamStation is Pausable, Ownable {
    using EnumerableSetUint for EnumerableSetUint.UintSet;

    EnumerableSetUint.UintSet internal _studentIds;

    mapping(address => bool) public isWalletUsed;
    mapping(address => uint256) public walletToId;
    mapping(uint256 => Student) public idToStudent;

    mapping(address => bool) public isContractUsed;

    uint256[] public numberOfTest = [0, 1, 2, 3, 4, 0, 1, 2, 3, 4];

    mapping(uint256 => string) public instruction;

    constructor() {
        pause();
    }

    function register(string memory _name, uint256 _id) public whenNotPaused {
        require(isWalletUsed[msg.sender] == false, "This wallet already used");
        require(_studentIds.contains(_id) == false, "This id already used");

        walletToId[msg.sender] = _id;
        idToStudent[_id] = Student(
            _name,
            msg.sender,
            _id,
            numberOfTest[_random()],
            0
        );

        isWalletUsed[msg.sender] = true;
        _studentIds.add(_id);
    }

    function submit(address _contract) public onlyTester whenNotPaused {
        require(
            isContractUsed[_contract] == false,
            "This contract already used."
        );
        isContractUsed[_contract] = true;

        uint256 _id = walletToId[msg.sender];
        Student storage _student = idToStudent[_id];
        uint256 _score = _calScore(_student.testNumber);
        _student.score = _score;
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

    function getInstruction()
        public
        view
        whenNotPaused
        returns (string memory)
    {
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

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
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

    function getIdsCount() external view returns (uint256) {
        return _studentIds.length();
    }

    function getAllIds() external view returns (uint256[] memory) {
        return _studentIds.getAll();
    }

    function getIdsByPage(uint256 _page, uint256 _limit)
        external
        view
        returns (uint256[] memory)
    {
        return _studentIds.get(_page, _limit);
    }

    function getExamResult() external view returns (Student[] memory) {
        uint256[] memory ids = _studentIds.getAll();
        Student[] memory res = new Student[](ids.length);
        for (uint256 i; i < ids.length; i++) {
            res[i] = idToStudent[ids[i]];
        }
        return res;
    }
}
