pragma solidity ^0.8.0;

contract CalculatorFactory3 {
    string public name = "Nuttakit Kundum";
    uint256 public id = 6130159921;

    address public owner;

    struct Calculator {
        string color;
        uint256 price;
    }

    enum Status {
        undefined,
        open,
        lunch,
        close
    }

    Status public status;

    Calculator[] public calculators;

    constructor() {
        owner = msg.sender;
    }

    function createCalculator(string memory _color, uint256 _price) public {
        calculators.push(Calculator(_color, _price));
    }

    function calculate(
        string memory _operator,
        uint256 _x,
        uint256 _y
    ) public view returns (uint256) {
        if (_compareStrings(_operator, "plus")) {
            return _x + _y;
        }
        if (_compareStrings(_operator, "divide")) {
            return _x / _y;
        }
        if (_compareStrings(_operator, "modulo")) {
            return _x % _y;
        }
    }

    function loop(uint256[] memory listOfNum) public view returns (uint256) {
        uint256 total = 0;
        for (uint256 i; i < listOfNum.length; i++) {
            total += listOfNum[i];
        }
        return total;
    }

    function deleteCalculator(uint256 _index) public onlyOwner {
        delete calculators[_index];
    }

    function setStatus() public {
        status = Status.lunch;
    }

    function getStatus() public view returns (Status) {
        return status;
    }

    function _compareStrings(string memory a, string memory b)
        internal
        view
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not owner.");
        _;
    }
}
