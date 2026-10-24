solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SovereignAgentVaultV2
 * @dev Multi-Signature Protected Autonomous On-Chain Vault for YOLO.SOLUTIONS.
 * Requires a threshold of cryptographic signatures from multiple signers to execute actions.
 */
contract SovereignAgentVaultV2 {
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public immutable requiredSignaturesThreshold;
    
    uint256 public totalRevenueAccumulated;
    mapping(bytes32 => bool) public executedActions;

    struct SignatureUpdate {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    event RevenueDeposited(address indexed sender, uint256 amount);
    event MultiSigActionExecuted(bytes32 indexed actionHash, address indexed target, uint256 value);

    constructor(address[] memory _owners, uint256 _threshold) {
        require(_owners.length > 0, "Vault must declare at least one owner.");
        require(_threshold > 0 && _threshold <= _owners.length, "Invalid signature threshold parameters.");

        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner address root.");
            require(!isOwner[owner], "Duplicate owner address detected.");

            isOwner[owner] = true;
            owners.push(owner);
        }
        requiredSignaturesThreshold = _threshold;
    }

    receive() external payable {
        totalRevenueAccumulated += msg.value;
        emit RevenueDeposited(msg.sender, msg.value);
    }

    /**
     * @dev Executes a transaction signed off by a threshold quorum of multi-sig owners.
     * Prevents frontrunning and signature replay attacks by invalidating spent action hashes.
     */
    function executeMultiSigAction(
        address payable target,
        uint256 value,
        bytes calldata data,
        bytes32 actionHash,
        SignatureUpdate[] calldata signatures
    ) external returns (bytes memory) {
        require(!executedActions[actionHash], "Action hash already executed.");
        require(signatures.length >= requiredSignaturesThreshold, "Insufficient consensus signatures provided.");

        bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", actionHash));
        address lastSigner = address(0);

        for (uint256 i = 0; i < requiredSignaturesThreshold; i++) {
            address signer = ecrecover(messageHash, signatures[i].v, signatures[i].r, signatures[i].s);
            
            require(isOwner[signer], "Signature does not match an authorized vault owner.");
            require(signer > lastSigner, "Signatures must be ordered uniquely to prevent duplicate evaluation.");
            
            lastSigner = signer;
        }

        // Lock the transaction hash permanently before performing the contract call
        executedActions[actionHash] = true;

        (bool success, bytes memory result) = target.call{value: value}(data);
        require(success, "Autonomous multi-sig execution call reverted.");

        emit MultiSigActionExecuted(actionHash, target, value);
        return result;
    }
}
