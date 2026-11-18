// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Minimal interface of the Agent ID contract (SPACE ID, ERC-721).
/// Only balanceOf is needed: a non-zero balance proves the caller holds an Agent ID.
interface IERC721 {
    function balanceOf(address owner) external view returns (uint256);
}

/// @title AgentStreak
/// @notice Daily check-in streaks for Agent ID holders on BNB Chain.
/// @dev No owner, no admin, no fees, no payments, no pause, no upgrade.
///      One check-in per UTC day. Consecutive days grow the streak; a missed
///      day resets it to 1. Agent ID is the SPACE ID ERC-721 (non-transferable)
///      issued by the Binance Agentic Wallet; holding one is the only gate.
contract AgentStreak {
    /// @notice Agent ID contract (SPACE ID, ERC-721, non-transferable).
    /// Address is the checksummed form of 0x60b9262456de011f7d15a54cdd8c48baaa8b022f.
    IERC721 public constant AGENT_ID =
        IERC721(0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F);

    /// @notice UTC day number (block.timestamp / 1 days) of the user's last check-in.
    mapping(address => uint256) public lastCheckInDay;

    /// @notice Current consecutive-day streak of the user.
    mapping(address => uint256) public streak;

    /// @notice Total check-ins of the user.
    mapping(address => uint256) public userCheckIns;

    /// @notice Total check-ins of all users combined.
    uint256 public totalCheckIns;

    /// @notice Emitted on every successful check-in.
    event CheckIn(address indexed user, uint256 streak, uint256 day);

    /// @notice Check in for the current UTC day. Requires holding an Agent ID.
    function checkIn() external {
        require(AGENT_ID.balanceOf(msg.sender) > 0, "Agent ID required");

        uint256 day = block.timestamp / 1 days;
        require(lastCheckInDay[msg.sender] != day, "Already checked in today");

        if (day > 0 && lastCheckInDay[msg.sender] == day - 1) {
            streak[msg.sender] += 1;
        } else {
            streak[msg.sender] = 1;
        }

        lastCheckInDay[msg.sender] = day;
        userCheckIns[msg.sender] += 1;
        totalCheckIns += 1;

        emit CheckIn(msg.sender, streak[msg.sender], day);
    }

    /// @notice Current streak of a user.
    function getStreak(address user) external view returns (uint256) {
        return streak[user];
    }

    /// @notice UTC day number of a user's last check-in (0 = never).
    function getLastCheckInDay(address user) external view returns (uint256) {
        return lastCheckInDay[user];
    }

    /// @notice Total check-ins of a user.
    function getTotalCheckIns(address user) external view returns (uint256) {
        return userCheckIns[user];
    }
}
