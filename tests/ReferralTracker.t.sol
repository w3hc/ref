// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.29 <0.9.0;

import { Test } from "forge-std/src/Test.sol";
import { ReferralTracker } from "../src/ReferralTracker.sol";

contract ReferralTrackerTest is Test {
    // Contract instance to test
    ReferralTracker internal referralTracker;

    // Test addresses
    address internal referrer = address(0x1);
    address internal referee1 = address(0x2);
    address internal referee2 = address(0x3);
    address internal referee3 = address(0x4);

    function setUp() public {
        // Deploy a new ReferralTracker contract before each test
        referralTracker = new ReferralTracker();
    }

    /// @notice Test basic registration functionality
    function testRegister() public {
        // Register referee1 with referrer
        referralTracker.register(referrer, referee1);

        // Assert the referral was recorded correctly
        assertEq(referralTracker.referredBy(referee1), referrer);
        assertEq(referralTracker.referralCount(referrer), 1);
        assertEq(referralTracker.getTotalUsers(), 1);

        // Register another referee with the same referrer
        referralTracker.register(referrer, referee2);
        assertEq(referralTracker.referredBy(referee2), referrer);
        assertEq(referralTracker.referralCount(referrer), 2);
        assertEq(referralTracker.getTotalUsers(), 2);
    }

    /// @notice Test that the register function emits the proper event
    function testRegisterEvent() public {
        // Expect the Registered event with correct parameters
        vm.expectEmit(true, true, false, true);
        emit Registered(referee1, referrer);

        // Perform the registration
        referralTracker.register(referrer, referee1);
    }

    /// @notice Test the revert when trying to register a user who is already registered
    function testCannotRegisterTwice() public {
        // Register referee1
        referralTracker.register(referrer, referee1);

        // Try to register the same referee again, expect revert
        vm.expectRevert(ReferralTracker.UserAlreadySignedUp.selector);
        referralTracker.register(referrer, referee1);
    }

    /// @notice Test the revert when using the zero address as referrer
    function testCannotUseZeroAddressAsReferrer() public {
        // Try to use address(0) as referrer, expect revert
        vm.expectRevert(ReferralTracker.InvalidReferrerAddress.selector);
        referralTracker.register(address(0), referee1);
    }

    /// @notice Test the revert when a user tries to refer themselves
    function testCannotReferSelf() public {
        // Try to refer self, expect revert
        vm.expectRevert(ReferralTracker.CannotReferSelf.selector);
        referralTracker.register(referee1, referee1);
    }

    /// @notice Test getting the total number of users
    function testGetTotalUsers() public {
        // Initially there should be 0 users
        assertEq(referralTracker.getTotalUsers(), 0);

        // Register multiple users
        referralTracker.register(referrer, referee1);
        assertEq(referralTracker.getTotalUsers(), 1);

        referralTracker.register(referrer, referee2);
        assertEq(referralTracker.getTotalUsers(), 2);

        referralTracker.register(referee1, referee3); // referee1 is now also a referrer
        assertEq(referralTracker.getTotalUsers(), 3);
    }

    /// @notice Test getting all referrals for a specific referrer
    function testGetReferrals() public {
        // Register multiple referees with the same referrer
        referralTracker.register(referrer, referee1);
        referralTracker.register(referrer, referee2);

        // Get all referrals for the referrer
        address[] memory referrals = referralTracker.getReferrals(referrer);

        // Assert correct length and contents
        assertEq(referrals.length, 2);
        assertEq(referrals[0], referee1);
        assertEq(referrals[1], referee2);

        // Register a different referral relationship
        referralTracker.register(referee1, referee3); // referee1 refers referee3

        // Check referrer's referrals again (should be unchanged)
        referrals = referralTracker.getReferrals(referrer);
        assertEq(referrals.length, 2);

        // Check referee1's referrals
        address[] memory referee1Referrals = referralTracker.getReferrals(referee1);
        assertEq(referee1Referrals.length, 1);
        assertEq(referee1Referrals[0], referee3);
    }

    /// @notice Test referring in a chain (A refers B, B refers C)
    function testReferralChain() public {
        // Create a referral chain
        referralTracker.register(referrer, referee1);     // referrer refers referee1
        referralTracker.register(referee1, referee2);     // referee1 refers referee2
        referralTracker.register(referee2, referee3);     // referee2 refers referee3

        // Check the chain
        assertEq(referralTracker.referredBy(referee1), referrer);
        assertEq(referralTracker.referredBy(referee2), referee1);
        assertEq(referralTracker.referredBy(referee3), referee2);

        // Check counts
        assertEq(referralTracker.referralCount(referrer), 1);
        assertEq(referralTracker.referralCount(referee1), 1);
        assertEq(referralTracker.referralCount(referee2), 1);
        assertEq(referralTracker.referralCount(referee3), 0);

        // Check total users
        assertEq(referralTracker.getTotalUsers(), 3);
    }

    /// @notice Helper for event testing
    event Registered(address indexed referee, address indexed referrer);
}
