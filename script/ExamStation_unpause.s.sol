// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/ExamStation.sol";

contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        address exam = 0x137f212bc646446c1CDbBB0a5c712F51D9A5B8C5;

        ExamStation examStation = ExamStation(exam);
        vm.startBroadcast(deployerPrivateKey);

        examStation.unpause();

        vm.stopBroadcast();
    }
}
