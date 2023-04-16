// import { ConnectKitButton } from "connectkit";
// import { useAccount } from "wagmi";

// import { Account } from "./components/Account";
import { EVMResults } from "./components/EVMResults";

import { useState } from "react";

import "./App.css";

export function App() {
  //   const { isConnected } = useAccount();
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

  return (
    <>
      <header>
        <div className="header">
            <h1>Not Your Keys</h1>
        </div>
      </header>
      <div className="main">
        <div className="box">
          <div className="hint">
            <p>
              // time is critical
              <br />
              // my wei balance is a joke
              <br />
              // please select for me
            </p>
          </div>
          <div className="hint-detail">
            <p>
              0xcd676126e5e1c8fbf675646cf165bf2476a19efbdaced9e204ad3dc40d01ad0f
              {/* answer: 1677231384, 0x63F88518 in hex*/}
              {/* detail: the has is a transaction id.  on etherscan, there is a timestamp. converting that timestamp to a unix timestamp gives the answer. */}
              <br />
              0x4121e8574d28b2e5f5777f7b00d435ee4886a5f4
              {/* answer: 9001, 0x2329 in hex */}
              {/* detail: the address is a contract.  on etherscan, there is a balance.  converting that balance to a decimal gives the answer. */}
              <br />
              function execute(bytes,bytes,uint256)
              {/* answer: 0xa8c54211 */}
              {/* detail: when you call a function on a contract, it selects the function using the function signature, which is the first 4 bytes a keccak256 hash. */}
            </p>
          </div>
        </div>

        {/* one possible bytecode: 6363F8851861232963a8c542110101600052601C6004F3 */}
        {/* answer: 0x0000000000000000000000000000000000000000000000010cbdea52 */}
        {/* detail: push all 3 values to teh stack, and then add twice to get the sum. the answer is now on the stack, but the return opcode requires it to be in memory, so copy it to memory, and return it.  */}
        
        <textarea
          className="textarea-terminal"
          value={textCode}
          placeholder="bytecode: sum the answers, copy to memory, and return"
          onChange={(e) => setTextCode(e.target.value)}
        />
        {/* <div className="tx-params">
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
        </div> */}

        <button className="button-execute on" onClick={(e) => sendParamters()}>
          Execute
        </button>
        {bytecode && (
          <EVMResults bytecode={bytecode} data={data} value={value} />
        )}
      </div>

      {/* //TODO: modify footer <br/>DONE */}
      {/* //TODO: leave evm.codes <br/>DONE */}
      {/* //TODO: leave ethereum spec <br/>DONE */}
      {/* //TODO: change etherscan link to https://goerli.basescan.org <br/>DONE */}
      {/* //TODO: leave github <br/>DONE */}
      {/* //TODO: add https://www.4byte.directory/<br/>DONE */}
      {/* //TODO: add https://emn178.github.io/online-tools/keccak_256.html<br/>DONE */}


      <footer>
        <a href="https://www.evm.codes" target={"_blank"}>https://www.evm.codes</a>
        <a
          href="https://ethereum.github.io/execution-specs/autoapi/ethereum/paris/vm"
          target={"_blank"}
        >
          https://ethereum.github.io/execution-specs/autoapi/ethereum/paris/vm
        </a>
        <a
          href="https://goerli.basescan.org"
          target={"_blank"}
        >
          https://goerli.basescan.org
        </a>
        <a href="https://github.com/kethcode/vEVM" target={"_blank"}>
          https://github.com/kethcode/vEVM
        </a>
        <a href="https://www.4byte.directory" target={"_blank"}>
          https://www.4byte.directory
        </a>
        <a href="https://emn178.github.io/online-tools/keccak_256.html" target={"_blank"}>
          https://emn178.github.io/online-tools/keccak_256.html
        </a>
      </footer>
    </>
  );
}
