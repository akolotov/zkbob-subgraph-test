// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "forge-std/Script.sol";
import "../src/DD.sol";
import "../src/ZkAddress.sol";
import "../src/Pool.sol";

bytes10 constant a00_diversifier = 0xe817e6ffd73e1e928cb1;
bytes32 constant a00_pk = 0x19bf285f67d5f4613cc89e6183ed6e6a940b0a964ed9e1a01656efcd91d0b1ff;
bytes10 constant a01_diversifier = 0xa056dcaeeb9ad09e58f9;
bytes32 constant a01_pk = 0x272d0a930523927dd3831b2dc756066c59b9dfa7057157ff509eec408069f238;
bytes10 constant a02_diversifier = 0xa484e07a3b7ecb54b5ae;
bytes32 constant a02_pk = 0x1184a1929622dd6708a72f927a7de1defc49cf6329de6b9e7f9b99cdd12efe9c;
bytes10 constant a03_diversifier = 0x79a2a0f56c77bd5b84b1;
bytes32 constant a03_pk = 0x0400774a74073d4b4c0b7f5690237c960e2e8660eade0127cfe7f1bfdcf2d5a9;
bytes10 constant a04_diversifier = 0x2af6fe74fc7762977639;
bytes32 constant a04_pk = 0x242d8ebd9234e21d88d42acc8b2bb40c286db78233e89ac7c424cbf9160a9324;
bytes10 constant a05_diversifier = 0x5d1610102c79feb2f397;
bytes32 constant a05_pk = 0x19fac24f5ba3086e85d8ca0fe676f57c5679fdbb6f248d58935c7e0c78cc04aa;
bytes10 constant a06_diversifier = 0xe5c9ae7d3d2648879145;
bytes32 constant a06_pk = 0x2096ff17b55dde6a7fccb6fea099923c8387cb46c625a3890eef9057ce396106;

address constant sender_39f0 = address(0x39F0bD56c1439a22Ee90b4972c16b7868D161981);
address constant sender_5a2f = address(0x5a2F8A4dbADFCf458B52d6D761C4f50A7Cf1d770);
address constant sender_0769 = address(0x076960C634478c90d569cD630FAF5FB06addDeCB);
address constant sender_efde = address(0xEFDE880F1b6116023FF6011dB15A473edE8A06E8);
address constant sender_d408 = address(0xD408c5DdcBf297dcAa745009277007429719E205);
address constant sender_b3e5 = address(0xb3E5A0060cb17FEBb7ecC339e4F2C4398D062f59);

address constant fallback_668c = address(0x668c5286eAD26fAC5fa944887F9D2F20f7DDF289);

