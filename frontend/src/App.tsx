import { ConnectKitButton } from "connectkit";
import { useAccount } from "wagmi";

import { Account } from "./components/Account";
import { EVMResults } from "./components/EVMResults";

import React, { useState } from "react";

import "./App.css";

export function App() {
  const { isConnected } = useAccount();
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

  //   const renderMain = () => {
  //     return (
  //       <div className="main">
  //         <h2>bytecode</h2>
  //         <textarea
  //           value={text}
  //           placeholder="0x60016002600360040160005260206000F3"
  //           onChange={(e) => setText(e.target.value)}
  //         />

  //         <button className="button-execute" onClick={(e) => setBytecode(text)}>
  //           Execute
  //         </button>
  //         <h2>output</h2>
  //         {bytecode && <EVMResults bytecode={bytecode} />}
  //       </div>
  //     );
  //     // }
  //   };

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
