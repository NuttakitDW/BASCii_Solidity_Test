// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

library EnumerableSetUint {
    struct UintSet {
        uint256[] _values;
        mapping(uint256 => uint256) _indexes;
    }

    function add(UintSet storage set, uint256 value) internal returns (bool) {
        if (!contains(set, value)) {
            set._values.push(value);
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    function remove(UintSet storage set, uint256 value)
        internal
        returns (bool)
    {
        uint256 valueIndex = set._indexes[value];
        if (valueIndex != 0) {
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;
            uint256 lastvalue = set._values[lastIndex];
            set._values[toDeleteIndex] = lastvalue;
            set._indexes[lastvalue] = toDeleteIndex + 1;
            set._values.pop();
            delete set._indexes[value];
            return true;
        } else {
            return false;
        }
    }

    function contains(UintSet storage set, uint256 value)
        internal
        view
        returns (bool)
    {
        return set._indexes[value] != 0;
    }

    function length(UintSet storage set) internal view returns (uint256) {
        return set._values.length;
    }

    function at(UintSet storage set, uint256 index)
        internal
        view
        returns (uint256)
    {
        require(
            set._values.length > index,
            "EnumerableSet: index out of bounds"
        );
        return set._values[index];
    }

    function getAll(UintSet storage set)
        internal
        view
        returns (uint256[] memory)
    {
        return set._values;
    }

    function get(
        UintSet storage set,
        uint256 _page,
        uint256 _limit
    ) internal view returns (uint256[] memory) {
        require(_page > 0 && _limit > 0);
        uint256 tempLength = _limit;
        uint256 cursor = (_page - 1) * _limit;
        uint256 _uintLength = length(set);
        if (cursor >= _uintLength) {
            return new uint256[](0);
        }
        if (tempLength > _uintLength - cursor) {
            tempLength = _uintLength - cursor;
        }
        uint256[] memory uintList = new uint256[](tempLength);
        for (uint256 i = 0; i < tempLength; i++) {
            uintList[i] = at(set, cursor + i);
        }
        return uintList;
    }
}

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

contract ExamStation is IExamStation, Pausable, Ownable {
    using Address for address;
    using EnumerableSetUint for EnumerableSetUint.UintSet;

    EnumerableSetUint.UintSet internal _studentIds;

    mapping(address => bool) public isWalletUsed;
    mapping(address => uint256) public walletToId;
    mapping(uint256 => Student) public idToStudent;
    mapping(uint256 => Answer) public idToAns;
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
        uint256 _score = _calScore(_id, _contract);
        _student.score = _score;
    }

    function _calScore(uint256 _id, address _contract)
        internal
        returns (uint256)
    {
        uint256 totalScore;

        Answer storage ans = idToAns[_id];

        if (_check1(_contract)) {
            totalScore += 1;
            ans.ans1 = true;
        } else {
            ans.ans1 = false;
        }

        if (_check2(_contract)) {
            totalScore += 1;
            ans.ans2 = true;
        } else {
            ans.ans2 = false;
        }

        if (_check3(_contract)) {
            totalScore += 1;
            ans.ans3 = true;
        } else {
            ans.ans3 = false;
        }

        if (_check4(_contract)) {
            totalScore += 1;
            ans.ans4 = true;
        } else {
            ans.ans4 = false;
        }

        if (_check5(_contract)) {
            totalScore += 1;
            ans.ans5 = true;
        } else {
            ans.ans5 = false;
        }

        if (_check6(_contract)) {
            totalScore += 1;
            ans.ans6 = true;
        } else {
            ans.ans6 = false;
        }

        if (_check7(_contract)) {
            totalScore += 1;
            ans.ans7 = true;
        } else {
            ans.ans7 = false;
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

    // Task 4: Declare Array.
    // Task 5: Create function and use Struct.
    function _check3(address _contract) internal returns (bool) {
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

    // Task 6: Read-only function, Operator and if-else.
    function _check4(address _contract) internal view returns (bool) {
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

    // Task 8: Constructor, Modifier & Require.
    function _check6(address _contract) internal returns (bool) {
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

    // Task 9: Declare simple variables.
    function _check7(address _contract) internal returns (bool) {
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

    function checkScore(uint256 _id) public view override returns (uint256) {
        return idToStudent[_id].score;
    }

    function checkAns(uint256 _id)
        public
        view
        override
        returns (Answer memory)
    {
        return idToAns[_id];
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

    function unpause() public override onlyOwner {
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
