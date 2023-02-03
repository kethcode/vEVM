// SPDX-License-Identifier: mine
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract vEVM {
    struct vEVMState {
        bytes32[] stack;
        bytes32[] vMemory;
        bytes32[] vStorage;
        bytes32[] returnData;
        bytes32[] logs;
        bytes32[] vTx;
        bytes32[] vBlock;
        bytes32[] account;
        bytes32[] vContract;
        bytes32[] call;
        bytes32[] state;
        bytes32[] opcode;
        bytes32[] gas;
        bytes32[] pc;
        bytes32[] msize;
        bytes32[] jumpdest;
        bytes32[] push;
        bytes32[] invalid;
    }

    function eval(bytes calldata input)
        external
        view
        returns (vEVMState memory)
    {
        vEVMState memory evm;
		for(uint i = 0; i < input.length; i++) {
			bytes1 opcode = input[i];
			console.log("opcode:");
			console.logBytes1(opcode);
		}
		
        // first, separate by command length

        // single opcode commands with no parameters
        // 0x00	STOP
        // 0x30 ADDRESS
        // 0x32 ORIGIN
        // 0x33 CALLER
        // 0x34 CALLVALUE
        // 0x36 CALLDATASIZE
        // 0x38 CODESIZE
        // 0x3A GASPRICE
        // 0x3D RETURNDATASIZE
        // 0x41 COINBASE
        // 0x42 TIMESTAMP
        // 0x43 NUMBER
        // 0x44 DIFFICULTY / PREVRANDAO
        // 0x45 GASLIMIT
        // 0x46 CHAINID
        // 0x47 SELFBALANCE
        // 0x48 BASEFEE
        // 0x58 PC
        // 0x59 MSIZE
        // 0x5A GAS
        // 0x5B JUMPDEST
        // 0x60-0x7F PUSH1-32
        // FE INVALID

        // many of these just dont apply to this game, although I'll need
        // to implement analogues somehow. can't probalby just call the
        // actual opcodes, and return the results.

		return evm;
    }
}
