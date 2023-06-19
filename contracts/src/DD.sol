// SPDX-License-Identifier: CC0-1.0
pragma solidity 0.8.15;

import "./ZkAddress.sol";

contract DD {
    uint32 public directDepositNonce;
    mapping(uint256 => address) fallback_account;
    mapping(uint256 => uint64) amount;

    event SubmitDirectDeposit(
        address indexed sender,
        uint256 indexed nonce,
        address fallbackUser,
        ZkAddress.ZkAddress zkAddress,
        uint64 deposit
    );
    event RefundDirectDeposit(uint256 indexed nonce, address receiver, uint256 amount);
    event CompleteDirectDepositBatch(uint256[] indices);

    function makeDD(address _sender, address _fallbackReceiver, bytes10 _diversifier, bytes32 _pk, uint64 _depositAmount) external
    {
        uint256 nonce = directDepositNonce++;
        fallback_account[nonce] = _fallbackReceiver;
        amount[nonce] = _depositAmount;
        ZkAddress.ZkAddress memory zkAddress = ZkAddress.ZkAddress(_diversifier, _pk);
        emit SubmitDirectDeposit(_sender, nonce, _fallbackReceiver, zkAddress, _depositAmount);
    }

    function completeDD(uint256[] calldata _indices) external {
        emit CompleteDirectDepositBatch(_indices);
    }

    function refundDD(uint256 _index) external {
        emit RefundDirectDeposit(_index, fallback_account[_index], amount[_index]);
    }

    function refundDD(uint256[] calldata _indices) external {
        for (uint256 i = 0; i < _indices.length; ++i) {
            emit RefundDirectDeposit(_indices[i], fallback_account[_indices[i]], amount[_indices[i]]);
        }
    }
}
