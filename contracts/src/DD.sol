// SPDX-License-Identifier: CC0-1.0
pragma solidity 0.8.15;

import "./ZkAddress.sol";

contract DD {
    enum DirectDepositStatus {
        Missing, // requested deposit does not exist
        Pending, // requested deposit was submitted and is pending in the queue
        Completed, // requested deposit was successfully processed
        Refunded // requested deposit was refunded to the fallback receiver
    }

    struct DirectDeposit {
        address fallbackReceiver; // refund receiver for deposits that cannot be processed
        uint96 sent; // sent amount in BOB tokens (18 decimals)
        uint64 deposit; // deposit amount, after subtracting all fees (9 decimals)
        uint64 fee; // deposit fee (9 decimals)
        uint40 timestamp; // deposit submission timestamp
        DirectDepositStatus status; // deposit status
        bytes10 diversifier; // receiver zk address, part 1/2
        bytes32 pk; // receiver zk address, part 2/2
    }

    uint32 public directDepositNonce;
    mapping(uint256 => DirectDeposit) internal directDeposits;

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
        DirectDeposit memory dd = DirectDeposit({
            fallbackReceiver: _fallbackReceiver,
            sent: uint96(_depositAmount * 1001 / 1000),
            deposit: _depositAmount,
            fee: _depositAmount / 1000,
            timestamp: uint40(block.timestamp),
            status: DirectDepositStatus.Pending,
            diversifier: _diversifier,
            pk: _pk
        });
        uint256 nonce = directDepositNonce++;
        directDeposits[nonce] = dd;
        ZkAddress.ZkAddress memory zkAddress = ZkAddress.ZkAddress(_diversifier, _pk);
        emit SubmitDirectDeposit(_sender, nonce, _fallbackReceiver, zkAddress, _depositAmount);
    }

    function completeDD(uint256[] calldata _indices) external {
        for (uint256 i = 0; i < _indices.length; ++i) {
            uint256 index = _indices[i];
            DirectDeposit storage dd = directDeposits[index];
            dd.status = DirectDepositStatus.Completed;
        }
        emit CompleteDirectDepositBatch(_indices);
    }

    function refundDD(uint256 _index) external {
        DirectDeposit storage dd = directDeposits[_index];
        dd.status = DirectDepositStatus.Refunded;
        (address fallbackReceiver, uint96 amount) = (dd.fallbackReceiver, dd.sent);
        emit RefundDirectDeposit(_index, fallbackReceiver, amount);
    }

    function refundDD(uint256[] calldata _indices) external {
        for (uint256 i = 0; i < _indices.length; ++i) {
            DirectDeposit storage dd = directDeposits[_indices[i]];
            dd.status = DirectDepositStatus.Refunded;
            (address fallbackReceiver, uint96 amount) = (dd.fallbackReceiver, dd.sent);
            emit RefundDirectDeposit(_indices[i], fallbackReceiver, amount);
        }
    }

    function getDirectDeposit(uint256 depositId) external view returns (DirectDeposit memory deposit) {
        return directDeposits[depositId];
    }
}
