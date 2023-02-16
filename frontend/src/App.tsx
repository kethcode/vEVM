// import { ConnectKitButton } from "connectkit";
import { useAccount } from "wagmi";

// import { Account } from "./components/Account";
import { EVMResults } from "./components/EVMResults";

import { useState } from "react";

import libpcre2 from '@ofjansen/pcre2-wasm';

import "./App.css";

export function App() {
  //const { isConnected } = useAccount();

  const [textareaBytecode, setTextareaBytecode] = useState("");
  const [textareaAssembly, setTextareaAssembly] = useState("");

  const [textCode, setTextCode] = useState("");
  const [textData, setTextData] = useState("");
  const [textValue, setTextValue] = useState("");
  const [bytecode, setBytecode] = useState("");
  const [data, setData] = useState("");
  const [value, setValue] = useState("");

  const sendParamters = () => {
    setBytecode(textCode);
    setData(textData);
    setValue(textValue);
  };

  const bytecodeToAssembly = (bytecode: string) => {

	const assembly = PCRE2.replace("I am digits 1234 0000","5678", "g");
	console.log(assembly);

    // const regBinarySearch =
    //   /${STOP:+00}${ADD:+01}${MUL:+02}${SUB:+03}${DIV:+04}${SDIV:+05}${MOD:+06}${SMOD:+07}${ADDMOD:+08}${MULMOD:+09}${EXP:+0a}${SIGNEXTEND:+0b}${LT:+10}${GT:+11}${SLT:+12}${SGT:+13}${EQ:+14}${ISZERO:+15}${AND:+16}${OR:+17}${XOR:+18}${NOT:+19}${BYTE:+1a}${SHL:+1b}${SHR:+1c}${SAR:+1d}${KECCAK:+20}${ADDRESS:+30}${BALANCE:+31}${ORIGIN:+32}${CALLER:+33}${CALLVALUE:+34}${CALLDATALOAD:+35}${CALLDATASIZE:+36}${CALLDATACOPY:+37}${CODESIZE:+38}${CODECOPY:+39}${GASPRICE:+3a}${EXTCODESIZE:+3b}${EXTCODECOPY:+3c}${RETURNDATASIZE:+3d}${RETURNDATACOPY:+3e}${EXTCODEHASH:+3f}${BLOCKHASH:+40}${COINBASE:+41}${TIMESTAMP:+42}${NUMBER:+43}${DIFFICULTY:+44}${GASLIMIT:+45}${CHAINID:+46}${SELFBALANCE:+47}${BASEFEE:+48}${POP:+50}${MLOAD:+51}${MSTORE:+52}${MSTORE8:+53}${SLOAD:+54}${SSTORE:+55}${JUMP:+56}${JUMPI:+57}${PC:+58}${MSIZE:+59}${GAS:+5a}${JUMPDEST:+5b}${PUSH1:+60}${DATA1}${PUSH2:+61}${DATA2}${PUSH3:+62}${DATA3}${PUSH4:+63}${DATA4}${PUSH5:+64}${DATA5}${PUSH6:+65}${DATA6}${PUSH7:+66}${DATA7}${PUSH8:+67}${DATA8}${PUSH9:+68}${DATA9}${PUSH10:+69}${DATA10}${PUSH11:+6a}${DATA11}${PUSH12:+6b}${DATA12}${PUSH13:+6c}${DATA13}${PUSH14:+6d}${DATA14}${PUSH15:+6e}${DATA15}${PUSH16:+6f}${DATA16}${PUSH17:+70}${DATA17}${PUSH18:+71}${DATA18}${PUSH19:+72}${DATA19}${PUSH20:+73}${DATA20}${PUSH21:+74}${DATA21}${PUSH22:+75}${DATA22}${PUSH23:+76}${DATA23}${PUSH24:+77}${DATA24}${PUSH25:+78}${DATA25}${PUSH26:+79}${DATA26}${PUSH27:+7a}${DATA27}${PUSH28:+7b}${DATA28}${PUSH29:+7c}${DATA29}${PUSH30:+7d}${DATA30}${PUSH31:+7e}${DATA31}${PUSH32:+7f}${DATA32}${DUP1:+80}${DUP2:+81}${DUP3:+82}${DUP4:+83}${DUP5:+84}${DUP6:+85}${DUP7:+86}${DUP8:+87}${DUP9:+88}${DUP10:+89}${DUP11:+8a}${DUP12:+8b}${DUP13:+8c}${DUP14:+8d}${DUP15:+8e}${DUP16:+8f}${SWAP1:+90}${SWAP2:+91}${SWAP3:+92}${SWAP4:+93}${SWAP5:+94}${SWAP6:+95}${SWAP7:+96}${SWAP8:+97}${SWAP9:+98}${SWAP10:+99}${SWAP11:+9a}${SWAP12:+9b}${SWAP13:+9c}${SWAP14:+9d}${SWAP15:+9e}${SWAP16:+9f}${LOG0:+a0}${LOG1:+a1}${LOG2:+a2}${LOG3:+a3}${LOG4:+a4}${CREATE:+f0}${CALL:+f1}${CALLCODE:+f2}${RETURN:+f3}${DELEGATECALL:+f4}${CREATE2:+f5}${STATICCALL:+fa}${REVERT:+fd}${INVALID:+fe}${SELFDESTRUCT:+ff}/g;
    // //const regBinaryReplace = /${STOP:+STOP\n}${ADD:+ADD\n}${MUL:+MUL\n}${SUB:+SUB\n}${DIV:+DIV\n}${SDIV:+SDIV\n}${MOD:+MOD\n}${SMOD:+SMOD\n}${ADDMOD:+ADDMOD\n}${MULMOD:+MULMOD\n}${EXP:+EXP\n}${SIGNEXTEND:+SIGNEXTEND\n}${LT:+LT\n}${GT:+GT\n}${SLT:+SLT\n}${SGT:+SGT\n}${EQ:+EQ\n}${ISZERO:+ISZERO\n}${AND:+AND\n}${OR:+OR\n}${XOR:+XOR\n}${NOT:+NOT\n}${BYTE:+BYTE\n}${SHL:+SHL\n}${SHR:+SHR\n}${SAR:+SAR\n}${SHA3:+SHA3\n}${ADDRESS:+ADDRESS\n}${BALANCE:+BALANCE\n}${ORIGIN:+ORIGIN\n}${CALLER:+CALLER\n}${CALLVALUE:+CALLVALUE\n}${CALLDATALOAD:+CALLDATALOAD\n}${CALLDATASIZE:+CALLDATASIZE\n}${CALLDATACOPY:+CALLDATACOPY\n}${CODESIZE:+CODESIZE\n}${CODECOPY:+CODECOPY\n}${GASPRICE:+GASPRICE\n}${EXTCODESIZE:+EXTCODESIZE\n}${EXTCODECOPY:+EXTCODECOPY\n}${RETURNDATASIZE:+RETURNDATASIZE\n}${RETURNDATACOPY:+RETURNDATACOPY\n}${EXTCODEHASH:+EXTCODEHASH\n}${BLOCKHASH:+BLOCKHASH\n}${COINBASE:+COINBASE\n}${TIMESTAMP:+TIMESTAMP\n}${NUMBER:+NUMBER\n}${DIFFICULTY:+DIFFICULTY\n}${GASLIMIT:+GASLIMIT\n}${CHAINID:+CHAINID\n}${SELFBALANCE:+SELFBALANCE\n}${BASEFEE:+BASEFEE\n}${POP:+POP\n}${MLOAD:+MLOAD\n}${MSTORE:+MSTORE\n}${MSTORE8:+MSTORE8\n}${SLOAD:+SLOAD\n}${SSTORE:+SSTORE\n}${JUMP:+JUMP\n}${JUMPI:+JUMPI\n}${PC:+PC\n}${MSIZE:+MSIZE\n}${GAS:+GAS\n}${JUMPDEST:+JUMPDEST\n}${PUSH1:+PUSH1 ${PUSH1_DATA}\n}${PUSH2:+PUSH2 ${PUSH2_DATA}\n}${PUSH3:+PUSH3 ${PUSH3_DATA}\n}${PUSH4:+PUSH4 ${PUSH4_DATA}\n}${PUSH5:+PUSH5 ${PUSH5_DATA}\n}${PUSH6:+PUSH6 ${PUSH6_DATA}\n}${PUSH7:+PUSH7 ${PUSH7_DATA}\n}${PUSH8:+PUSH8 ${PUSH8_DATA}\n}${PUSH9:+PUSH9 ${PUSH9_DATA}\n}${PUSH10:+PUSH10 ${PUSH10_DATA}\n}${PUSH11:+PUSH11 ${PUSH11_DATA}\n}${PUSH12:+PUSH12 ${PUSH12_DATA}\n}${PUSH13:+PUSH13 ${PUSH13_DATA}\n}${PUSH14:+PUSH14 ${PUSH14_DATA}\n}${PUSH15:+PUSH15 ${PUSH15_DATA}\n}${PUSH16:+PUSH16 ${PUSH16_DATA}\n}${PUSH17:+PUSH17 ${PUSH17_DATA}\n}${PUSH18:+PUSH18 ${PUSH18_DATA}\n}${PUSH19:+PUSH19 ${PUSH19_DATA}\n}${PUSH20:+PUSH20 ${PUSH20_DATA}\n}${PUSH21:+PUSH21 ${PUSH21_DATA}\n}${PUSH22:+PUSH22 ${PUSH22_DATA}\n}${PUSH23:+PUSH23 ${PUSH23_DATA}\n}${PUSH24:+PUSH24 ${PUSH24_DATA}\n}${PUSH25:+PUSH25 ${PUSH25_DATA}\n}${PUSH26:+PUSH26 ${PUSH26_DATA}\n}${PUSH27:+PUSH27 ${PUSH27_DATA}\n}${PUSH28:+PUSH28 ${PUSH28_DATA}\n}${PUSH29:+PUSH29 ${PUSH29_DATA}\n}${PUSH30:+PUSH30 ${PUSH30_DATA}\n}${PUSH31:+PUSH31 ${PUSH31_DATA}\n}${PUSH32:+PUSH32 ${PUSH32_DATA}\n}${DUP1:+DUP1\n}${DUP2:+DUP2\n}${DUP3:+DUP3\n}${DUP4:+DUP4\n}${DUP5:+DUP5\n}${DUP6:+DUP6\n}${DUP7:+DUP7\n}${DUP8:+DUP8\n}${DUP9:+DUP9\n}${DUP10:+DUP10\n}${DUP11:+DUP11\n}${DUP12:+DUP12\n}${DUP13:+DUP13\n}${DUP14:+DUP14\n}${DUP15:+DUP15\n}${DUP16:+DUP16\n}${SWAP1:+SWAP1\n}${SWAP2:+SWAP2\n}${SWAP3:+SWAP3\n}${SWAP4:+SWAP4\n}${SWAP5:+SWAP5\n}${SWAP6:+SWAP6\n}${SWAP7:+SWAP7\n}${SWAP8:+SWAP8\n}${SWAP9:+SWAP9\n}${SWAP10:+SWAP10\n}${SWAP11:+SWAP11\n}${SWAP12:+SWAP12\n}${SWAP13:+SWAP13\n}${SWAP14:+SWAP14\n}${SWAP15:+SWAP15\n}${SWAP16:+SWAP16\n}${LOG0:+LOG0\n}${LOG1:+LOG1\n}${LOG2:+LOG2\n}${LOG3:+LOG3\n}${LOG4:+LOG4\n}${CREATE:+CREATE\n}${CALL:+CALL\n}${CALLCODE:+CALLCODE\n}${RETURN:+RETURN\n}${DELEGATECALL:+DELEGATECALL\n}${CREATE2:+CREATE2\n}${STATICCALL:+STATICCALL\n}${REVERT:+REVERT\n}${INVALID:+INVALID\n}${SELFDESTRUCT:+SELFDESTRUCT\n}/g;
    // const assembly = bytecode.replace(regBinarySearch, "");
    // console.log(assembly);
    // setTextareaBytecode(bytecode);
    // setTextareaAssembly(assembly);
  };

  const regAssemblySearch = /${STOP:+00}${ADD:+01}${MUL:+02}${SUB:+03}${DIV:+04}${SDIV:+05}${MOD:+06}${SMOD:+07}${ADDMOD:+08}${MULMOD:+09}${EXP:+0a}${SIGNEXTEND:+0b}${LT:+10}${GT:+11}${SLT:+12}${SGT:+13}${EQ:+14}${ISZERO:+15}${AND:+16}${OR:+17}${XOR:+18}${NOT:+19}${BYTE:+1a}${SHL:+1b}${SHR:+1c}${SAR:+1d}${KECCAK:+20}${ADDRESS:+30}${BALANCE:+31}${ORIGIN:+32}${CALLER:+33}${CALLVALUE:+34}${CALLDATALOAD:+35}${CALLDATASIZE:+36}${CALLDATACOPY:+37}${CODESIZE:+38}${CODECOPY:+39}${GASPRICE:+3a}${EXTCODESIZE:+3b}${EXTCODECOPY:+3c}${RETURNDATASIZE:+3d}${RETURNDATACOPY:+3e}${EXTCODEHASH:+3f}${BLOCKHASH:+40}${COINBASE:+41}${TIMESTAMP:+42}${NUMBER:+43}${DIFFICULTY:+44}${GASLIMIT:+45}${CHAINID:+46}${SELFBALANCE:+47}${BASEFEE:+48}${POP:+50}${MLOAD:+51}${MSTORE:+52}${MSTORE8:+53}${SLOAD:+54}${SSTORE:+55}${JUMP:+56}${JUMPI:+57}${PC:+58}${MSIZE:+59}${GAS:+5a}${JUMPDEST:+5b}${PUSH1:+60}${DATA1}${PUSH2:+61}${DATA2}${PUSH3:+62}${DATA3}${PUSH4:+63}${DATA4}${PUSH5:+64}${DATA5}${PUSH6:+65}${DATA6}${PUSH7:+66}${DATA7}${PUSH8:+67}${DATA8}${PUSH9:+68}${DATA9}${PUSH10:+69}${DATA10}${PUSH11:+6a}${DATA11}${PUSH12:+6b}${DATA12}${PUSH13:+6c}${DATA13}${PUSH14:+6d}${DATA14}${PUSH15:+6e}${DATA15}${PUSH16:+6f}${DATA16}${PUSH17:+70}${DATA17}${PUSH18:+71}${DATA18}${PUSH19:+72}${DATA19}${PUSH20:+73}${DATA20}${PUSH21:+74}${DATA21}${PUSH22:+75}${DATA22}${PUSH23:+76}${DATA23}${PUSH24:+77}${DATA24}${PUSH25:+78}${DATA25}${PUSH26:+79}${DATA26}${PUSH27:+7a}${DATA27}${PUSH28:+7b}${DATA28}${PUSH29:+7c}${DATA29}${PUSH30:+7d}${DATA30}${PUSH31:+7e}${DATA31}${PUSH32:+7f}${DATA32}${DUP1:+80}${DUP2:+81}${DUP3:+82}${DUP4:+83}${DUP5:+84}${DUP6:+85}${DUP7:+86}${DUP8:+87}${DUP9:+88}${DUP10:+89}${DUP11:+8a}${DUP12:+8b}${DUP13:+8c}${DUP14:+8d}${DUP15:+8e}${DUP16:+8f}${SWAP1:+90}${SWAP2:+91}${SWAP3:+92}${SWAP4:+93}${SWAP5:+94}${SWAP6:+95}${SWAP7:+96}${SWAP8:+97}${SWAP9:+98}${SWAP10:+99}${SWAP11:+9a}${SWAP12:+9b}${SWAP13:+9c}${SWAP14:+9d}${SWAP15:+9e}${SWAP16:+9f}${LOG0:+a0}${LOG1:+a1}${LOG2:+a2}${LOG3:+a3}${LOG4:+a4}${CREATE:+f0}${CALL:+f1}${CALLCODE:+f2}${RETURN:+f3}${DELEGATECALL:+f4}${CREATE2:+f5}${STATICCALL:+fa}${REVERT:+fd}${INVALID:+fe}${SELFDESTRUCT:+ff}/g;
  const bytecodeString = "PUSH1 20";
  console.log(bytecodeString.replace(regAssemblySearch, ""));

  return (
    <>
      <header>
        <div className="header">
          <div className="header-left">
            <img src="vEVM.png" alt="logo" className="header-left-img" />
          </div>
          <div className="header-center">
            <h1>vEVM</h1>
            <h5>demo</h5>
          </div>
          <div className="header-right">{/* <ConnectKitButton /> */}</div>
        </div>
      </header>
      <div className="main">
        <h2>regex debug</h2>
        <textarea
          className="textarea-terminal"
          name="textarea-bytecode"
          value={textareaBytecode}
          placeholder="bytecode"
          onChange={(e) => bytecodeToAssembly(e.target.value)}
        />
        <textarea
          className="textarea-terminal"
          name="textarea-assembly"
          value={textareaAssembly}
          placeholder="bytecode"
          onChange={(e) => bytecodeToAssembly(e.target.value)}
        />

        <h2>bytecode</h2>
        <textarea
          className="textarea-terminal"
          value={textCode}
          placeholder="0x60016002600360040160005260206000F3"
          onChange={(e) => setTextCode(e.target.value)}
        />
        <div className="tx-params">
          <input
            className="tx-params-input-left"
            value={textData}
            type="text"
            placeholder="calldata"
            onChange={(e) => setTextData(e.target.value)}
          />
          <input
            className="tx-params-input-right"
            value={textValue}
            type="text"
            placeholder="value"
            onChange={(e) => setTextValue(e.target.value)}
          />
        </div>

        <button className="button-execute" onClick={(e) => sendParamters()}>
          Execute
        </button>
        {bytecode && (
          <EVMResults bytecode={bytecode} data={data} value={value} />
        )}
      </div>
      <footer>
        <a href="https://www.evm.codes/?fork=merge" target={"_blank"}>
          <img height="25" src="logo-evmcodes-light.png" alt="evm codes"></img>
        </a>
        <a
          href="https://ethereum.github.io/execution-specs/autoapi/ethereum/paris/vm/index.html"
          target={"_blank"}
        >
          <img
            height="25"
            src="logo-specification-light.png"
            alt="Ethereum Specification"
          ></img>
        </a>
        <a
          href="https://goerli-optimism.etherscan.io/address/0x6400e134C9440eead92B0c94FaD3EC0fefe96059#code"
          target={"_blank"}
        >
          <img height="25" src="logo-etherscan-light.svg" alt="Etherscan"></img>
        </a>
        <a href="https://github.com/kethcode/vEVM" target={"_blank"}>
          <img height="25" src="logo-github-light.png" alt="GitHub"></img>
        </a>
      </footer>
    </>
  );
}
