import { ConnectKitButton } from "connectkit";
import { useAccount } from "wagmi";

import { Account } from "./components/Account";
import { EVMResults } from "./components/EVMResults";

import React, { useState } from "react";

import "./App.css";

export function App() {
  const { isConnected } = useAccount();
  const [text, setText] = useState("");
  const [bytecode, setBytecode] = useState("");

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
        <textarea className="textarea-terminal"
          value={text}
          placeholder="0x60016002600360040160005260206000F3"
          onChange={(e) => setText(e.target.value)}
        />
		<div className="tx-params">
		<input className="tx-params-input-left" type="text" placeholder="calldata" />
		<input className="tx-params-input-right" type="text" placeholder="value" />
		</div>
		
        <button className="button-execute" onClick={(e) => setBytecode(text)}>
          Execute
        </button>
        {bytecode && <EVMResults bytecode={bytecode} />}
      </div>
    </>
  );
}