contract CounterScript is Script {
    function rangeToArray(uint256 _start, uint256 _end) pure internal returns (uint256[] memory) {
        uint256 count = _end - _start + 1;
        uint256[] memory range = new uint256[](count);
        for (uint256 i = 0; i < count; ++i) {
            range[i] = _start + i;
        }
        return range;
    }

    function run() public {
        vm.startBroadcast();

        DD dd = new DD();
        Pool pool = new Pool();

        pool.transact();

        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1000000000); // nonce 0

        // uint256[] memory ids = new uint256[](1);
        // ids[0] = 0;
        dd.completeDD(rangeToArray(0, 0));

        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1100000000); // nonce 1
        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1200000000); // nonce 2
        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1300000000); // nonce 3
        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1400000000); // nonce 4
        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1500000000); // nonce 5
        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1600000000); // nonce 6
        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1700000000); // nonce 7

        dd.completeDD(rangeToArray(1, 7));

        dd.makeDD(sender_5a2f, sender_5a2f, a01_diversifier, a01_pk, 900000000); // nonce 8
        dd.makeDD(sender_5a2f, sender_5a2f, a01_diversifier, a01_pk, 900000000); // nonce 9
        dd.makeDD(sender_5a2f, sender_5a2f, a01_diversifier, a01_pk, 900000000); // nonce a
        dd.makeDD(sender_5a2f, sender_5a2f, a01_diversifier, a01_pk, 900000000); // nonce b

        dd.completeDD(rangeToArray(8, 0xb));

        dd.makeDD(sender_0769, sender_0769, a01_diversifier, a01_pk, 400000000); // nonce c
        dd.makeDD(sender_0769, sender_0769, a01_diversifier, a01_pk, 400000000); // nonce d

        dd.completeDD(rangeToArray(0xc, 0xd));

        dd.makeDD(sender_efde, sender_efde, a02_diversifier, a02_pk, 4000000000); // nonce e

        dd.completeDD(rangeToArray(0xe, 0xe));

        dd.makeDD(sender_efde, sender_efde, a03_diversifier, a03_pk, 3000000000); // nonce f

        dd.completeDD(rangeToArray(0xf, 0xf));

        dd.makeDD(sender_d408, sender_d408, a04_diversifier, a04_pk, 4900000000); // nonce 10

        dd.completeDD(rangeToArray(0x10, 0x10));

        dd.makeDD(sender_b3e5, fallback_668c, a05_diversifier, a05_pk, 900000000); // nonce 11
        dd.makeDD(sender_b3e5, fallback_668c, a05_diversifier, a05_pk, 900000000); // nonce 12
        dd.makeDD(sender_b3e5, fallback_668c, a05_diversifier, a05_pk, 900000000); // nonce 13

        dd.completeDD(rangeToArray(0x11, 0x13));

        dd.makeDD(sender_b3e5, fallback_668c, a05_diversifier, a05_pk, 10000000); // nonce 14
        dd.makeDD(sender_b3e5, fallback_668c, a05_diversifier, a05_pk, 10000000); // nonce 15
        dd.makeDD(sender_b3e5, fallback_668c, a05_diversifier, a05_pk, 10000000); // nonce 16
        dd.makeDD(sender_b3e5, fallback_668c, a05_diversifier, a05_pk, 10000000); // nonce 17

        dd.completeDD(rangeToArray(0x14, 0x17));

        dd.makeDD(sender_b3e5, sender_b3e5, a06_diversifier, a06_pk, 3900000000); // nonce 18

        dd.completeDD(rangeToArray(0x18, 0x18));

        dd.makeDD(sender_b3e5, sender_b3e5, a06_diversifier, a06_pk, 1900000000); // nonce 19

        dd.completeDD(rangeToArray(0x19, 0x19));

        dd.makeDD(sender_b3e5, sender_b3e5, a06_diversifier, a06_pk, 1900000000); // nonce 1a

        dd.completeDD(rangeToArray(0x1a, 0x1a));

        dd.makeDD(sender_b3e5, sender_b3e5, a06_diversifier, a06_pk, 1900000000); // nonce 1b

        dd.completeDD(rangeToArray(0x1b, 0x1b));

        dd.makeDD(sender_b3e5, sender_b3e5, a06_diversifier, a06_pk, 1900000000); // nonce 1c

        dd.completeDD(rangeToArray(0x1c, 0x1c));

        dd.makeDD(sender_b3e5, sender_b3e5, a06_diversifier, a06_pk, 1900000000); // nonce 1d

        dd.completeDD(rangeToArray(0x1d, 0x1d));

        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1100000000); // nonce 1e
        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1200000000); // nonce 1f
        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1300000000); // nonce 20
        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1400000000); // nonce 21
        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1500000000); // nonce 22
        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1600000000); // nonce 23
        dd.makeDD(sender_39f0, sender_39f0, a00_diversifier, a00_pk, 1700000000); // nonce 24

        dd.refundDD(0x21);
        dd.refundDD(0x23);

        pool.transact();

        vm.stopBroadcast();

        console2.log("DD contract:", address(dd));
        console2.log("Pool contract:", address(pool));
    }
}
