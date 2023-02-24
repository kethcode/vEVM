# vEVM

## example

https://goerli.basescan.org/address/0x4121E8574D28b2E5f5777F7B00d435Ee4886A5F4

```
await evm.execute("60016002600360005260AA60005560006000A07F000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F60206000527FA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C360206000A160206000F3");
```

returns

```
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
```

### 0x00 range - arithmetic ops

| Mnemonic   | OpCode | Status |
| ---------- | ------ | ------ |
| STOP       | 0x0    | Done   |
| ADD        | 0x1    | Done   |
| MUL        | 0x2    | Done   |
| SUB        | 0x3    | Done   |
| DIV        | 0x4    | Done   |
| SDIV       | 0x5    | Done   |
| MOD        | 0x6    | Done   |
| SMOD       | 0x7    | Done   |
| ADDMOD     | 0x8    | Done   |
| MULMOD     | 0x9    | Done   |
| EXP        | 0xa    | Done   |
| SIGNEXTEND | 0xb    | Done   |

### 0x10 range - comparison ops

| Mnemonic | OpCode | Status |
| -------- | ------ | ------ |
| LT       | 0x10   | Done   |
| GT       | 0x11   | Done   |
| SLT      | 0x12   | Done   |
| SGT      | 0x13   | Done   |
| EQ       | 0x14   | Done   |
| ISZERO   | 0x15   | Done   |
| AND      | 0x16   | Done   |
| OR       | 0x17   | Done   |
| XOR      | 0x18   | Done   |
| NOT      | 0x19   | Done   |
| BYTE     | 0x1a   | Done   |
| SHL      | 0x1b   | Done   |
| SHR      | 0x1c   | Done   |
| SAR      | 0x1d   | Done   |

### 0x20 range - crypto

| Mnemonic | OpCode | Status |
| -------- | ------ | ------ |
| SHA3     | 0x20   | Done   |

### 0x30 range - closure state

| Mnemonic       | OpCode | Status |
| -------------- | ------ | ------ |
| ADDRESS        | 0x30   | Done   |
| BALANCE        | 0x31   | Done   |
| ORIGIN         | 0x32   | Done   |
| CALLER         | 0x33   | Done   |
| CALLVALUE      | 0x34   | Done   |
| CALLDATALOAD   | 0x35   | Done   |
| CALLDATASIZE   | 0x36   | Done   |
| CALLDATACOPY   | 0x37   |        |
| CODESIZE       | 0x38   | Done   |
| CODECOPY       | 0x39   |        |
| GASPRICE       | 0x3a   | Done   |
| EXTCODESIZE    | 0x3b   | Done   |
| EXTCODECOPY    | 0x3c   |        |
| RETURNDATASIZE | 0x3d   |        |
| RETURNDATACOPY | 0x3e   |        |
| EXTCODEHASH    | 0x3f   |        |

### 0x40 range - block operations

| Mnemonic    | OpCode | Status |
| ----------- | ------ | ------ |
| BLOCKHASH   | 0x40   | Done   |
| COINBASE    | 0x41   | Done   |
| TIMESTAMP   | 0x42   | Done   |
| NUMBER      | 0x43   | Done   |
| DIFFICULTY  | 0x44   |        |
| RANDOM      | 0x44   |        |
| PREVRANDAO  | 0x44   |        |
| GASLIMIT    | 0x45   |        |
| CHAINID     | 0x46   | Done   |
| SELFBALANCE | 0x47   | Done   |
| BASEFEE     | 0x48   | Done   |

### 0x50 range - 'storage' and execution

| Mnemonic | OpCode | Status |
| -------- | ------ | ------ |
| POP      | 0x50   | Done   |
| MLOAD    | 0x51   | Done   |
| MSTORE   | 0x52   | Done   |
| MSTORE8  | 0x53   | Done   |
| SLOAD    | 0x54   | Done   |
| SSTORE   | 0x55   | Done   |
| JUMP     | 0x56   | Done   |
| JUMPI    | 0x57   | Done   |
| PC       | 0x58   | Done   |
| MSIZE    | 0x59   | Done   |
| GAS      | 0x5a   |        |
| JUMPDEST | 0x5b   | Done   |
| PUSH0    | 0x5f   |        |

### 0x60 range - pushes

