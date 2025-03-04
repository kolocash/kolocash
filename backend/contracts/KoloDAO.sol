// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

/**
 * @title KoloDAO - Upgradeable DAO with Quadratic Voting & Timelock
 * @notice A governor contract using OpenZeppelin upgradeable libraries.
 * @dev This contract uses a quadratic voting mechanism (via square root of raw votes)
 *      and relies on OpenZeppelin's Governor, Timelock, and related modules.
 */

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/governance/GovernorUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorSettingsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorCountingSimpleUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorVotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorVotesQuorumFractionUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorTimelockControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/TimelockControllerUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/governance/utils/IVotes.sol";

contract KoloDAO is
    Initializable,
    GovernorUpgradeable,
    GovernorSettingsUpgradeable,
    GovernorCountingSimpleUpgradeable,
    GovernorStorageUpgradeable,
    GovernorVotesUpgradeable,
    GovernorVotesQuorumFractionUpgradeable,
    GovernorTimelockControlUpgradeable,
    OwnableUpgradeable
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initialization function for the upgradeable DAO contract.
     * @param _token The ERC20Votes-compatible token used for governance.
     * @param _timelock The TimelockControllerUpgradeable contract instance.
     * @param votingDelayBlocks Delay (in blocks) before voting starts.
     * @param votingPeriodBlocks Duration (in blocks) for voting.
     * @param proposalThresholdTokens Minimum tokens required to create a proposal.
     */
    function initialize(
        IVotes _token,
        TimelockControllerUpgradeable _timelock,
        uint48 votingDelayBlocks,
        uint32 votingPeriodBlocks,
        uint256 proposalThresholdTokens
    ) public initializer {
        __Governor_init("KoloDAOUpgradable");
        __GovernorSettings_init(
            votingDelayBlocks, // e.g., 1 block
            votingPeriodBlocks, // e.g., 45818 for ~1 week on mainnet
            proposalThresholdTokens // e.g., 0 (no threshold)
        );
        __GovernorCountingSimple_init();
        __GovernorStorage_init();
        __GovernorVotes_init(_token);
        __GovernorVotesQuorumFraction_init(4); // 4% quorum by default
        __GovernorTimelockControl_init(_timelock);
        __Ownable_init(msg.sender);
    }

    /**
     * @notice Quadratic Voting: calculates voting power as the square root of raw votes.
     * @dev This override applies the quadratic voting mechanism.
     */
    function _getVotes(
        address account,
        uint256 blockNumber,
        bytes memory /* params */
    )
        internal
        view
        virtual
        override(GovernorUpgradeable, GovernorVotesUpgradeable)
        returns (uint256)
    {
        uint256 rawVotes = super._getVotes(account, blockNumber, "");
        return _sqrt(rawVotes);
    }

    /**
     * @notice Returns the voting delay in blocks.
     */
    function votingDelay()
        public
        view
        override(GovernorUpgradeable, GovernorSettingsUpgradeable)
        returns (uint256)
    {
        return super.votingDelay();
    }

    /**
     * @notice Returns the voting period in blocks.
     */
    function votingPeriod()
        public
        view
        override(GovernorUpgradeable, GovernorSettingsUpgradeable)
        returns (uint256)
    {
        return super.votingPeriod();
    }

    /**
     * @notice Returns the minimum token threshold required to create proposals.
     */
    function proposalThreshold()
        public
        view
        override(GovernorUpgradeable, GovernorSettingsUpgradeable)
        returns (uint256)
    {
        return super.proposalThreshold();
    }

    /**
     * @notice Returns the required quorum at a given block number.
     */
    function quorum(
        uint256 blockNumber
    )
        public
        view
        override(GovernorUpgradeable, GovernorVotesQuorumFractionUpgradeable)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    /**
     * @notice Combines the state evaluation from GovernorUpgradeable and GovernorTimelockControlUpgradeable.
     */
    function state(
        uint256 proposalId
    )
        public
        view
        override(GovernorUpgradeable, GovernorTimelockControlUpgradeable)
        returns (ProposalState)
    {
        return super.state(proposalId);
    }

    /**
     * @notice Determines if a proposal needs to be queued (per GovernorTimelockControlUpgradeable).
     */
    function proposalNeedsQueuing(
        uint256 proposalId
    )
        public
        view
        override(GovernorUpgradeable, GovernorTimelockControlUpgradeable)
        returns (bool)
    {
        return super.proposalNeedsQueuing(proposalId);
    }

    /**
     * @notice Queues the operations for a proposal in the timelock.
     */
    function _queueOperations(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        internal
        virtual
        override(GovernorUpgradeable, GovernorTimelockControlUpgradeable)
        returns (uint48)
    {
        return
            super._queueOperations(
                proposalId,
                targets,
                values,
                calldatas,
                descriptionHash
            );
    }

    /**
     * @notice Executes the operations of a proposal after the timelock delay.
     */
    function _executeOperations(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        internal
        virtual
        override(GovernorUpgradeable, GovernorTimelockControlUpgradeable)
    {
        super._executeOperations(
            proposalId,
            targets,
            values,
            calldatas,
            descriptionHash
        );
    }

    /**
     * @notice Cancels a proposal.
     */
    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        internal
        virtual
        override(GovernorUpgradeable, GovernorTimelockControlUpgradeable)
        returns (uint256)
    {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    /**
     * @notice Returns the executor address from GovernorTimelockControlUpgradeable.
     */
    function _executor()
        internal
        view
        virtual
        override(GovernorUpgradeable, GovernorTimelockControlUpgradeable)
        returns (address)
    {
        return super._executor();
    }

    function _propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description,
        address proposer
    )
        internal
        override(GovernorUpgradeable, GovernorStorageUpgradeable)
        returns (uint256)
    {
        return
            super._propose(targets, values, calldatas, description, proposer);
    }

    /**
     * @notice Internal square root function for Quadratic Voting calculation.
     */
    function _sqrt(uint256 x) internal pure returns (uint256) {
        if (x == 0) return 0;
        uint256 z = (x + 1) / 2;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }
}
