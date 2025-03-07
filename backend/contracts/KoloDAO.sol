// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

/**
 * @title KoloDAO - DAO with Quadratic Voting
 * @notice A governor contract using OpenZeppelin upgradeable libraries.
 * @dev This contract uses a quadratic voting mechanism (via the square root of raw votes).
 */

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/governance/GovernorUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorSettingsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorCountingSimpleUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorVotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorVotesQuorumFractionUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorStorageUpgradeable.sol";
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
    OwnableUpgradeable
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice If set to true, the contract will use off-chain precomputed votes (without applying square root).
     * If false, the contract computes the square root of the raw votes to apply quadratic weighting.
     */
    bool public useOffChainSqrt;

    /**
     * @notice Initializes the DAO.
     * @param _token The ERC20Votes-compatible token used for governance.
     * @param votingDelayBlocks Delay (in blocks) before voting starts.
     * @param votingPeriodBlocks Duration (in blocks) of the voting period.
     * @param proposalThresholdTokens Minimum token threshold required to create a proposal.
     */
    function initialize(
        IVotes _token,
        uint48 votingDelayBlocks,
        uint32 votingPeriodBlocks,
        uint256 proposalThresholdTokens
    ) public initializer {
        __Governor_init("KoloDAO");
        __GovernorSettings_init(
            votingDelayBlocks,
            votingPeriodBlocks,
            proposalThresholdTokens
        );
        __GovernorCountingSimple_init();
        __GovernorStorage_init();
        __GovernorVotes_init(_token);
        __GovernorVotesQuorumFraction_init(4); // 4% quorum
        __Ownable_init(msg.sender);
        useOffChainSqrt = false; // By default, the square root is computed on-chain.
    }

    /**
     * @notice Allows the owner to choose the vote weighting calculation mode.
     * @param _useOffChainSqrt If true, the contract expects pre-transformed votes (square root applied off-chain).
     *                         If false, the transformation is performed on-chain.
     */
    function setUseOffChainSqrt(bool _useOffChainSqrt) external onlyOwner {
        useOffChainSqrt = _useOffChainSqrt;
    }

    function proposalThreshold()
        public
        view
        override(GovernorUpgradeable, GovernorSettingsUpgradeable)
        returns (uint256)
    {
        return super.proposalThreshold();
    }

    /**
     * @notice Calculates the voting power with quadratic adjustment.
     * @dev If useOffChainSqrt is true, it is assumed that the vote value is already adjusted off-chain.
     * Otherwise, the _sqrt function is applied to reduce the weight of large token holders.
     * The 'params' parameter is now correctly propagated for broader compatibility.
     */
    function _getVotes(
        address account,
        uint256 blockNumber,
        bytes memory params
    )
        internal
        view
        virtual
        override(GovernorUpgradeable, GovernorVotesUpgradeable)
        returns (uint256)
    {
        uint256 rawVotes = super._getVotes(account, blockNumber, params);
        if (useOffChainSqrt) {
            // Votes are already adjusted off-chain.
            return rawVotes;
        } else {
            // Compute the square root of raw votes on-chain.
            return _sqrt(rawVotes);
        }
    }

    /**
     * @notice Overrides the internal _propose function to combine the functionalities of GovernorUpgradeable and GovernorStorageUpgradeable.
     */
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
     * @notice Internal square root function (Babylon's method).
     * @dev Used for applying the quadratic voting mechanism on-chain.
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
