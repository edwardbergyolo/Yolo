// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IRouterClient {
    function ccipSend(uint64 destinationChainSelector, Message calldata message) external payable returns (bytes32);
}

struct Message {
    bytes receiver;
    bytes data;
    address feeToken;
}

/**
 * @title YoloCrossChainCCIPBridge
 * @dev Transports cryptographically verified agent state roots across separate blockchains.
 */
contract YoloCrossChainCCIPBridge {
    address public immutable ccipRouter;
    address public immutable linkToken;

    event CrossChainLogSent(bytes32 indexed messageId, uint64 indexed destinationChain);

    constructor(address _router, address _link) {
        ccipRouter = _router;
        linkToken = _link;
    }

    function transportAgentState(
        uint64 destinationChainSelector,
        address receiver,
        bytes calldata agentData
    ) external payable returns (bytes32 messageId) {
        Message memory message = Message({
            receiver: abi.encode(receiver),
            data: agentData,
            feeToken: address(0) // Pays for cross-chain gas using native blockchain currency (ETH)
        });

        messageId = IRouterClient(ccipRouter).ccipSend{value: msg.value}(destinationChainSelector, message);
        emit CrossChainLogSent(messageId, destinationChainSelector);
    }
}
