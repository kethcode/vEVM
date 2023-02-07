// SPDX-License-Identifier: mine
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract vEVM {
    constructor() {}

    struct vEVMState {
        uint256 pc;
        bytes32[] stack;
        bytes mem;
        uint256 msize;
        // bytes32[] vStorage;
        bytes32 RETURNDATA;
        bool running;
        // bytes32[] logs;
        // bytes32[] vTx;
        // bytes32[] vBlock;
        // bytes32[] account;
        // bytes32[] vContract;
        // bytes32[] call;
        // bytes32[] state;
        // bytes32[] opcode;
        // bytes32[] gas;
        // bytes32[] msize;
        // bytes32[] jumpdest;
        // bytes32[] push;
        // bytes32[] invalid;
    }

    uint256 constant STACK_MAX_SIZE = 1024;
    uint256 constant MEM_MAX_SIZE = 256;

    function execute(bytes calldata bytecode)
        external
        view
        returns (vEVMState memory)
    {
        vEVMState memory evm;

        // create initial memory reservations
        evm.mem = expand_mem(evm.mem, 4);
        memory_write(evm.mem, uint256(0x00), bytes32(uint256(0x00)));
        memory_write(evm.mem, uint256(0x20), bytes32(uint256(0x00)));
        memory_write(evm.mem, uint256(0x40), bytes32(uint256(0x80)));
        memory_write(evm.mem, uint256(0x60), bytes32(uint256(0x00)));

        evm.pc = 0;
        evm.running = true;

        do {
            bytes1 opcode = bytecode[evm.pc];

            if (opcode == 0x00) {
                STOP(evm);
            } else if (opcode == 0x01) {
                ADD(evm);
            } else if (opcode == 0x02) {
                MUL(evm);
            } else if (opcode == 0x03) {
                SUB(evm);
            } else if (opcode == 0x04) {
                DIV(evm);
            } else if (opcode == 0x05) {
                SDIV(evm);
            } else if (opcode == 0x06) {
                MOD(evm);
            } else if (opcode == 0x07) {
                SMOD(evm);
            } else if (opcode == 0x08) {
                ADDMOD(evm);
            } else if (opcode == 0x09) {
                MULMOD(evm);
            } else if (opcode == 0x0A) {
                EXP(evm);
                // } else if (opcode == 0x0B) {
                // 	SIGNEXTEND(evm);
            } else if (opcode == 0x10) {
                LT(evm);
            } else if (opcode == 0x11) {
                GT(evm);
            } else if (opcode == 0x12) {
                SLT(evm);
            } else if (opcode == 0x13) {
                SGT(evm);
            } else if (opcode == 0x14) {
                EQ(evm);
                // } else if (opcode == 0x15) {
                // 	ISZERO(evm);
            } else if (opcode == 0x50) {
                POP(evm);
            } else if (opcode == 0x52) {
                MSTORE(evm);
            } else if ((opcode >= 0x60) && (opcode <= 0x7F)) {
                // PUSHX
                uint256 data_size = uint8(opcode) - 0x5F;
                PUSH(evm, bytecode[evm.pc + 1:evm.pc + 1 + data_size]);
                evm.pc += data_size;
            }

            if (!evm.running) {
                break;
            }
            evm.pc += 1;
        } while (evm.pc < bytecode.length);

        return evm;
    }

    function stack_overflow(vEVMState memory evm, uint256 stack_size_change)
        internal
        pure
        returns (bool)
    {
        if (evm.stack.length + stack_size_change > STACK_MAX_SIZE) {
            evm.RETURNDATA = bytes32(bytes("stack overflow"));
            evm.running = false;
            return true;
        }

        return false;
    }

    function stack_underflow(vEVMState memory evm, uint256 stack_size_change)
        internal
        pure
        returns (bool)
    {
        if (evm.stack.length < stack_size_change) {
            evm.RETURNDATA = bytes32(bytes("stack underflow"));
            evm.running = false;
            return true;
        }

        return false;
    }

    function expand_stack(bytes32[] memory buf, uint256 slots)
        internal
        pure
        returns (bytes32[] memory)
    {
        bytes32[] memory newbuf = new bytes32[](buf.length + slots);
        for (uint256 i = 0; i < buf.length; i++) {
            newbuf[i] = buf[i];
        }
        return newbuf;
    }

    function reduce_stack(bytes32[] memory buf, uint256 slots)
        internal
        pure
        returns (bytes32[] memory)
    {
        bytes32[] memory newbuf = new bytes32[](buf.length - slots);
        for (uint256 i = 0; i < buf.length - slots; i++) {
            newbuf[i] = buf[i];
        }
        return newbuf;
    }

    function expand_mem(bytes memory buf, uint256 slots)
        internal
        pure
        returns (bytes memory)
    {
        bytes memory newbuf = new bytes(buf.length + (slots * 32));
        for (uint256 i = 0; i < buf.length; i++) {
            newbuf[i] = buf[i];
        }
        return newbuf;
    }

    // // operators
    // inst_size[0x00] = 1;	// STOP			0x00	Returns EVM Object as is.
    function STOP(vEVMState memory evm) internal pure {
        evm.running = false;
    }

    // inst_size[0x01] = 1;	// ADD			0x01	Requires 2 stack values, 0 imm values.
    function ADD(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] = bytes32(
            uint256(evm.stack[evm.stack.length - 1]) +
                uint256(evm.stack[evm.stack.length - 2])
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x02] = 1;	// MUL			0x02	Requires 2 stack values, 0 imm values.
    function MUL(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] = bytes32(
            uint256(evm.stack[evm.stack.length - 1]) *
                uint256(evm.stack[evm.stack.length - 2])
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x03] = 1;	// SUB			0x03	Requires 2 stack values, 0 imm values.
    function SUB(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] = bytes32(
            uint256(evm.stack[evm.stack.length - 1]) -
                uint256(evm.stack[evm.stack.length - 2])
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x04] = 1;	// DIV			0x04	Requires 2 stack values, 0 imm values.
    function DIV(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] = bytes32(
            uint256(evm.stack[evm.stack.length - 1]) /
                uint256(evm.stack[evm.stack.length - 2])
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x05] = 1;	// SDIV			0x05	Requires 2 stack values, 0 imm values.
    function SDIV(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }

        evm.stack[evm.stack.length - 2] = bytes32(
            uint256(
                int256(uint256(evm.stack[evm.stack.length - 1])) /
                    int256(uint256(evm.stack[evm.stack.length - 2]))
            )
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x06] = 1;	// MOD			0x06	Requires 2 stack values, 0 imm values.
    function MOD(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }

        evm.stack[evm.stack.length - 2] = bytes32(
            uint256(evm.stack[evm.stack.length - 1]) %
                uint256(evm.stack[evm.stack.length - 2])
        );

        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x07] = 1;	// SMOD			0x07	Requires 2 stack values, 0 imm values.
    function SMOD(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }

        evm.stack[evm.stack.length - 2] = bytes32(
            uint256(
                int256(uint256(evm.stack[evm.stack.length - 1])) %
                    int256(uint256(evm.stack[evm.stack.length - 2]))
            )
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x08] = 1;	// ADDMOD		0x08	Requires 3 stack values, 0 imm values.
    function ADDMOD(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 3)) {
            return;
        }
        if (uint256(evm.stack[evm.stack.length - 3]) == 0) {
            evm.stack[evm.stack.length - 3] = bytes32(0);
        } else {
            evm.stack[evm.stack.length - 3] = bytes32(
                (uint256(evm.stack[evm.stack.length - 1]) +
                    uint256(evm.stack[evm.stack.length - 2])) %
                    uint256(evm.stack[evm.stack.length - 3])
            );
        }
        evm.stack = reduce_stack(evm.stack, 2);
    }

    // inst_size[0x09] = 1;	// MULMOD		0x09	Requires 3 stack values, 0 imm values.
    function MULMOD(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 3)) {
            return;
        }
        if (uint256(evm.stack[evm.stack.length - 3]) == 0) {
            evm.stack[evm.stack.length - 3] = bytes32(0);
        } else {
            evm.stack[evm.stack.length - 3] = bytes32(
                (uint256(evm.stack[evm.stack.length - 1]) *
                    uint256(evm.stack[evm.stack.length - 2])) %
                    uint256(evm.stack[evm.stack.length - 3])
            );
        }
        evm.stack = reduce_stack(evm.stack, 2);
    }

    // inst_size[0x0A] = 1;	// EXP			0x0A	Requires 2 stack values, 0 imm values.
    function EXP(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] = bytes32(
            uint256(evm.stack[evm.stack.length - 1]) **
                uint256(evm.stack[evm.stack.length - 2])
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x0B] = 1;	// SIGNEXTEND	0x0B	Requires 2 stack values, 0 imm values.
    // inst_size[0x10] = 1;	// LT			0x10	Requires 2 stack values, 0 imm values.
    function LT(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] = bytes32(
            uint256(
                uint256(evm.stack[evm.stack.length - 1]) <
                    uint256(evm.stack[evm.stack.length - 2])
                    ? 1
                    : 0
            )
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x11] = 1;	// GT			0x11	Requires 2 stack values, 0 imm values.
    function GT(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] = bytes32(
            uint256(
                uint256(evm.stack[evm.stack.length - 1]) >
                    uint256(evm.stack[evm.stack.length - 2])
                    ? 1
                    : 0
            )
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x12] = 1;	// SLT			0x12	Requires 2 stack values, 0 imm values.
    function SLT(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] = bytes32(
            uint256(
                int256(uint256(evm.stack[evm.stack.length - 1])) <
                    int256(uint256(evm.stack[evm.stack.length - 2]))
                    ? 1
                    : 0
            )
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x13] = 1;	// SGT			0x13	Requires 2 stack values, 0 imm values.
    function SGT(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] = bytes32(
            uint256(
                int256(uint256(evm.stack[evm.stack.length - 1])) >
                    int256(uint256(evm.stack[evm.stack.length - 2]))
                    ? 1
                    : 0
            )
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x14] = 1;	// EQ			0x14	Requires 2 stack values, 0 imm values.
    function EQ(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] = bytes32(
            uint256(
                uint256(evm.stack[evm.stack.length - 1]) ==
                    uint256(evm.stack[evm.stack.length - 2])
                    ? 1
                    : 0
            )
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x15] = 1;	// ISZERO		0x15	Requires 1 stack values, 0 imm values.
    function ISZERO(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 1)) {
            return;
        }
        evm.stack[evm.stack.length - 1] = bytes32(
            uint256(uint256(evm.stack[evm.stack.length - 1]) == 0 ? 1 : 0)
        );
    }

    // inst_size[0x16] = 1;	// AND			0x16	Requires 2 stack values, 0 imm values.
    // inst_size[0x17] = 1;	// OR			0x17	Requires 2 stack values, 0 imm values.
    // inst_size[0x18] = 1;	// XOR			0x18	Requires 2 stack values, 0 imm values.
    // inst_size[0x19] = 1;	// NOT			0x19	Requires 1 stack values, 0 imm values.
    // inst_size[0x1A] = 1;	// BYTE			0x1A	Requires 2 stack values, 0 imm values.
    // inst_size[0x1B] = 1;	// SHL			0x1B	Requires 2 stack values, 0 imm values.
    // inst_size[0x1C] = 1;	// SHR			0x1C	Requires 2 stack values, 0 imm values.
    // inst_size[0x1D] = 1;	// SAR			0x1D	Requires 2 stack values, 0 imm values.
    // inst_size[0x20] = 1;	// SHA3			0x20	Requires 2 stack values, 0 imm values.

    // // external data manupulation
    // inst_size[0x30] = 1;	// ADDRESS		0x30	Return vEVM address, or allow an override?
    // inst_size[0x31] = 1;	// BALANCE		0x31	Requires 1 stack value, 0 imm values. Fetch an actual balance?
    // inst_size[0x32] = 1;	// ORIGIN		0x32	Use actual tx.origin?
    // inst_size[0x33] = 1;	// CALLER		0x33	Use actual msg.sender?
    // inst_size[0x34] = 1;	// CALLVALUE	0x34	Use actual msg.value?
    // inst_size[0x35] = 1;	// CALLDATALOAD	0x35	Requires 1 stack value, 0 imm values. Use actual msg.data?
    // inst_size[0x36] = 1;	// CALLDATASIZE	0x36	Requires 0 stack value, 0 imm values. Use actual msg.data?
    // inst_size[0x37] = 1;	// CALLDATACOPY	0x37	Requires 3 stack values, 0 imm values. Use actual msg.data?
    // inst_size[0x38] = 1;	// CODESIZE		0x38	Requires 0 stack value, 0 imm values. Use original size of input?
    // inst_size[0x39] = 1;	// CODECOPY		0x39	Requires 3 stack values, 0 imm values. Use original input?
    // inst_size[0x3A] = 1;	// GASPRICE		0x3A	Use actual tx.gasprice?
    // inst_size[0x3B] = 1;	// EXTCODESIZE	0x3B	Requires 1 stack value, 0 imm values. Use actual size of code?
    // inst_size[0x3C] = 1;	// EXTCODECOPY	0x3C	Requires 4 stack values, 0 imm values. Use actual code?
    // inst_size[0x3D] = 1;	// RETURNDATASIZE	0x3D	Requires 0 stack value, 0 imm values. Use actual size of return data?
    // inst_size[0x3E] = 1;	// RETURNDATACOPY	0x3E	Requires 3 stack values, 0 imm values. Use actual return data?
    // inst_size[0x3F] = 1;	// EXTCODEHASH	0x3F	Requires 1 stack value, 0 imm values. Use actual code hash?

    // // block information
    // inst_size[0x40] = 1;	// BLOCKHASH	0x40	Requires 1 stack value, 0 imm values. Use actual blockhash?
    // inst_size[0x41] = 1;	// COINBASE		0x41	Use actual block.coinbase?
    // inst_size[0x42] = 1;	// TIMESTAMP	0x42	Use actual block.timestamp?
    // inst_size[0x43] = 1;	// NUMBER		0x43	Use actual block.number?
    // inst_size[0x44] = 1;	// PREVRANDAO	0x44	Use actual block.PREVRANDAO?
    // inst_size[0x45] = 1;	// GASLIMIT		0x45	Use actual block.gaslimit?
    // inst_size[0x46] = 1;	// CHAINID		0x46	Use actual block.chainid?
    // inst_size[0x47] = 1;	// SELFBALANCE	0x47	Same as calling BALANCE on vEVM address, but cheaper
    // inst_size[0x48] = 1;	// BASEFEE		0x48	Use actual basefee?

    // // memory manipluation
    // inst_size[0x50] = 1;	// POP			0x50	Requires 1 stack value, 0 imm values.
    function POP(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 1)) {
            return;
        }
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x51] = 1;	// MLOAD		0x51	Requires 1 stack value, 0 imm values.
    // inst_size[0x52] = 1;	// MSTORE		0x52	Requires 2 stack values, 0 imm values.
    function MSTORE(vEVMState memory evm) internal view {
        if (stack_underflow(evm, 2)) {
            return;
        }

        // memory expansion time
        uint256 start_position = uint256(evm.stack[evm.stack.length - 1]);
        uint256 value = uint256(evm.stack[evm.stack.length - 2]);

        // memory operates on bytes, not slots
        // memory expands in 32 byte slots
        console.logBytes(evm.mem);

        uint256 memory_address_top = uint256(
            memory_read(evm.mem, uint256(0x40))
        );
        console.log("memory address top: %s", memory_address_top);

        uint256 memory_address_highest_needed = uint256(0x80) +
            start_position +
            32;
        console.log(
            "memory address highest needed: %s",
            memory_address_highest_needed
        );

        if (memory_address_highest_needed > memory_address_top) {
            console.log("memory expansion needed");

            uint256 memory_to_add = memory_address_highest_needed -
                memory_address_top;
            console.log("memory to expand: %s", memory_to_add);

            // how many memory slots do we need to expand by?
            uint256 memory_slots_to_add = memory_to_add / 32;
            console.log("memory slots to expand: %s", memory_slots_to_add);

            // expand the memory
            evm.mem = expand_mem(evm.mem, memory_slots_to_add);
        }

        memory_write(
            evm.mem,
            uint256(0x80) + start_position,
            bytes32(value)
        );

        memory_write(evm.mem, uint256(0x40), bytes32(uint256(0x80) + start_position + 32));

        memory_address_top = uint256(memory_read(evm.mem, uint256(0x40)));
        console.log("memory address top: %s", memory_address_top);

        memory_address_highest_needed = uint256(0x80) + start_position + 32;
        console.log(
            "memory address highest needed: %s",
            memory_address_highest_needed
        );

        // the amount of memory we have allocated is evm.mem.length * 0x20
        // minus the start of free memory, which is 0x80
        // uint256 memory_allocated = (evm.mem.length) - uint256(0x80);
        // console.log("memory allocated: %s", memory_allocated);

        // // the amount of memory we have available is the top of allocated
        // // minud the location pointed to by the address pointed at by
        // // the free memory pointer (stored at slot 2, byte 0x40)

        // // uint256 memory_available = memory_allocated -
        // //     uint256(memory_read(evm.mem, uint256(0x40)));
        // // console.log("memory available: %s", memory_available);

        // // // we need to expand the memory to 32 bytes past the start position
        // uint256 memory_needed = start_position + 32;
        // console.log("memory needed: %s", memory_needed);

        // // if we need more memory than we have available, expand it
        // if (memory_needed > memory_available) {
        //     // how much memory do we need to expand by?

        // }

        // memory_allocated = (evm.mem.length) - uint256(0x80);
        // console.log("memory allocated: %s", memory_allocated);

        // memory_available =
        //     memory_allocated -
        //     uint256(bytesToBytes32(evm.mem, 0x40));
        // console.log("memory available: %s", memory_available);

        // // write the value to memory
        // bytes32ToBytes(evm.mem, start_position, bytes32(value));

        // all slots here are 32 bytes.
        // so we need start positon + 32 / 32 memory slots

        // uint256 memory_slots_needed = (start_position + 32) / 32;

        // if(evm.mem.length < memory_slots_needed) {
        // 	evm.mem = expand_space(evm.mem, memory_slots_needed - evm.mem.length);
        // }

        // however. writing to address 0x40 fails, right?

        // if(evm.mem.length < (uint256(evm.stack[evm.stack.length - 1]) / 32) + 1)

        // memory_word = uint256(evm.stack[evm.stack.length - 1]) / 32;
        // value = uint256(evm.stack[evm.stack.length - 2])

        // evm.mem = expand_space(evm.mem, 1);
        // evm.mem[evm.mem.length - 1] = bytes32(data);
    }

    // inst_size[0x53] = 1;	// MSTORE8		0x53	Requires 2 stack values, 0 imm values.
    // function MSTORE8(vEVMState memory evm, bytes1 data) internal pure {
    // 	if (stack_underflow(evm, 2)) {
    //         return;
    //     }
    //     if (evm.mem.length == 0) {
    //         evm.mem = expand_space(evm.mem, 1);
    //     }

    //     // this one is interesting.

    //     // if the stack is empty, we expand the stack and put this in the first byte

    //     // if the stack isn't empty...

    //     // is the top word of the stack full?
    //     // if so, we expand the stack and put this in the first byte

    //     // if not, how do we tell teh difference between empy zeros and intentional zeroes?

    //     // nope, we are just writng to a byte position.  dont overcomplicate this.
    //     // this isn't an concat. this is writing to an index.

    //     if (stack_overflow(evm, 1)) {
    //         return;
    //     }
    //     evm.mem = expand_space(evm.mem, 1);
    //     evm.mem[evm.mem.length - 1] = bytes32(data);
    // }

    // inst_size[0x54] = 1;	// SLOAD		0x54	Requires 1 stack value, 0 imm values.
    // inst_size[0x55] = 1;	// SSTORE		0x55	Requires 2 stack values, 0 imm values.
    // inst_size[0x56] = 1;	// JUMP			0x56	Requires 1 stack value, 0 imm values.
    // inst_size[0x57] = 1;	// JUMPI		0x57	Requires 2 stack values, 0 imm values.
    // inst_size[0x58] = 1;	// PC			0x58	Requires 0 stack value, 0 imm values.
    // inst_size[0x59] = 1;	// MSIZE		0x59	Requires 0 stack value, 0 imm values.
    // inst_size[0x5A] = 1;	// GAS			0x5A	Requires 0 stack value, 0 imm values. no messing with this for now.
    // inst_size[0x5B] = 1;	// JUMPDEST		0x5B	Requires 0 stack value, 0 imm values. basically a NOP

    // // stack manipluation

    // Generalized PUSH instruction
    function PUSH(vEVMState memory evm, bytes memory data) internal pure {
        if (stack_overflow(evm, 1)) {
            return;
        }
        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(data);
    }

    // inst_size[0x60] = 2;	// PUSH1		0x60	Requires 0 stack value, 1 imm values
    // inst_size[0x61] = 3;	// PUSH2		0x61	Requires 0 stack value, 2 imm values.
    // inst_size[0x62] = 4;	// PUSH3		0x62	Requires 0 stack value, 3 imm values.
    // inst_size[0x63] = 5;	// PUSH4		0x63	Requires 0 stack value, 4 imm values.
    // inst_size[0x64] = 6;	// PUSH5		0x64	Requires 0 stack value, 5 imm values.
    // inst_size[0x65] = 7;	// PUSH6		0x65	Requires 0 stack value, 6 imm values.
    // inst_size[0x66] = 8;	// PUSH7		0x66	Requires 0 stack value, 7 imm values.
    // inst_size[0x67] = 9;	// PUSH8		0x67	Requires 0 stack value, 8 imm values.
    // inst_size[0x68] = 10;	// PUSH9		0x68	Requires 0 stack value, 9 imm values.
    // inst_size[0x69] = 11;	// PUSH10		0x69	Requires 0 stack value, 10 imm values.
    // inst_size[0x6A] = 12;	// PUSH11		0x6A	Requires 0 stack value, 11 imm values.
    // inst_size[0x6B] = 13;	// PUSH12		0x6B	Requires 0 stack value, 12 imm values.
    // inst_size[0x6C] = 14;	// PUSH13		0x6C	Requires 0 stack value, 13 imm values.
    // inst_size[0x6D] = 15;	// PUSH14		0x6D	Requires 0 stack value, 14 imm values.
    // inst_size[0x6E] = 16;	// PUSH15		0x6E	Requires 0 stack value, 15 imm values.
    // inst_size[0x6F] = 17;	// PUSH16		0x6F	Requires 0 stack value, 16 imm values.
    // inst_size[0x70] = 18;	// PUSH17		0x70	Requires 0 stack value, 17 imm values.
    // inst_size[0x71] = 19;	// PUSH18		0x71	Requires 0 stack value, 18 imm values.
    // inst_size[0x72] = 20;	// PUSH19		0x72	Requires 0 stack value, 19 imm values.
    // inst_size[0x73] = 21;	// PUSH20		0x73	Requires 0 stack value, 20 imm values.
    // inst_size[0x74] = 22;	// PUSH21		0x74	Requires 0 stack value, 21 imm values.
    // inst_size[0x75] = 23;	// PUSH22		0x75	Requires 0 stack value, 22 imm values.
    // inst_size[0x76] = 24;	// PUSH23		0x76	Requires 0 stack value, 23 imm values.
    // inst_size[0x77] = 25;	// PUSH24		0x77	Requires 0 stack value, 24 imm values.
    // inst_size[0x78] = 26;	// PUSH25		0x78	Requires 0 stack value, 25 imm values.
    // inst_size[0x79] = 27;	// PUSH26		0x79	Requires 0 stack value, 26 imm values.
    // inst_size[0x7A] = 28;	// PUSH27		0x7A	Requires 0 stack value, 27 imm values.
    // inst_size[0x7B] = 29;	// PUSH28		0x7B	Requires 0 stack value, 28 imm values.
    // inst_size[0x7C] = 30;	// PUSH29		0x7C	Requires 0 stack value, 29 imm values.
    // inst_size[0x7D] = 31;	// PUSH30		0x7D	Requires 0 stack value, 30 imm values.
    // inst_size[0x7E] = 32;	// PUSH31		0x7E	Requires 0 stack value, 31 imm values.
    // inst_size[0x7F] = 33;	// PUSH32		0x7F	Requires 0 stack value, 32 imm values.

    // inst_size[0x80] = 1;	// DUP1			0x80	Requires 1 stack value, 0 imm values.
    // inst_size[0x81] = 1;	// DUP2			0x81	Requires 2 stack value, 0 imm values.
    // inst_size[0x82] = 1;	// DUP3			0x82	Requires 3 stack value, 0 imm values.
    // inst_size[0x83] = 1;	// DUP4			0x83	Requires 4 stack value, 0 imm values.
    // inst_size[0x84] = 1;	// DUP5			0x84	Requires 5 stack value, 0 imm values.
    // inst_size[0x85] = 1;	// DUP6			0x85	Requires 6 stack value, 0 imm values.
    // inst_size[0x86] = 1;	// DUP7			0x86	Requires 7 stack value, 0 imm values.
    // inst_size[0x87] = 1;	// DUP8			0x87	Requires 8 stack value, 0 imm values.
    // inst_size[0x88] = 1;	// DUP9			0x88	Requires 9 stack value, 0 imm values.
    // inst_size[0x89] = 1;	// DUP10		0x89	Requires 10 stack value, 0 imm values.
    // inst_size[0x8A] = 1;	// DUP11		0x8A	Requires 11 stack value, 0 imm values.
    // inst_size[0x8B] = 1;	// DUP12		0x8B	Requires 12 stack value, 0 imm values.
    // inst_size[0x8C] = 1;	// DUP13		0x8C	Requires 13 stack value, 0 imm values.
    // inst_size[0x8D] = 1;	// DUP14		0x8D	Requires 14 stack value, 0 imm values.
    // inst_size[0x8E] = 1;	// DUP15		0x8E	Requires 15 stack value, 0 imm values.
    // inst_size[0x8F] = 1;	// DUP16		0x8F	Requires 16 stack value, 0 imm values.

    // inst_size[0x90] = 1;	// SWAP1		0x90	Requires 2 stack value, 0 imm values.
    // inst_size[0x91] = 1;	// SWAP2		0x91	Requires 3 stack value, 0 imm values.
    // inst_size[0x92] = 1;	// SWAP3		0x92	Requires 4 stack value, 0 imm values.
    // inst_size[0x93] = 1;	// SWAP4		0x93	Requires 5 stack value, 0 imm values.
    // inst_size[0x94] = 1;	// SWAP5		0x94	Requires 6 stack value, 0 imm values.
    // inst_size[0x95] = 1;	// SWAP6		0x95	Requires 7 stack value, 0 imm values.
    // inst_size[0x96] = 1;	// SWAP7		0x96	Requires 8 stack value, 0 imm values.
    // inst_size[0x97] = 1;	// SWAP8		0x97	Requires 9 stack value, 0 imm values.
    // inst_size[0x98] = 1;	// SWAP9		0x98	Requires 10 stack value, 0 imm values.
    // inst_size[0x99] = 1;	// SWAP10		0x99	Requires 11 stack value, 0 imm values.
    // inst_size[0x9A] = 1;	// SWAP11		0x9A	Requires 12 stack value, 0 imm values.
    // inst_size[0x9B] = 1;	// SWAP12		0x9B	Requires 13 stack value, 0 imm values.
    // inst_size[0x9C] = 1;	// SWAP13		0x9C	Requires 14 stack value, 0 imm values.
    // inst_size[0x9D] = 1;	// SWAP14		0x9D	Requires 15 stack value, 0 imm values.
    // inst_size[0x9E] = 1;	// SWAP15		0x9E	Requires 16 stack value, 0 imm values.
    // inst_size[0x9F] = 1;	// SWAP16		0x9F	Requires 17 stack value, 0 imm values.

    // // logs don't have an influence on the evm
    // inst_size[0xA0] = 1;	// LOG0			0xA0	Requires 2 stack value, 0 imm values.
    // inst_size[0xA1] = 1;	// LOG1			0xA1	Requires 3 stack value, 0 imm values.
    // inst_size[0xA2] = 1;	// LOG2			0xA2	Requires 4 stack value, 0 imm values.
    // inst_size[0xA3] = 1;	// LOG3			0xA3	Requires 5 stack value, 0 imm values.
    // inst_size[0xA4] = 1;	// LOG4			0xA4	Requires 6 stack value, 0 imm values.

    // // subcontext related instructions
    // inst_size[0xF0] = 1;	// CREATE		0xF0	Requires 3 stack value, 0 imm values.
    // inst_size[0xF1] = 1;	// CALL			0xF1	Requires 7 stack value, 0 imm values.
    // inst_size[0xF2] = 1;	// CALLCODE		0xF2	Requires 7 stack value, 0 imm values.
    // inst_size[0xF3] = 1;	// RETURN		0xF3	Requires 2 stack value, 0 imm values.
    // inst_size[0xF4] = 1;	// DELEGATECALL	0xF4	Requires 6 stack value, 0 imm values.
    // inst_size[0xFA] = 1;	// STATICCALL	0xFA	Requires 6 stack value, 0 imm values.
    // inst_size[0xFD] = 1;	// REVERT		0xFD	Requires 2 stack value, 0 imm values.
    // inst_size[0xFE] = 1; 	// INVALID		0xFE	Requires 0 stack value, 0 imm values.
    // inst_size[0xFF] = 1;	// SELFDESTRUCT	0xFF	Requires 1 stack value, 0 imm values.

    function memory_read(bytes memory mem, uint256 start)
        private
        pure
        returns (bytes32 value)
    {
        for (uint256 i = 0; i < 32; i++) {
            value |= bytes32(bytes1(mem[start + i])) >> (i * 8);
        }

        return value;
    }

    function memory_write(
        bytes memory mem,
        uint256 start,
        bytes32 value
    ) private pure {
        for (uint256 i = 0; i < 32; i++) {
            mem[start + i] = bytes1(bytes32(value << (i * 8)));
        }
    }
}
