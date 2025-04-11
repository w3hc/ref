// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.29 <0.9.0;

import { ReferralTracker } from "../src/ReferralTracker.sol";
import { BaseScript } from "./Base.s.sol";
import { console2 } from "forge-std/src/console2.sol";

/// @notice Deployment script for ReferralTracker
contract Deploy is BaseScript {
    function run() public broadcast returns (ReferralTracker referralTracker) {
        // Deploy the ReferralTracker contract
        referralTracker = new ReferralTracker();

        // Log the address for easy reference
        console2.log("ReferralTracker deployed at:", address(referralTracker));
    }
}
