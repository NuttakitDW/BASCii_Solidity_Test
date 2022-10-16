// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./modules/libraries/EnumerableSetUint.sol";

import "./modules/interfaces/ICalculator.sol";
import "./modules/interfaces/IExamStation.sol";

contract ExamStation is IExamStation, Pausable, Ownable {
    using Address for address;
    using EnumerableSetUint for EnumerableSetUint.UintSet;

    EnumerableSetUint.UintSet internal _studentIds;

    mapping(address => bool) public isWalletUsed;
    mapping(address => uint256) public walletToId;
    mapping(uint256 => Student) public idToStudent;

    mapping(address => bool) public isContractUsed;

    mapping(uint256 => string) public instruction;

    modifier onlyTester() {
        require(isWalletUsed[msg.sender] == true, "Please register first.");
        _;
    }

    constructor() {
        pause();
    }

    //////////////////////// core ////////////////////////

    function register(string memory _name, uint256 _id)
        public
        override
        whenPaused
    {
        require(isWalletUsed[msg.sender] == false, "This wallet already used");
        require(_studentIds.contains(_id) == false, "This id already used");

        walletToId[msg.sender] = _id;
        idToStudent[_id] = Student(_name, msg.sender, _id, _random(), 0);

        isWalletUsed[msg.sender] = true;
        _studentIds.add(_id);
    }

    function submit(address _contract)
        public
        override
        onlyTester
        whenNotPaused
    {
        require(
            isContractUsed[_contract] == false,
            "This contract already used."
        );
        isContractUsed[_contract] = true;

        uint256 _id = walletToId[msg.sender];
        Student storage _student = idToStudent[_id];
        uint256 _score = _calScore(_contract);
        _student.score = _score;
    }

    function _calScore(address _contract) internal returns (uint256) {
        uint256 totalScore;

        if (_check1(_contract)) {
            totalScore += 1;
        }

        if (_check2(_contract)) {
            totalScore += 1;
        }

        if (_check3(_contract)) {
            totalScore += 1;
        }

        if (_check4(_contract)) {
            totalScore += 1;
        }

        if (_check5(_contract)) {
            totalScore += 1;
        }

        if (_check6(_contract)) {
            totalScore += 1;
        }

        if (_check7(_contract)) {
            totalScore += 1;
        }

        return totalScore;
    }

    // Task 1: Set up a contract.
    function _check1(address _contract) internal view returns (bool) {
        if (_contract.isContract()) {
            return true;
        }
        return false;
    }

    // Task 2: Declare simple variables.
    function _check2(address _contract) internal view returns (bool) {
        Student memory std = _getStudent();
        try ICalculator(_contract).owner() returns (address _owner) {
            if (std.wallet != _owner) {
                return false;
            }
        } catch {
            return false;
        }
        try ICalculator(_contract).id() returns (uint256 _id) {
            if (std.id != _id) {
                return false;
            }
        } catch {
            return false;
        }
        try ICalculator(_contract).name() returns (string memory _name) {
            if (keccak256(bytes(std.name)) != keccak256(bytes(_name))) {
                return false;
            }
        } catch {
            return false;
        }

        return true;
    }

    // Task 9: Declare simple variables.
    function _check3(address _contract) internal returns (bool) {
        uint256 testNum = _getNumTest();
        try ICalculator(_contract).setStatus() {} catch {
            return false;
        }

        try ICalculator(_contract).getStatus() returns (Status s) {
            if (testNum == 0 && s == Status.open) {
                return true;
            }

            if (testNum == 1 && s == Status.lunch) {
                return true;
            }

            if (testNum == 2 && s == Status.close) {
                return true;
            }
        } catch {
            return false;
        }
    }

    // Task 8: Constructor, Modifier & Require.
    function _check4(address _contract) internal returns (bool) {
        try ICalculator(_contract).deleteCalculator(0) {} catch Error(
            string memory reason
        ) {
            if (
                keccak256(bytes("You are not owner.")) !=
                keccak256(bytes(reason))
            ) {
                return true;
            }
        }

        return false;
    }

    // Task 7: For loop/While Loop
    function _check5(address _contract) internal view returns (bool) {
        uint256 testNum = _getNumTest();
        uint256[] memory listOfNum = new uint256[](3);

        listOfNum[0] = 2;
        listOfNum[1] = 3;
        listOfNum[2] = 4;

        try ICalculator(_contract).loop(listOfNum) returns (uint256 res) {
            if (testNum == 0 && res == 9) {
                return true;
            }

            if (testNum == 1 && res == 24) {
                return true;
            }

            if (testNum == 2 && res == 9) {
                return true;
            }
        } catch {
            return false;
        }

        return false;
    }

    // Task 6: Read-only function, Operator and if-else.
    function _check6(address _contract) internal view returns (bool) {
        uint256 testNum = _getNumTest();
        uint256 _a = 3;
        uint256 _b = 2;

        if (testNum == 0) {
            try ICalculator(_contract).calculate("plus", _a, _b) returns (
                uint256 res
            ) {
                if (res == 5) {
                    return true;
                }
                return false;
            } catch {
                return false;
            }
        }

        if (testNum == 1) {
            try
                ICalculator(_contract).calculate("exponential", _a, _b)
            returns (uint256 res) {
                if (res == 9) {
                    return true;
                }
                return false;
            } catch {
                return false;
            }
        }

        if (testNum == 2) {
            try ICalculator(_contract).calculate("minus", _a, _b) returns (
                uint256 res
            ) {
                if (res == 1) {
                    return true;
                }
                return false;
            } catch {
                return false;
            }
        }

        return false;
    }

    // Task 4: Declare Array.
    // Task 5: Create function and use Struct.
    function _check7(address _contract) internal returns (bool) {
        try ICalculator(_contract).createCalculator("test", 123) {} catch {
            return false;
        }

        try ICalculator(_contract).calculators(0) returns (
            string memory _a,
            uint256 _b
        ) {
            if (keccak256(bytes(_a)) != keccak256(bytes("test")) && 123 == _b) {
                return true;
            }
        } catch {
            return false;
        }

        return false;
    }

    function checkScore(uint256 _id) public view override returns (uint256) {
        return idToStudent[_id].score;
    }

    function getInstruction()
        public
        view
        override
        whenNotPaused
        returns (string memory)
    {
        return instruction[_getNumTest()];
    }

    function _getNumTest() internal view returns (uint256) {
        uint256 _id = walletToId[msg.sender];
        Student memory _student = idToStudent[_id];
        return _student.testNumber;
    }

    function _getStudent() internal view returns (Student memory) {
        uint256 _id = walletToId[msg.sender];
        Student memory _student = idToStudent[_id];
        return _student;
    }

    //////////////////////// owner setter ////////////////////////

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function addTest(uint256 _no, string memory _url) public onlyOwner {
        instruction[_no] = _url;
    }

    //////////////////////// getter ////////////////////////

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

    //////////////////////// uitls ////////////////////////

    function _random() internal view returns (uint256) {
        uint256 number = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
            )
        ) % 3;
        return number;
    }
}
