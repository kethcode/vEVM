import { useProvider, useContract } from "wagmi";
import { useState, useMemo } from "react";

import { ethers } from "ethers";

const evm_address = "0x4121E8574D28b2E5f5777F7B00d435Ee4886A5F4";

import evm_abi from "../../../abi/vEVM.json";

type vEVMState = {
  code: string;
  data: string;
  value: string;
  pc: string;
  stack: string[];
  mem: string;
  storageKey: string[];
  storageData: string[];
  logs: string[];
  output: string;
};

export function EVMResults(props: any) {
  // const provider = useProvider();
  // deploy to base-goerli
  const url = "https://goerli.base.org";
  const provider = new ethers.providers.JsonRpcProvider(url);
  const evm = useContract({
    address: evm_address,
    abi: evm_abi.abi,
    signerOrProvider: provider,
  });
  const [results, setResults] = useState(null);

  const getHexSlotString = (index: number) => {
    return (
      ethers.utils.hexlify(index * 32) +
      ":" +
      ethers.utils.hexlify((index + 1) * 32 - 1)
    );
  };

  const renderResults = () => {
    if (results) {
      const res: vEVMState = results;

      const code_temp = res.code.slice(2).match(/.{1,64}/g) || [];
      const code_array = code_temp.map((code_slot, index) => (
        <li key={index}>
          {" "}
          <span className="chisel-yellow">
            [{getHexSlotString(index)}]
          </span>: <span className="chisel-cyan">{code_slot}</span>
        </li>
      ));

      const pc_string = parseInt(res.pc);

      const data_temp = res.data.slice(2).match(/.{1,64}/g) || [];
      const data_array = data_temp.map((data_slot, index) => (
        <li key={index}>
          {" "}
          <span className="chisel-yellow">[{index}]</span>:{" "}
          <span className="chisel-cyan">{data_slot}</span>
        </li>
      ));

      const value_string = res.value.toString();

      const output_temp = res.output.slice(2).match(/.{1,64}/g) || [];
      const output_array = output_temp.map((output_slot, index) => (
        <li key={index}>
          {" "}
          <span className="chisel-yellow">[{index}]</span>:{" "}
          <span className="chisel-cyan">{output_slot}</span>
        </li>
      ));

      const stack_array = res.stack.map((stack_slot, index) => (
        <li key={index}>
          {" "}
          <span className="chisel-yellow">[{ethers.utils.hexlify(index)}]</span>
          : <span className="chisel-cyan">{stack_slot.slice(2)}</span>
        </li>
      ));

      const mem_temp = res.mem.slice(2).match(/.{1,64}/g) || [];
      const mem_array = mem_temp.map((mem_slot, index) => (
        <li key={index}>
          {" "}
          <span className="chisel-yellow">
            [{getHexSlotString(index)}]
          </span>: <span className="chisel-cyan">{mem_slot}</span>
        </li>
      ));

      const storage_size = res.storageKey.length;
      const storage_map = [];
      for (let i = 0; i < storage_size; i++) {
        storage_map.push({ key: res.storageKey, data: res.storageData });
      }
      const storage_array = storage_map.map((slot, index) => (
        <li key={index}>
          {" "}
          <span className="chisel-yellow">[{slot.key}]</span> :
          <span className="chisel-cyan">{slot.data}</span>
        </li>
      ));

      const logs_size = res.logs.length;
      const logs_map = [];
      for (let i = 0; i < logs_size; i++) {
        logs_map.push(res.logs[i].slice(2).match(/.{1,64}/g) || []);
      }
      const logs_array = logs_map.map((log, index) => (
        <li key={index}>
          {" "}
          <span className="chisel-yellow">[{index}]</span>:{" "}
          <span className="chisel-cyan">{log}</span>
        </li>
      ));

      return (
        <div className="results">
          <h2>results</h2>
          <div className="container-terminal top">
            <h3>code</h3>
            <ul>{code_array}</ul>
            <br />
            <p>
              <b className="chisel-green">pc</b>:{" "}
              <span className="chisel-cyan">{pc_string}</span>
              <br />
              <b className="chisel-green">value (wei)</b>:{" "}
              <span className="chisel-cyan">{value_string}</span>
            </p>
            <h3>calldata</h3>
            <ul>{data_array}</ul>
            <h3>stack</h3>
            <ul>{stack_array}</ul>
            <h3>memory</h3>
            <ul>{mem_array}</ul>
            <h3>storage</h3>
            <ul>{storage_array}</ul>
          </div>
          <div className="container-terminal bottom">
            <h3>output</h3>
            <p>{output_array}</p>
            <h3>logs</h3>
            <ul>{logs_array}</ul>
          </div>
        </div>
      );
    }
  };

  const executeBytecode = async () => {
    if (evm) {
      let code;
      let data;
      let value;

      if (props.data != "") {
        data = props.data;
        if (data.substring(0, 2) != "0x") {
          data = "0x" + data;
        }
      } else {
        data = "0x";
      }

      if (props.value != "") {
        value = props.value;
      } else {
        value = ethers.BigNumber.from(0);
      }

      if (props.bytecode != "") {
        code = props.bytecode;
        if (code.substring(0, 2) != "0x") {
          code = "0x" + code;
        }

        if (ethers.utils.isBytesLike(code)) {
          const result = await evm.execute(code, data, value);
          console.log(result);
          setResults(result);
        }
      }
    }
  };

  const result = useMemo(
    () => executeBytecode(),
    [props.bytecode, props.data, props.value]
  );

  return <>{renderResults()}</>;
}
