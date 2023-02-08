# vEVM

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
| SIGNEXTEND | 0xb    |        |

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
| SAR      | 0x1d   |        |

### 0x20 range - crypto

| Mnemonic | OpCode | Status |
| -------- | ------ | ------ |
| SHA3     | 0x20   | Done   |

### 0x30 range - closure state

| Mnemonic       | OpCode | Status |
| -------------- | ------ | ------ |
| ADDRESS        | 0x30   |        |
| BALANCE        | 0x31   |        |
| ORIGIN         | 0x32   |        |
| CALLER         | 0x33   |        |
| CALLVALUE      | 0x34   |        |
| CALLDATALOAD   | 0x35   |        |
| CALLDATASIZE   | 0x36   |        |
| CALLDATACOPY   | 0x37   |        |
| CODESIZE       | 0x38   |        |
| CODECOPY       | 0x39   |        |
| GASPRICE       | 0x3a   |        |
| EXTCODESIZE    | 0x3b   |        |
| EXTCODECOPY    | 0x3c   |        |
| RETURNDATASIZE | 0x3d   |        |
| RETURNDATACOPY | 0x3e   |        |
| EXTCODEHASH    | 0x3f   |        |

### 0x40 range - block operations

| Mnemonic    | OpCode | Status |
| ----------- | ------ | ------ |
| BLOCKHASH   | 0x40   |        |
| COINBASE    | 0x41   |        |
| TIMESTAMP   | 0x42   |        |
| NUMBER      | 0x43   |        |
| DIFFICULTY  | 0x44   |        |
| RANDOM      | 0x44   |        |
| PREVRANDAO  | 0x44   |        |
| GASLIMIT    | 0x45   |        |
| CHAINID     | 0x46   |        |
| SELFBALANCE | 0x47   |        |
| BASEFEE     | 0x48   |        |

### 0x50 range - 'storage' and execution

| Mnemonic | OpCode | Status |
| -------- | ------ | ------ |
| POP      | 0x50   | Done   |
| MLOAD    | 0x51   | Done   |
| MSTORE   | 0x52   | Done   |
| MSTORE8  | 0x53   | Done   |
| SLOAD    | 0x54   | Done   |
| SSTORE   | 0x55   | Done   |
| JUMP     | 0x56   |        |
| JUMPI    | 0x57   |        |
| PC       | 0x58   |        |
| MSIZE    | 0x59   | Done   |
| GAS      | 0x5a   |        |
| JUMPDEST | 0x5b   |        |
| PUSH0    | 0x5f   |        |

### 0x60 range - pushes

| Mnemonic | OpCode      | Status |
| -------- | ----------- | ------ |
| PUSH1    | 0x60 + iota | Done   |
| PUSH2    |             | Done   |
| PUSH3    |             | Done   |
| PUSH4    |             | Done   |
| PUSH5    |             | Done   |
| PUSH6    |             | Done   |
| PUSH7    |             | Done   |
| PUSH8    |             | Done   |
| PUSH9    |             | Done   |
| PUSH10   |             | Done   |
| PUSH11   |             | Done   |
| PUSH12   |             | Done   |
| PUSH13   |             | Done   |
| PUSH14   |             | Done   |
| PUSH15   |             | Done   |
| PUSH16   |             | Done   |
| PUSH17   |             | Done   |
| PUSH18   |             | Done   |
| PUSH19   |             | Done   |
| PUSH20   |             | Done   |
| PUSH21   |             | Done   |
| PUSH22   |             | Done   |
| PUSH23   |             | Done   |
| PUSH24   |             | Done   |
| PUSH25   |             | Done   |
| PUSH26   |             | Done   |
| PUSH27   |             | Done   |
| PUSH28   |             | Done   |
| PUSH29   |             | Done   |
| PUSH30   |             | Done   |
| PUSH31   |             | Done   |
| PUSH32   |             | Done   |

### 0x80 range - dups

| Mnemonic           | OpCode | Status |
| ------------------ | ------ | ------ |
| DUP1 = 0x80 + iota |        | Done   |
| DUP2               |        | Done   |
| DUP3               |        | Done   |
| DUP4               |        | Done   |
| DUP5               |        | Done   |
| DUP6               |        | Done   |
| DUP7               |        | Done   |
| DUP8               |        | Done   |
| DUP9               |        | Done   |
| DUP10              |        | Done   |
| DUP11              |        | Done   |
| DUP12              |        | Done   |
| DUP13              |        | Done   |
| DUP14              |        | Done   |
| DUP15              |        | Done   |
| DUP16              |        | Done   |

### 0x90 range - swaps

| Mnemonic            | OpCode | Status |
| ------------------- | ------ | ------ |
| SWAP1 = 0x90 + iota |        |        |
| SWAP2               |        |        |
| SWAP3               |        |        |
| SWAP4               |        |        |
| SWAP5               |        |        |
| SWAP6               |        |        |
| SWAP7               |        |        |
| SWAP8               |        |        |
| SWAP9               |        |        |
| SWAP10              |        |        |
| SWAP11              |        |        |
| SWAP12              |        |        |
| SWAP13              |        |        |
| SWAP14              |        |        |
| SWAP15              |        |        |
| SWAP16              |        |        |

### 0xa0 range - logging ops

| Mnemonic | OpCode      | Status |
| -------- | ----------- | ------ |
| LOG0     | 0xa0 + iota |
| LOG1     |             |        |
| LOG2     |             |        |
| LOG3     |             |        |
| LOG4     |             |        |

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
| SELFDESTRUCT | 0xff   |        |
