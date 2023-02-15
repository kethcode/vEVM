// SPDX-License-Identifier: mine
pragma solidity ^0.8.17;

//import "hardhat/console.sol";

/**
 * @title  Virtual EVM
 * @author Kethic <kethic@kethic.com> @kethcode
 * @notice Gasless Arbitrary Bytecode Execution
 */

contract vEVM {
    struct vEVMState {
        bytes code;
        bytes data;
        uint256 value;
        uint256 pc;
        bytes32[] stack;
        bytes mem;
        uint256 msize;
        bytes32[] storageKey;
        bytes32[] storageData;
        bytes[] logs;
        bytes output;
        bool running;
        bool reverting;
    }

    uint256 constant STACK_MAX_SIZE = 1024;

    function execute(
        bytes calldata bytecode,
        bytes calldata data,
        uint256 value
    ) external view returns (vEVMState memory) {
        vEVMState memory evm;

        evm.code = bytecode;
        evm.data = data;
        evm.value = value;

        evm.pc = 0;
        evm.msize = 0;
        evm.running = true;
        evm.reverting = false;

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
            } else if (opcode == 0x0B) {
                SIGNEXTEND(evm);
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
            } else if (opcode == 0x15) {
                ISZERO(evm);
            } else if (opcode == 0x16) {
                AND(evm);
            } else if (opcode == 0x17) {
                OR(evm);
            } else if (opcode == 0x18) {
                XOR(evm);
            } else if (opcode == 0x19) {
                NOT(evm);
            } else if (opcode == 0x1A) {
                BYTE(evm);
            } else if (opcode == 0x1B) {
                SHL(evm);
            } else if (opcode == 0x1C) {
                SHR(evm);
            } else if (opcode == 0x1D) {
                SAR(evm);
            } else if (opcode == 0x20) {
                SHA3(evm);
            } else if (opcode == 0x30) {
                ADDRESS(evm);
            } else if (opcode == 0x31) {
                BALANCE(evm);
            } else if (opcode == 0x32) {
                ORIGIN(evm);
            } else if (opcode == 0x33) {
                CALLER(evm);
            } else if (opcode == 0x34) {
                CALLVALUE(evm);
            } else if (opcode == 0x35) {
                CALLDATALOAD(evm);
            } else if (opcode == 0x36) {
                CALLDATASIZE(evm);
            } else if (opcode == 0x38) {
                CODESIZE(evm);
            } else if (opcode == 0x3A) {
                GASPRICE(evm);
            } else if (opcode == 0x3B) {
                EXTCODESIZE(evm);
            } else if (opcode == 0x40) {
                BLOCKHASH(evm);
            } else if (opcode == 0x41) {
                COINBASE(evm);
            } else if (opcode == 0x42) {
                TIMESTAMP(evm);
            } else if (opcode == 0x43) {
                NUMBER(evm);
            } else if (opcode == 0x46) {
                CHAINID(evm);
            } else if (opcode == 0x47) {
                SELFBALANCE(evm);
            } else if (opcode == 0x48) {
                BASEFEE(evm);
            } else if (opcode == 0x50) {
                POP(evm);
            } else if (opcode == 0x51) {
                MLOAD(evm);
            } else if (opcode == 0x52) {
                MSTORE(evm);
            } else if (opcode == 0x53) {
                MSTORE8(evm);
            } else if (opcode == 0x54) {
                SLOAD(evm);
            } else if (opcode == 0x55) {
                SSTORE(evm);
            } else if (opcode == 0x56) {
                JUMP(evm);
            } else if (opcode == 0x57) {
                JUMPI(evm);
            } else if (opcode == 0x58) {
                PC(evm);
            } else if (opcode == 0x59) {
                MSIZE(evm);
            } else if (opcode == 0x5B) {
                JUMPDEST(evm);
            } else if ((opcode >= 0x60) && (opcode <= 0x7F)) {
                // PUSHX
                uint256 data_size = uint8(opcode) - 0x5F;
                PUSH(evm, bytecode[evm.pc + 1:evm.pc + 1 + data_size]);
                evm.pc += data_size;
            } else if ((opcode >= 0x80) && (opcode <= 0x8F)) {
                // DUPX
                uint256 distance = uint8(opcode) - 0x7F;
                DUP(evm, distance);
            } else if ((opcode >= 0x90) && (opcode <= 0x9F)) {
                // SWAPX
                uint256 distance = uint8(opcode) - 0x8F;
                SWAP(evm, distance);
            } else if ((opcode >= 0xA0) && (opcode <= 0xA4)) {
                // LOGX
                uint256 topics = uint8(opcode) - 0xA0;
                LOG(evm, topics);
            } else if (opcode == 0xF3) {
                RETURN(evm);
            } else if (opcode == 0xFD) {
                REVERT(evm);
            } else if (opcode == 0xFF) {
                SELFDESTRUCT(evm);
            }

            if (evm.reverting) {}

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
            // TODO: REVERT
            //evm.RETURNDATA = bytes32(bytes("stack overflow"));
            //evm.running = false;
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
            // TODO: REVERT
            //evm.RETURNDATA = bytes32(bytes("stack underflow"));
            //evm.running = false;
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

    function expand_storage(
        bytes32[] memory keys,
        bytes32[] memory data,
        uint256 slots
    ) internal pure returns (bytes32[] memory, bytes32[] memory) {
        bytes32[] memory newkeys = new bytes32[](keys.length + slots);
        bytes32[] memory newdata = new bytes32[](data.length + slots);
        for (uint256 i = 0; i < keys.length; i++) {
            newkeys[i] = keys[i];
            newdata[i] = data[i];
        }
        return (newkeys, newdata);
    }

    function expand_mem_slots(bytes memory buf, uint256 slots)
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

	function expand_mem_bytes(bytes memory buf, uint256 bytes_needed)
        internal
        pure
        returns (bytes memory)
    {
        bytes memory newbuf = new bytes(buf.length + bytes_needed);
        for (uint256 i = 0; i < buf.length; i++) {
            newbuf[i] = buf[i];
        }
        return newbuf;
    }

    function expand_logs(bytes[] memory buf, uint256 slots)
        internal
        pure
        returns (bytes[] memory)
    {
        // console.log("expand_logs: buf.length: %s, slots: %s", buf.length, slots);
        bytes[] memory newbuf = new bytes[](buf.length + slots);
        // console.log("expand_logs: newbuf.length: %s, slots: %s", newbuf.length, slots);
        for (uint256 i = 0; i < buf.length; i++) {
            // console.log("expand_logs: i: %s", i);
            newbuf[i] = buf[i];
        }
        return newbuf;
    }

    function stack_read_as_uint256(bytes32 buf)
        internal
        pure
        returns (uint256)
    {
        uint256 offset = 0;
        for (uint256 i = 32; i > 0; i--) {
            if (bytes8(buf[i - 1]) == 0) {
                offset += 1;
            } else {
                break;
            }
        }

        bytes32 data32 = bytes32(0);
        for (uint256 i = 0; i < 32; i++) {
            if (i >= offset) {
                data32 |= bytes32(buf[i - offset]) >> (i * 8);
            }
        }
        return uint256(data32);
    }

    function memory_read_bytes(
        bytes memory mem,
        uint256 start,
        uint256 size
    ) private pure returns (bytes memory value) {
        value = new bytes(size);
        for (uint256 i = 0; i < size; i++) {
            value[i] = mem[start + i];
        }

        return value;
    }

    function memory_read_bytes32(bytes memory mem, uint256 start)
        private
        pure
        returns (bytes32 value)
    {
        for (uint256 i = 0; i < 32; i++) {
            value |= bytes32(bytes1(mem[start + i])) >> (i * 8);
        }

        return value;
    }

    function memory_write_bytes32(
        bytes memory mem,
        uint256 start,
        bytes32 value
    ) private pure {
        for (uint256 i = 0; i < 32; i++) {
            mem[start + i] = bytes1(bytes32(value << (i * 8)));
        }
    }

    function memory_write_bytes1(
        bytes memory mem,
        uint256 start,
        bytes1 value
    ) private pure {
        mem[start] = value;
    }

    function _revert(vEVMState memory evm, bytes memory message)
        internal
        pure
    {}

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
            stack_read_as_uint256(evm.stack[evm.stack.length - 1]) +
                stack_read_as_uint256(evm.stack[evm.stack.length - 2])
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x02] = 1;	// MUL			0x02	Requires 2 stack values, 0 imm values.
    function MUL(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] = bytes32(
            stack_read_as_uint256(evm.stack[evm.stack.length - 1]) *
                stack_read_as_uint256(evm.stack[evm.stack.length - 2])
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x03] = 1;	// SUB			0x03	Requires 2 stack values, 0 imm values.
    function SUB(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] = bytes32(
            stack_read_as_uint256(evm.stack[evm.stack.length - 1]) -
                stack_read_as_uint256(evm.stack[evm.stack.length - 2])
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x04] = 1;	// DIV			0x04	Requires 2 stack values, 0 imm values.
    function DIV(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] = bytes32(
            stack_read_as_uint256(evm.stack[evm.stack.length - 1]) /
                stack_read_as_uint256(evm.stack[evm.stack.length - 2])
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
            stack_read_as_uint256(evm.stack[evm.stack.length - 1]) %
                stack_read_as_uint256(evm.stack[evm.stack.length - 2])
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
                (stack_read_as_uint256(evm.stack[evm.stack.length - 1]) +
                    stack_read_as_uint256(evm.stack[evm.stack.length - 2])) %
                    stack_read_as_uint256(evm.stack[evm.stack.length - 3])
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
                (stack_read_as_uint256(evm.stack[evm.stack.length - 1]) *
                    stack_read_as_uint256(evm.stack[evm.stack.length - 2])) %
                    stack_read_as_uint256(evm.stack[evm.stack.length - 3])
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
            stack_read_as_uint256(evm.stack[evm.stack.length - 1]) **
                stack_read_as_uint256(evm.stack[evm.stack.length - 2])
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x0B] = 1;	// SIGNEXTEND	0x0B	Requires 2 stack values, 0 imm values.
    function SIGNEXTEND(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        uint256 byte_num = uint256(evm.stack[evm.stack.length - 1]);
        uint256 value = stack_read_as_uint256(evm.stack[evm.stack.length - 2]);

        uint256 result;
        assembly {
            result := signextend(byte_num, value)
        }

        evm.stack[evm.stack.length - 2] = bytes32(result);
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x10] = 1;	// LT			0x10	Requires 2 stack values, 0 imm values.
    function LT(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] = bytes32(
            uint256(
                stack_read_as_uint256(evm.stack[evm.stack.length - 1]) <
                    stack_read_as_uint256(evm.stack[evm.stack.length - 2])
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
                stack_read_as_uint256(evm.stack[evm.stack.length - 1]) >
                    stack_read_as_uint256(evm.stack[evm.stack.length - 2])
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
                stack_read_as_uint256(evm.stack[evm.stack.length - 1]) ==
                    stack_read_as_uint256(evm.stack[evm.stack.length - 2])
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
            uint256(
                stack_read_as_uint256(evm.stack[evm.stack.length - 1]) == 0
                    ? 1
                    : 0
            )
        );
    }

    // inst_size[0x16] = 1;	// AND			0x16	Requires 2 stack values, 0 imm values.
    function AND(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] =
            evm.stack[evm.stack.length - 1] &
            evm.stack[evm.stack.length - 2];
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x17] = 1;	// OR			0x17	Requires 2 stack values, 0 imm values.
    function OR(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] =
            evm.stack[evm.stack.length - 1] |
            evm.stack[evm.stack.length - 2];
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x18] = 1;	// XOR			0x18	Requires 2 stack values, 0 imm values.
    function XOR(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        evm.stack[evm.stack.length - 2] =
            evm.stack[evm.stack.length - 1] ^
            evm.stack[evm.stack.length - 2];
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x19] = 1;	// NOT			0x19	Requires 1 stack values, 0 imm values.
    function NOT(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 1)) {
            return;
        }
        evm.stack[evm.stack.length - 1] = ~evm.stack[evm.stack.length - 1];
    }

    // inst_size[0x1A] = 1;	// BYTE			0x1A	Requires 2 stack values, 0 imm values.
    function BYTE(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }
        uint256 index = uint256(evm.stack[evm.stack.length - 1]);
        evm.stack[evm.stack.length - 2] = bytes1(
            bytes32(evm.stack[evm.stack.length - 2] << (index * 8))
        );
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x1B] = 1;	// SHL			0x1B	Requires 2 stack values, 0 imm values.
    function SHL(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }

        uint256 shift = uint256(evm.stack[evm.stack.length - 1]);

        evm.stack[evm.stack.length - 2] =
            evm.stack[evm.stack.length - 2] <<
            shift;

        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x1C] = 1;	// SHR			0x1C	Requires 2 stack values, 0 imm values.
    function SHR(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }

        uint256 shift = uint256(evm.stack[evm.stack.length - 1]);

        evm.stack[evm.stack.length - 2] =
            evm.stack[evm.stack.length - 2] >>
            shift;

        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x1D] = 1;	// SAR			0x1D	Requires 2 stack values, 0 imm values.
    function SAR(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }

        uint256 shift = stack_read_as_uint256(evm.stack[evm.stack.length - 1]);
        int256 value = int256(
            stack_read_as_uint256(evm.stack[evm.stack.length - 2])
        );

        bytes32 result;
        assembly {
            result := sar(shift, value)
        }

        evm.stack[evm.stack.length - 2] = result;
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x20] = 1;	// SHA3			0x20	Requires 2 stack values, 0 imm values.
    function SHA3(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }

        // get the memory address to read from
        uint256 start_position = uint256(evm.stack[evm.stack.length - 1]);
        uint256 size = uint256(evm.stack[evm.stack.length - 2]);

        // how much memory do we expect is allocated?
        uint256 memory_needed = 0;

        // if we're reading from free memory, check if we need to expand it
        if ((start_position + size) >= evm.msize) {
            memory_needed = (start_position + size) - evm.msize;
        }

        // expand memory if needed
        if (memory_needed > 0) {
            // how many memory slots do we need to expand by?
            evm.mem = expand_mem_slots(
                evm.mem,
                (memory_needed / 32) + (memory_needed % 32 == 0 ? 0 : 1)
            );

            evm.msize = evm.mem.length;
        }

        // read value
        bytes memory to_be_hashed = memory_read_bytes(
            evm.mem,
            start_position,
            size
        );

        evm.stack[evm.stack.length - 2] = keccak256(to_be_hashed);

        evm.stack = reduce_stack(evm.stack, 1);
    }

    // // external data manupulation
    // inst_size[0x30] = 1;	// ADDRESS		0x30	Return vEVM address, or allow an override?
    function ADDRESS(vEVMState memory evm) internal view {
        if (stack_overflow(evm, 1)) {
            return;
        }
        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(
            uint256(uint160(address(this)))
        );
    }

    // inst_size[0x31] = 1;	// BALANCE		0x31	Requires 1 stack value, 0 imm values. Fetch an actual balance?
    function BALANCE(vEVMState memory evm) internal view {
        if (stack_underflow(evm, 1)) {
            return;
        }

        address target = address(
            uint160(uint256(evm.stack[evm.stack.length - 1]))
        );

        evm.stack[evm.stack.length - 1] = bytes32(target.balance);
    }

    // inst_size[0x32] = 1;	// ORIGIN		0x32	Use actual tx.origin?
    function ORIGIN(vEVMState memory evm) internal view {
        if (stack_overflow(evm, 1)) {
            return;
        }
        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(uint256(uint160(tx.origin)));
    }

    // inst_size[0x33] = 1;	// CALLER		0x33	Use actual msg.sender?
    // i assumed it would be the person starting the emulation, but maybe this needs to be configurable as well.
    function CALLER(vEVMState memory evm) internal view {
        if (stack_overflow(evm, 1)) {
            return;
        }
        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(uint256(uint160(msg.sender)));
    }

    // inst_size[0x34] = 1;	// CALLVALUE	0x34	Use actual msg.value? no, use value passed externally
    function CALLVALUE(vEVMState memory evm) internal pure {
        if (stack_overflow(evm, 1)) {
            return;
        }

        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(evm.value);
    }

    // inst_size[0x35] = 1;	// CALLDATALOAD	0x35	Requires 1 stack value, 0 imm values. Use actual msg.data? no, use value passed externally
    function CALLDATALOAD(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 1)) {
            return;
        }

        // do I revert if I read past the end of calldata, or do I append zeroes?
        // for now, i'm going to append zeroes

        // get the calldata position to read from
        uint256 start_position = stack_read_as_uint256(
            evm.stack[evm.stack.length - 1]
        );

        // how much data do we expect is present?
        uint256 data_needed = 0;

        if ((start_position + uint256(0x20)) >= evm.data.length) {
            data_needed = (start_position + uint256(0x20)) - evm.data.length;
        }

        // expand data if needed
        if (data_needed > 0) {
            // how many data slots do we need to expand by?
            evm.data = expand_mem_bytes(
                evm.data,
                data_needed
            );
        }

        // read value
        evm.stack[evm.stack.length - 1] = memory_read_bytes32(
            evm.data,
            start_position
        );
    }

    // inst_size[0x36] = 1;	// CALLDATASIZE	0x36	Requires 0 stack value, 0 imm values. Use actual msg.data? no, use value passed externally
    function CALLDATASIZE(vEVMState memory evm) internal pure {
        if (stack_overflow(evm, 1)) {
            return;
        }

		// console.log("CALLDATA:");
		// console.logBytes(evm.data);
		// console.log("CALLDATASIZE: %s", evm.data.length);
		
        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(evm.data.length);
    }

    // inst_size[0x37] = 1;	// CALLDATACOPY	0x37	Requires 3 stack values, 0 imm values. Use actual msg.data? no, use value passed externally
    function CALLDATACOPY(vEVMState memory evm) internal view {
        // if (stack_overflow(evm, 1)) {
        //     return;
        // }
        // evm.stack = expand_stack(evm.stack, 1);
        // evm.stack[evm.stack.length - 1] = bytes32(evm.data.length);
    }

    // inst_size[0x38] = 1;	// CODESIZE		0x38	Requires 0 stack value, 0 imm values. Use original size of input?
    function CODESIZE(vEVMState memory evm) internal pure {
        if (stack_overflow(evm, 1)) {
            return;
        }
        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(evm.code.length);
    }

    // inst_size[0x39] = 1;	// CODECOPY		0x39	Requires 3 stack values, 0 imm values. Use original input?
    // inst_size[0x3A] = 1;	// GASPRICE		0x3A	Use actual tx.gasprice?
    function GASPRICE(vEVMState memory evm) internal view {
        if (stack_overflow(evm, 1)) {
            return;
        }
        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(tx.gasprice);
    }

    // inst_size[0x3B] = 1;	// EXTCODESIZE	0x3B	Requires 1 stack value, 0 imm values. Use actual size of code?
    function EXTCODESIZE(vEVMState memory evm) internal view {
        if (stack_underflow(evm, 1)) {
            return;
        }

        address _addr = address(
            uint160(uint256(evm.stack[evm.stack.length - 1]))
        );
        uint256 size;
        assembly {
            size := extcodesize(_addr)
        }

        evm.stack[evm.stack.length - 1] = bytes32(size);
    }

    // inst_size[0x3C] = 1;	// EXTCODECOPY	0x3C	Requires 4 stack values, 0 imm values. Use actual code?
    // inst_size[0x3D] = 1;	// RETURNDATASIZE	0x3D	Requires 0 stack value, 0 imm values. Use actual size of return data?
    // inst_size[0x3E] = 1;	// RETURNDATACOPY	0x3E	Requires 3 stack values, 0 imm values. Use actual return data?
    // inst_size[0x3F] = 1;	// EXTCODEHASH	0x3F	Requires 1 stack value, 0 imm values. Use actual code hash?

    // // block information
    // inst_size[0x40] = 1;	// BLOCKHASH	0x40	Requires 1 stack value, 0 imm values. Use actual blockhash?
    function BLOCKHASH(vEVMState memory evm) internal view {
        if (stack_underflow(evm, 1)) {
            return;
        }

        uint256 block_num = uint256(evm.stack[evm.stack.length - 1]);
        evm.stack[evm.stack.length - 1] = blockhash(block_num);
    }

    // inst_size[0x41] = 1;	// COINBASE		0x41	Use actual block.coinbase?
    function COINBASE(vEVMState memory evm) internal view {
        if (stack_overflow(evm, 1)) {
            return;
        }
        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(
            uint256(uint160(address(block.coinbase)))
        );
    }

    // inst_size[0x42] = 1;	// TIMESTAMP	0x42	Use actual block.timestamp?
    function TIMESTAMP(vEVMState memory evm) internal view {
        if (stack_overflow(evm, 1)) {
            return;
        }
        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(block.timestamp);
    }

    // inst_size[0x43] = 1;	// NUMBER		0x43	Use actual block.number?
    function NUMBER(vEVMState memory evm) internal view {
        if (stack_overflow(evm, 1)) {
            return;
        }
        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(block.number);
    }

    // inst_size[0x44] = 1;	// PREVRANDAO	0x44	Use actual block.PREVRANDAO?
    // inst_size[0x45] = 1;	// GASLIMIT		0x45	Use actual block.gaslimit?
    // inst_size[0x46] = 1;	// CHAINID		0x46	Use actual block.chainid?
    function CHAINID(vEVMState memory evm) internal view {
        if (stack_overflow(evm, 1)) {
            return;
        }

        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(block.chainid);
    }

    // inst_size[0x47] = 1;	// SELFBALANCE	0x47	Same as calling BALANCE on vEVM address, but cheaper
    function SELFBALANCE(vEVMState memory evm) internal view {
        if (stack_overflow(evm, 1)) {
            return;
        }
        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(address(this).balance);
    }

    // inst_size[0x48] = 1;	// BASEFEE		0x48	Use actual basefee?
    function BASEFEE(vEVMState memory evm) internal view {
        if (stack_overflow(evm, 1)) {
            return;
        }

        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(block.basefee);
    }

    // // memory manipluation
    // inst_size[0x50] = 1;	// POP			0x50	Requires 1 stack value, 0 imm values.
    function POP(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 1)) {
            return;
        }
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x51] = 1;	// MLOAD		0x51	Requires 1 stack value, 0 imm values.
    function MLOAD(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 1)) {
            return;
        }
        // get the memory address to read from
        uint256 start_position = stack_read_as_uint256(
            evm.stack[evm.stack.length - 1]
        );

        // how much memory do we expect is allocated?
        uint256 memory_needed = 0;

        // if we're readnig from free memory, check if we need to expand it
        if ((start_position + uint256(0x20)) >= evm.msize) {
            memory_needed = (start_position + uint256(0x20)) - evm.msize;
        }

        // expand memory if needed
        if (memory_needed > 0) {
            // how many memory slots do we need to expand by?
            evm.mem = expand_mem_slots(
                evm.mem,
                (memory_needed / 32) + (memory_needed % 32 == 0 ? 0 : 1)
            );
            evm.msize = evm.mem.length;
        }

        // read value
        evm.stack[evm.stack.length - 1] = memory_read_bytes32(
            evm.mem,
            start_position
        );
    }

    // inst_size[0x52] = 1;	// MSTORE		0x52	Requires 2 stack values, 0 imm values.
    function MSTORE(vEVMState memory evm) internal pure {
        // do we have enough values on the stack?
        if (stack_underflow(evm, 2)) {
            return;
        }

        // get the memory address to write to
        uint256 start_position = stack_read_as_uint256(
            evm.stack[evm.stack.length - 1]
        );

        // how much memory do we need?
        uint256 memory_needed = 0;

        // if we're writing to free memory, check if we need to expand it
        if ((start_position + uint256(0x20)) >= evm.msize) {
            memory_needed = (start_position + uint256(0x20)) - evm.msize;
        }

        // expand memory if needed
        if (memory_needed > 0) {
            // how many memory slots do we need to expand by?
            evm.mem = expand_mem_slots(
                evm.mem,
                (memory_needed / 32) + (memory_needed % 32 == 0 ? 0 : 1)
            );
            evm.msize = evm.mem.length;
        }

        // store value
        memory_write_bytes32(
            evm.mem,
            start_position,
            bytes32(stack_read_as_uint256(evm.stack[evm.stack.length - 2]))
        );

        // pop stack
        evm.stack = reduce_stack(evm.stack, 2);
    }

    // inst_size[0x53] = 1;	// MSTORE8		0x53	Requires 2 stack values, 0 imm values.
    function MSTORE8(vEVMState memory evm) internal pure {
        // do we have enough values on the stack?
        if (stack_underflow(evm, 2)) {
            return;
        }

        // get the memory address to write to
        uint256 start_position = uint256(evm.stack[evm.stack.length - 1]);

        // how much memory do we need?
        uint256 memory_needed = 0;

        // if we're writing to free memory, check if we need to expand it
        if ((start_position + uint256(0x01)) >= evm.msize) {
            memory_needed = (start_position + uint256(0x01)) - evm.msize;
        }

        // expand memory if needed
        if (memory_needed > 0) {
            // how many memory slots do we need to expand by?
            evm.mem = expand_mem_slots(
                evm.mem,
                (memory_needed / 32) + (memory_needed % 32 == 0 ? 0 : 1)
            );

            evm.msize = evm.mem.length;
        }

        // store value
        memory_write_bytes1(
            evm.mem,
            start_position,
            bytes1(bytes32(evm.stack[evm.stack.length - 2] << (31 * 8)))
        );

        // pop stack
        evm.stack = reduce_stack(evm.stack, 2);
    }

    // the storage hashmap is emulated through mached-index arrays in memory
    // we look over storageKey until we find a match, then use that index to
    // look up the corresponding value in storageData.

    // inst_size[0x54] = 1;	// SLOAD		0x54	Requires 1 stack value, 0 imm values.
    function SLOAD(vEVMState memory evm) internal pure {
        // do we have enough values on the stack?
        if (stack_underflow(evm, 1)) {
            return;
        }

        bool index_found = false;

        if (evm.storageKey.length == 0) {
            // no storage keys have been set yet
            // so we place zero on the stack.  empty storage contains zero.
            evm.stack[evm.stack.length - 1] = bytes32(0);
        } else {
            // get the index of the storage key we're looking for
            uint256 storage_index = 0;
            for (uint256 i = 0; i < evm.storageKey.length; i++) {
                if (evm.storageKey[i] == evm.stack[evm.stack.length - 1]) {
                    storage_index = i;
                    index_found = true;
                    break;
                }
            }

            // did we find something?
            if (index_found == false) {
                // nope.  we didn't find anything.
                // so we place zero on the stack.  empty storage contains zero.
                evm.stack[evm.stack.length - 1] = bytes32(0);
            } else {
                // we found something.  place it on the stack.
                evm.stack[evm.stack.length - 1] = evm.storageData[
                    storage_index
                ];
            }
        }
    }

    // inst_size[0x55] = 1;	// SSTORE		0x55	Requires 2 stack values, 0 imm values.
    function SSTORE(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }

        bytes32 key = evm.stack[evm.stack.length - 1];
        bytes32 value = evm.stack[evm.stack.length - 2];

        // check if the storage is already allocated
        uint256 storage_index = 0;
        bool index_found = false;
        for (uint256 i = 0; i < evm.storageKey.length; i++) {
            if (evm.storageKey[i] == key) {
                storage_index = i;
                index_found = true;
                break;
            }
        }

        // did we find something?
        if (index_found == false) {
            // nope.  we didn't find anything.
            // so we add the key and value to the end of the arrays.
            (evm.storageKey, evm.storageData) = expand_storage(
                evm.storageKey,
                evm.storageData,
                1
            );
            evm.storageKey[evm.storageKey.length - 1] = key;
            evm.storageData[evm.storageData.length - 1] = value;
        } else {
            // we found something.  update it.
            evm.storageData[storage_index] = value;
        }

        // pop stack
        evm.stack = reduce_stack(evm.stack, 2);
    }

    // inst_size[0x56] = 1;	// JUMP			0x56	Requires 1 stack value, 0 imm values.
    function JUMP(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 1)) {
            return;
        }

        // get the jump destination
        uint256 jump_dest = uint256(evm.stack[evm.stack.length - 1]);

        // check if the jump destination is valid, JUMPDEST 0x5b
        if (evm.code[jump_dest] != 0x5b) {
            // invalid jump destination
            return;
        }

        // jump to the destination
        // -1 because the main loop increments
        evm.pc = jump_dest - 1;

        // pop stack
        evm.stack = reduce_stack(evm.stack, 1);
    }

    // inst_size[0x57] = 1;	// JUMPI		0x57	Requires 2 stack values, 0 imm values.
    function JUMPI(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }

        // get the jump destination
        uint256 jump_dest = uint256(evm.stack[evm.stack.length - 1]);
        uint256 conditional = uint256(evm.stack[evm.stack.length - 2]);

        // check if the jump destination is valid, JUMPDEST 0x5b
        if (evm.code[jump_dest] != 0x5b) {
            // invalid jump destination
            return;
        }

        // jump to the destination
        // -1 because the main loop increments
        if (conditional == 1) {
            evm.pc = jump_dest - 1;
        }

        // pop stack
        evm.stack = reduce_stack(evm.stack, 2);
    }

    // inst_size[0x58] = 1;	// PC			0x58	Requires 0 stack value, 0 imm values.
    function PC(vEVMState memory evm) internal pure {
        if (stack_overflow(evm, 1)) {
            return;
        }
        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(evm.pc);
    }

    // inst_size[0x59] = 1;	// MSIZE		0x59	Requires 0 stack value, 0 imm values.
    function MSIZE(vEVMState memory evm) internal pure {
        if (stack_overflow(evm, 1)) {
            return;
        }
        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(evm.mem.length);
    }

    // inst_size[0x5A] = 1;	// GAS			0x5A	Requires 0 stack value, 0 imm values. no messing with this for now.
    // inst_size[0x5B] = 1;	// JUMPDEST		0x5B	Requires 0 stack value, 0 imm values. basically a NOP
    function JUMPDEST(vEVMState memory evm) internal pure {
        // do nothing
    }

    // // stack manipluation

    // Generalized PUSH instruction
    function PUSH(vEVMState memory evm, bytes memory data) internal pure {
        if (stack_overflow(evm, 1)) {
            return;
        }

        bytes32 data32 = bytes32(0);
        for (uint256 i = 0; i < data.length; i++) {
            data32 |= bytes32(data[i]) >> (i * 8);
        }

        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = bytes32(data32);
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

    // Generalized DUP instruction
    function DUP(vEVMState memory evm, uint256 distance) internal pure {
        if (stack_overflow(evm, 1)) {
            return;
        }
        if (stack_underflow(evm, distance)) {
            return;
        }

        bytes32 data_to_dup = evm.stack[evm.stack.length - distance];

        evm.stack = expand_stack(evm.stack, 1);
        evm.stack[evm.stack.length - 1] = data_to_dup;
    }

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

    // Generalized DUP instruction
    function SWAP(vEVMState memory evm, uint256 distance) internal pure {
        if (stack_underflow(evm, distance)) {
            return;
        }

        // lets just use the actual damn opcode this time
        (
            evm.stack[evm.stack.length - 1],
            evm.stack[evm.stack.length - 1 - distance]
        ) = (
            evm.stack[evm.stack.length - 1 - distance],
            evm.stack[evm.stack.length - 1]
        );
    }

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

    // logs don't have an influence on the evm.
    // however, they have their own data space we need to manage.
    // specifically, logs go in the receipt root, which is a merkle tree
    // i'm... not doing that for this.  we're going witha delimited memory buffer.
    // every call is an atomic transaction, so for the purposes of vEVM,

    // address
    // topics, the firstof  which may be the has of the function signature
    // irrelevant; that's solidity level stuff. here's it's just another bytes32 topic
    // data

    // Generalized LOG instruction
    function LOG(vEVMState memory evm, uint256 num_topics) internal view {
        if (stack_underflow(evm, 2 + num_topics)) {
            // console.log("LOG stack_underflow");
            return;
        }

        bytes32 addr = bytes32(uint256(uint160(address(this))));
        // console.log("LOG addr:");
        // console.logBytes32(addr);

        // console.log("LOG topics:");
        bytes32[] memory topics = new bytes32[](num_topics);
        for (uint256 i = 0; i < num_topics; i++) {
            topics[i] = evm.stack[evm.stack.length - 3 - i];
            // console.logBytes32(topics[i]);
        }

        // data start and size
        uint256 start = stack_read_as_uint256(evm.stack[evm.stack.length - 1]);
        uint256 size = stack_read_as_uint256(evm.stack[evm.stack.length - 2]);

        // console.log("LOG start:", start);
        // console.log("LOG size:", size);

        bytes memory log_data = new bytes(size);
        log_data = memory_read_bytes(evm.mem, start, size);

        // console.log("LOG log_data:");
        // console.logBytes(log_data);

        // console.log("LOG evm.logs.length:", evm.logs.length);
        evm.logs = expand_logs(evm.logs, 1);
        // console.log("LOG evm.logs.length:", evm.logs.length);

        // console.log("LOG evm.logs:");
        // for(uint256 i = 0; i < evm.logs.length; i++)
        // {
        // 	console.logBytes(evm.logs[i]);
        // }

        uint256 log_size = 32 + 32 * num_topics + size;
        evm.logs[evm.logs.length - 1] = new bytes(log_size);
        evm.logs[evm.logs.length - 1] = abi.encodePacked(
            addr,
            topics,
            log_data
        );
        // console.log("LOG evm.logs:");
        // for(uint256 i = 0; i < evm.logs.length; i++)
        // {
        // 	console.logBytes(evm.logs[i]);
        // }

        evm.stack = reduce_stack(evm.stack, 2 + num_topics);
    }

    // inst_size[0xA0] = 1;	// LOG0			0xA0	Requires 2 stack value, 0 imm values.
    // inst_size[0xA1] = 1;	// LOG1			0xA1	Requires 3 stack value, 0 imm values.
    // inst_size[0xA2] = 1;	// LOG2			0xA2	Requires 4 stack value, 0 imm values.
    // inst_size[0xA3] = 1;	// LOG3			0xA3	Requires 5 stack value, 0 imm values.
    // inst_size[0xA4] = 1;	// LOG4			0xA4	Requires 6 stack value, 0 imm values.

    // // subcontext related instructions
    // inst_size[0xF0] = 1;	// CREATE		0xF0	Requires 3 stack value, 0 imm values.
    // function CREATE(vEVMState memory evm) internal pure {
    //     if (stack_underflow(evm, 3)) {
    //         return;
    //     }

    // 	uint256 value = stack_read_as_uint256(evm.stack[evm.stack.length - 1]);
    //     uint256 start = stack_read_as_uint256(evm.stack[evm.stack.length - 2]);
    //     uint256 size = stack_read_as_uint256(evm.stack[evm.stack.length - 3]);

    // 	// do the memory expansion

    // 	// get address, nonce, RPL encode

    // 	// ok, not doing that tonight.
    //     evm.output = memory_read_bytes(evm.mem, start, size);
    //     evm.stack = reduce_stack(evm.stack, 3);
    //     evm.running = false;
    // }
    // inst_size[0xF1] = 1;	// CALL			0xF1	Requires 7 stack value, 0 imm values.
    // inst_size[0xF2] = 1;	// CALLCODE		0xF2	Requires 7 stack value, 0 imm values.
    // inst_size[0xF3] = 1;	// RETURN		0xF3	Requires 2 stack value, 0 imm values.
    function RETURN(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }

        uint256 start = stack_read_as_uint256(evm.stack[evm.stack.length - 1]);
        uint256 size = stack_read_as_uint256(evm.stack[evm.stack.length - 2]);

        evm.output = memory_read_bytes(evm.mem, start, size);
        evm.stack = reduce_stack(evm.stack, 2);
        evm.running = false;
    }

    // inst_size[0xF4] = 1;	// DELEGATECALL	0xF4	Requires 6 stack value, 0 imm values.
    // inst_size[0xFA] = 1;	// STATICCALL	0xFA	Requires 6 stack value, 0 imm values.
    // inst_size[0xFD] = 1;	// REVERT		0xFD	Requires 2 stack value, 0 imm values.
    function REVERT(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 2)) {
            return;
        }

        uint256 start = stack_read_as_uint256(evm.stack[evm.stack.length - 1]);
        uint256 size = stack_read_as_uint256(evm.stack[evm.stack.length - 2]);

        evm.output = memory_read_bytes(evm.mem, start, size);
        evm.stack = reduce_stack(evm.stack, 2);
        evm.reverting = true;
        evm.running = false;
    }

    // inst_size[0xFE] = 1; 	// INVALID		0xFE	Requires 0 stack value, 0 imm values.
    // inst_size[0xFF] = 1;	// SELFDESTRUCT	0xFF	Requires 1 stack value, 0 imm values.
    function SELFDESTRUCT(vEVMState memory evm) internal pure {
        if (stack_underflow(evm, 1)) {
            return;
        }

        evm.stack = reduce_stack(evm.stack, 1);
        evm.code = new bytes(0);
        evm.running = false;
    }

    constructor() {}

    // these were just for testing.  disable them for production
    // fallback() external payable {}
    // receive() external payable {}
}
