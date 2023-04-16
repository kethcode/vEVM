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
              0xfc10b009f8395435080c202eb58edae7d8919500d2a97ed214c3c8395e635aa1
              {/* answer: 1681623167, 0x643B887F in hex*/}
              {/* detail: the has is a transaction id.  on etherscan, there is a timestamp. converting that timestamp to a unix timestamp gives the answer. */}
              <br />
              0xeeDE8663A8cF15F371F764F5de95736B7baAB757
              {/* answer: 9001, 0x2329 in hex */}
              {/* detail: the address is a contract.  on etherscan, there is a balance.  converting that balance to a decimal gives the answer. */}
              <br />
              function execute(bytes,bytes,uint256)
              {/* answer: 0xa8c54211 */}
              {/* detail: when you call a function on a contract, it selects the function using the function signature, which is the first 4 bytes a keccak256 hash. */}
            </p>
          </div>
        </div>

        {/* one possible bytecode: 63643B887F61232963a8c542110101600052601C6004F3 */}
        {/* answer: 0x0000000000000000000000000000000000000000000000010d00edb9 */}
        {/* detail: push all 3 values to the stack, and then add twice to get the sum. the answer is now on the stack, but the return opcode requires it to be in memory, so copy it to memory, and return it.  */}

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
        <a href="https://vevm-demo.vercel.app" target={"_blank"}>
          https://vevm-demo.vercel.app
        </a>
        <a href="https://www.evm.codes" target={"_blank"}>
          https://www.evm.codes
        </a>
        <a
          href="https://ethereum.github.io/execution-specs/autoapi/ethereum/shanghai/vm"
          target={"_blank"}
        >
          https://ethereum.github.io/execution-specs/autoapi/ethereum/shanghai/vm
        </a>
        <a href="https://etherscan.io" target={"_blank"}>
          https://etherscan.io
        </a>
        <a href="https://github.com/kethcode/vEVM" target={"_blank"}>
          https://github.com/kethcode/vEVM
        </a>
        <a href="https://www.4byte.directory" target={"_blank"}>
          https://www.4byte.directory
        </a>
        <a
          href="https://emn178.github.io/online-tools/keccak_256.html"
          target={"_blank"}
        >
          https://emn178.github.io/online-tools/keccak_256.html
        </a>
        <a
          href="https://www.browserling.com/tools/utc-to-unix"
          target={"_blank"}
        >
          https://www.browserling.com/tools/utc-to-unix
        </a>
      </footer>
    </>
  );
}