| Mnemonic | OpCode | Status |
| -------- | ------ | ------ |
| PUSH1    | 0x60   | Done   |
| PUSH2    | 0x61   | Done   |
| PUSH3    | 0x62   | Done   |
| PUSH4    | 0x63   | Done   |
| PUSH5    | 0x64   | Done   |
| PUSH6    | 0x65   | Done   |
| PUSH7    | 0x66   | Done   |
| PUSH8    | 0x67   | Done   |
| PUSH9    | 0x68   | Done   |
| PUSH10   | 0x69   | Done   |
| PUSH11   | 0x6a   | Done   |
| PUSH12   | 0x6b   | Done   |
| PUSH13   | 0x6c   | Done   |
| PUSH14   | 0x6d   | Done   |
| PUSH15   | 0x6e   | Done   |
| PUSH16   | 0x6f   | Done   |
| PUSH17   | 0x70   | Done   |
| PUSH18   | 0x71   | Done   |
| PUSH19   | 0x72   | Done   |
| PUSH20   | 0x73   | Done   |
| PUSH21   | 0x74   | Done   |
| PUSH22   | 0x75   | Done   |
| PUSH23   | 0x76   | Done   |
| PUSH24   | 0x77   | Done   |
| PUSH25   | 0x78   | Done   |
| PUSH26   | 0x79   | Done   |
| PUSH27   | 0x7a   | Done   |
| PUSH28   | 0x7b   | Done   |
| PUSH29   | 0x7c   | Done   |
| PUSH30   | 0x7d   | Done   |
| PUSH31   | 0x7e   | Done   |
| PUSH32   | 0x7f   | Done   |

### 0x80 range - dups

| Mnemonic | OpCode | Status |
| -------- | ------ | ------ |
| DUP1     | 0x80   | Done   |
| DUP2     | 0x81   | Done   |
| DUP3     | 0x82   | Done   |
| DUP4     | 0x83   | Done   |
| DUP5     | 0x84   | Done   |
| DUP6     | 0x85   | Done   |
| DUP7     | 0x86   | Done   |
| DUP8     | 0x87   | Done   |
| DUP9     | 0x88   | Done   |
| DUP10    | 0x89   | Done   |
| DUP11    | 0x8a   | Done   |
| DUP12    | 0x8b   | Done   |
| DUP13    | 0x8c   | Done   |
| DUP14    | 0x8d   | Done   |
| DUP15    | 0x8e   | Done   |
| DUP16    | 0x8f   | Done   |

### 0x90 range - swaps

| Mnemonic | OpCode | Status |
| -------- | ------ | ------ |
| SWAP1    | 0x90   | Done   |
| SWAP2    | 0x91   | Done   |
| SWAP3    | 0x92   | Done   |
| SWAP4    | 0x93   | Done   |
| SWAP5    | 0x94   | Done   |
| SWAP6    | 0x95   | Done   |
| SWAP7    | 0x96   | Done   |
| SWAP8    | 0x97   | Done   |
| SWAP9    | 0x98   | Done   |
| SWAP10   | 0x99   | Done   |
| SWAP11   | 0x9a   | Done   |
| SWAP12   | 0x9b   | Done   |
| SWAP13   | 0x9c   | Done   |
| SWAP14   | 0x9d   | Done   |
| SWAP15   | 0x9e   | Done   |
| SWAP16   | 0x9f   | Done   |

### 0xa0 range - logging ops

| Mnemonic | OpCode | Status |
| -------- | ------ | ------ |
| LOG0     | 0xa0   | Done   |
| LOG1     | 0xa1   | Done   |
| LOG2     | 0xa2   | Done   |
| LOG3     | 0xa3   | Done   |
| LOG4     | 0xa4   | Done   |

### 0xb0 range

| Mnemonic | OpCode | Status |
| -------- | ------ | ------ |
| TLOAD    | 0xb3   |        |
| TSTORE   | 0xb4   |        |

### 0xf0 range - closures

| Mnemonic     | OpCode | Status |
| ------------ | ------ | ------ |
| CREATE       | 0xf0   |        |
| CALL         | 0xf1   |        |
| CALLCODE     | 0xf2   |        |
| RETURN       | 0xf3   | Done   |
| DELEGATECALL | 0xf4   |        |
| CREATE2      | 0xf5   |        |
| STATICCALL   | 0xfa   |        |
| REVERT       | 0xfd   |        |
| INVALID      | 0xfe   |        |
| SELFDESTRUCT | 0xff   | Done   |
