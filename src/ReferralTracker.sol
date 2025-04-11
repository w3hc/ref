// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

/// @title ReferralTracker
/// @author Anonymous
/// @notice Tracks referral relationships between addresses
/// @dev A simple contract that records which address referred another address
contract ReferralTracker {
    /// @notice Custom errors for better gas efficiency and clarity
    error InvalidReferrerAddress();
    error CannotReferSelf();
    error UserAlreadySignedUp();

    /// @notice Maps a referee address to their referrer address
    /// @dev referee address => referrer address
    mapping(address referee => address referrer) public referredBy;

    /// @notice Counts how many referrals each address has made
    /// @dev referrer address => count of referees
    mapping(address referrer => uint256 count) public referralCount;

    /// @notice List of all addresses that have been signed up
    address[] public allUsers;

    /// @notice Emitted when a new referee is registered with their referrer
    /// @param referee The address that was referred (signed up)
    /// @param referrer The address that made the referral
    event Registered(address indexed referee, address indexed referrer);

    /// @notice Registers a new referee as being referred by a referrer
    /// @dev Anyone can call this function to register any referral relationship
    /// @param referrer The address that is referring the new user
    /// @param referee The address that is being referred
    function register(address referrer, address referee) public {
        if (referrer == address(0)) revert InvalidReferrerAddress();
        if (referrer == referee) revert CannotReferSelf();
        if (referredBy[referee] != address(0)) revert UserAlreadySignedUp();

        referredBy[referee] = referrer;
        allUsers.push(referee);
        referralCount[referrer]++;

        emit Registered(referee, referrer);
    }

    /// @notice Gets the total number of users signed up
    /// @return The number of addresses in the allUsers array
    function getTotalUsers() external view returns (uint256) {
        return allUsers.length;
    }

    /// @notice Gets all addresses that were referred by a specific referrer
    /// @param referrer The address to get referrals for
    /// @return Array of addresses that were referred by the given referrer
    function getReferrals(address referrer) external view returns (address[] memory) {
        uint256 count = referralCount[referrer];
        address[] memory referrals = new address[](count);

        // Fill the array with referrals
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < allUsers.length && currentIndex < count; i++) {
            if (referredBy[allUsers[i]] == referrer) {
                referrals[currentIndex] = allUsers[i];
                currentIndex++;
            }
        }

        return referrals;
    }
}
