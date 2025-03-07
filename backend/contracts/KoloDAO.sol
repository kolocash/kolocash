// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

/**
 * @title KoloDAO - Kolocash DAO Governance Contract (Minimal Version)
 * @notice A minimal governance contract using a fixed quorum.
 */

import {Governor} from "@openzeppelin/contracts/governance/Governor.sol";
import {GovernorCountingSimple} from "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import {GovernorSettings} from "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import {GovernorVotes} from "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import {IVotes} from "@openzeppelin/contracts/governance/utils/IVotes.sol";

contract KoloDAO is
    Governor,
    GovernorSettings,
    GovernorCountingSimple,
    GovernorVotes
{
    // Fixed quorum value (4% of total supply)
    uint256 private constant FIXED_QUORUM = 4e27;

    constructor(
        IVotes _token
    )
        Governor("KoloDAO")
        GovernorSettings(1 days, 1 weeks, 0)
        GovernorVotes(_token)
    {}

    // Les fonctions suivantes sont requises pour résoudre les conflits d'héritage

    function votingDelay()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.votingDelay();
    }

    function votingPeriod()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.votingPeriod();
    }

    function proposalThreshold()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.proposalThreshold();
    }

    /**
     * @notice Returns a fixed quorum value.
     * @dev Instead of a dynamic quorum, we simply return a constant.
     */
    function quorum(
        uint256 /* blockNumber */
    ) public pure override returns (uint256) {
        return FIXED_QUORUM;
    }
}
