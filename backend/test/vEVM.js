const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

const print_evm_state = (state) => {
  console.log("  code:", state.code);
  console.log("    pc:", parseInt(state.pc));
  console.log("output:", state.output);
  console.log(" stack:", state.stack);
  console.log("   mem:", chunkSubstr(state.mem, 64));
  console.log("  skey:", state.storageKey);
  console.log(" sdata:", state.storageData);
  console.log("  logs:", state.logs);
  //   if (state.storageKey.length > 0) {
  //     console.log(" store:");
  //     for (let i = 0; i < state.storageKey.length; i++) {
  //       console.log("        ", state.storageKey[i], state.storageValue[i]);
  //     }
  //   }
};

function chunkSubstr(str, size) {
  const hex = str.slice(2);
  const numChunks = Math.ceil(hex.length / size);
  const chunks = new Array(numChunks);

  for (let i = 0, o = 0; i < numChunks; ++i, o += size) {
    chunks[i] = hex.substr(o, size);
  }

  return chunks;
}

describe("vEVM", function () {
  async function deployFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const EVM = await ethers.getContractFactory("vEVM");
    const evm = await EVM.deploy();

    // await owner.sendTransaction({
    //   to: evm.address,
    //   value: ethers.utils.parseEther("1.0"), // Sends exactly 1.0 ether
    // });

    return { evm, owner, otherAccount };
  }

  describe("execute", function () {
    //     describe("PUSH8", function () {
    //       it("Should push a byte8 to the stack", async function () {
    //         const { evm } = await loadFixture(deployFixture);
    //         let result = await evm.execute("0x670102030405060708");
    //         print_evm_state(result);
    //       });
    //     });

    // describe("PUSH1", function () {
    //   it("Should push a byte1 to the stack", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x6001");
    //     console.log("  code:", "0x6001");
    //     print_evm_state(result);
    //   });
    // });

    // describe("PUSH2", function () {
    //   it("Should push a byte2 to the stack", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x610102");
    //     console.log("  code:", "0x610102");
    //     print_evm_state(result);
    //   });
    // });

    // describe("PUSH3", function () {
    //   it("Should push a byte3 to the stack", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x62010203");
    //     console.log("  code:", "0x62010203");
    //     print_evm_state(result);
    //   });
    // });

    // describe("PUSH1 x4", function () {
    //   it("Should push multiple items to the stack", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x6001600260036004");
    //     console.log("  code:", "0x6001600260036004");
    //     print_evm_state(result);
    //   });
    // });

    // describe("ADD", function () {
    //   it("Should sum the top two items on the stack", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x600160026003600401");
    //     console.log("  code:", "0x600160026003600401");
    //     print_evm_state(result);
    //   });
    // });

    // describe("MLOAD", function () {
    // 	it("Should read various offsets onto the stack", async function () {
    // 	  const { evm } = await loadFixture(deployFixture);
    // 	  let result = await evm.execute("0x60FF60005260005160015160A560A05260A151");
    // 	  console.log("  code:", "0x60FF60005260005160015160A560A05260A151");
    // 	  print_evm_state(result);
    // 	});

    //   });

    // describe("MSTORE", function () {
    //   it("Should push a bytes32 to memory 0x80", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute(
    //       "0x7F000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F600052"
    //     );
    //     console.log(
    //       "  code:",
    //       "0x7F000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F600052"
    //     );
    //     print_evm_state(result);
    //   });

    //   it("Should push a bytes32 to memory 0x81", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute(
    //       "0x7F000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F600152"
    //     );
    //     console.log(
    //       "  code:",
    //       "0x7F000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F600152"
    //     );
    //     print_evm_state(result);
    //   });
    // });

    // describe("MSTORE8", function () {
    //   it("Should push a bytes1 to memory 0x80", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x60A5600053");
    //     console.log("  code:", "0x60A5600053");
    //     print_evm_state(result);
    //   });

    //   it("Should push a bytes1 to memory 0x81", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x60A5600153");
    //     console.log("  code:", "0x60A5600153");
    //     print_evm_state(result);
    //   });
    // });

    // describe("MSIZE", function () {
    //   it("Should push a bytes1 to memory 0x80", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x59608051505960C9515059");
    //     console.log("  code:", "0x59608051505960C9515059");
    //     print_evm_state(result);
    //   });
    // });

    // describe("RETURN", function () {
    //   it("Should return the sum the top two items on the stack", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x60016002600360040160005260206000F3");
    //     console.log("  code:", "0x60016002600360040160005260206000F3");
    //     print_evm_state(result);
    //   });
    // });

    // describe("SLOAD", function () {
    //   it("Should push a bytes1 to memory 0x80", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x600054600154");
    //     console.log("  code:", "0x600054600154");
    //     print_evm_state(result);
    //   });
    // });

    // describe("SSTORE", function () {
    //   it("Should store and retrieve 0x25 to storage slot 11", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x6025601155601154");
    //     console.log("  code:", "0x6025601155601154");
    //     print_evm_state(result);
    //   });
    // });

    // describe("BYTE", function () {
    //   it("Should extract a specfic byte from a stack value back onto the stack", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x7F000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F601B1A");
    //     console.log("  code:", "0x7F000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F601B1A");
    //     print_evm_state(result);
    //   });
    // });

    // describe("SHA3", function () {
    //   it("Should extract a specfic byte from a stack value back onto the stack", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute(
    //       "0x7FFFFFFFFF000000000000000000000000000000000000000000000000000000006000526004600020"
    //     );
    //     console.log(
    //       "  code:",
    //       "0x7FFFFFFFFF000000000000000000000000000000000000000000000000000000006000526004600020"
    //     );
    //     print_evm_state(result);
    //   });
    // });

    // describe("DUPN", function () {
    //   it("Should Duplicate the Nth stack item (from top of the stack) to the top of stack", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute(
    //       "0x6000600160026003600460056006600760086009600A600B600C600D600E600F8A"
    //     );
    //     console.log(
    //       "  code:",
    //       "0x6000600160026003600460056006600760086009600A600B600C600D600E600F80"
    //     );
    //     print_evm_state(result);
    //   });
    // });

    // describe("SWAPN", function () {
    //   it("Should Duplicate the Nth stack item (from top of the stack) to the top of stack", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute(
    //       "0x6000600160026003600460056006600760086009600A600B600C600D600E600F9A"
    //     );
    //     console.log(
    //       "  code:",
    //       "0x6000600160026003600460056006600760086009600A600B600C600D600E600F9A"
    //     );
    //     print_evm_state(result);
    //   });
    // });

    // describe("JUMP", function () {
    //   it("Should ", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x6000600756600A5B6001");
    //     print_evm_state(result);
    //   });
    // });

    // describe("JUMPI", function () {
    //   it("Should ", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x6001600757600A5B6001");
    //     print_evm_state(result);
    //   });
    // });

    // describe("PC", function () {
    //   it("Should ", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x600158");
    //     print_evm_state(result);
    //   });
    // });

    // describe("ADDRESS", function () {
    //   it("Should ", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x30");
    //     print_evm_state(result);
    //   });
    // });

    // describe("BALANCE", function () {
    //   it("Should ", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x3031");
    //     print_evm_state(result);
    //   });
    // });

    // describe("Arbitrary", function () {
    //   it("Execution", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    // 	//"0x6033600202595260206000f3"
    //     let result = await evm.execute("0x60006000A07F000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F60206000527FA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C360206000A1");
    //     print_evm_state(result);
    //   });
    // });

    // describe("SELFDESTRUCT", function () {
    //   it("Should ", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x600160026003600052FF");
    //     print_evm_state(result);
    //   });
    // });

    // describe("CALLER", function () {
    //   it("Should ", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x33");
    //     print_evm_state(result);
    //   });
    // });


    // describe("CREATE", function () {
	// 	it("Should ", async function () {
	// 	  const { evm } = await loadFixture(deployFixture);
	// 	  let result = await evm.execute("0x7F000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F600052602060006001");
	// 	  print_evm_state(result);
	// 	});
	//   });

    // describe("MLOAD DEBUG", function () {
    //   it("Should", async function () {
    // 	const { evm } = await loadFixture(deployFixture);
    // 	// let result = await evm.execute("0x6701020304050607085952");
    // 	let result = await evm.execute("0x7F000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F600052600151");
    // 	print_evm_state(result);
    //   });
    // });
  });
});
