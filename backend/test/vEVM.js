const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

const print_evm_state = (state) => {
  console.log("  code:", state.code);
  console.log("  data:", state.data);
  console.log(" value:", state.value);
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
    // 0x00 - 0x0F: STOP, ADD, MUL, SUB, DIV, SDIV, MOD, SMOD, ADDMOD, MULMOD, EXP, SIGNEXTEND
    describe("STOP", function () {
      it("Should set running to false", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x00", "0x00", 0);
        expect(result.running).to.equal(false);
      });
    });

    describe("ADD", function () {
      it("Should sum the top two items on the stack", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x600160026003600401", "0x00", 0);
        expect(result.stack[2]).to.deep.equal(
          "0x0000000000000000000000000000000000000000000000000000000000000007"
        );
      });
    });

    describe("MUL", function () {
      it("Should multiply the top two items on the stack", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x600160026003600402", "0x00", 0);
        expect(result.stack[2]).to.deep.equal(
          "0x000000000000000000000000000000000000000000000000000000000000000C"
        );
      });
    });

    describe("SUB", function () {
      it("Should subtract the top two items on the stack", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x600160026003600403", "0x00", 0);
        expect(result.stack[2]).to.deep.equal(
          "0x0000000000000000000000000000000000000000000000000000000000000001"
        );
      });
    });

    describe("DIV", function () {
      it("Should divide the top two items on the stack", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x600160026004600C04", "0x00", 0);
        expect(result.stack[2]).to.deep.equal(
          "0x0000000000000000000000000000000000000000000000000000000000000003"
        );
      });
    });

    describe("SDIV", function () {
      it("Should divide the top two signed items on the stack", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute(
          "0x600160027FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE05",
          "0x00",
          0
        );
        expect(result.stack[2]).to.deep.equal(
          "0x0000000000000000000000000000000000000000000000000000000000000002"
        );
      });
    });

    describe("MOD", function () {
      it("Should store modulo remainder of top two items on the stack", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x600160026003600A06", "0x00", 0);
        expect(result.stack[2]).to.deep.equal(
          "0x0000000000000000000000000000000000000000000000000000000000000001"
        );
      });
    });

    describe("SMOD", function () {
      it("Should store modulo remainder of top two signed items on the stack", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute(
          "0x600160027FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF807",
          "0x00",
          0
        );
        expect(result.stack[2]).to.deep.equal(
          "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE"
        );
      });
    });

    describe("ADDMOD", function () {
      it("Should add then store modulo remainder of top three items on the stack", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute(
          "0x60016002600260027FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF08",
          "0x00",
          0
        );
        expect(result.stack[2]).to.deep.equal(
          "0x0000000000000000000000000000000000000000000000000000000000000001"
        );
      });
    });

    describe("MULMOD", function () {
      it("Should multiply then store modulo remainder of top three items on the stack", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute(
          "0x60016002600C7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF09",
          "0x00",
          0
        );
        expect(result.stack[2]).to.deep.equal(
          "0x0000000000000000000000000000000000000000000000000000000000000009"
        );
      });
    });

    describe("EXP", function () {
      it("Should store exponential result of top two items on the stack", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x6002600A0A", "0x00", 0);
        expect(result.stack[0]).to.deep.equal(
          "0x0000000000000000000000000000000000000000000000000000000000000064"
        );
      });
    });

    describe("SIGNEXTEND", function () {
      it("Should sign extend top value on the stack starting ata specific byte", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x60FF60000B607F60000B", "0x00", 0);
        expect(result.stack[1]).to.deep.equal(
          "0x000000000000000000000000000000000000000000000000000000000000007F"
        ) &&
          expect(result.stack[0]).to.deep.equal(
            "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
          );
      });
    });

    // 0x10 - 0x1F: LT, GT, SLT, SGT, EQ, ISZERO, AND, OR, XOR, NOT, BYTE, SHL, SHR, SAR
    describe("LT", function () {
      it("Should store 1 if a < b, else 0", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x6009600A10600A600910", "0x00", 0);
        expect(result.stack[0]).to.deep.equal(
          "0x000000000000000000000000000000000000000000000000000000000000000"
        ) &&
          expect(result.stack[1]).to.deep.equal(
            "0x000000000000000000000000000000000000000000000000000000000000001"
          );
      });
    });

    describe("GT", function () {
      it("Should store 1 if a > b, else 0", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x6009600A11600A600911", "0x00", 0);
        expect(result.stack[0]).to.deep.equal(
          "0x000000000000000000000000000000000000000000000000000000000000001"
        ) &&
          expect(result.stack[1]).to.deep.equal(
            "0x000000000000000000000000000000000000000000000000000000000000000"
          );
      });
    });

    describe("SLT", function () {
      it("Should store 1 if a < b, else 0", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute(
          "0x60097FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF12600A600A12",
          "0x00",
          0
        );
        expect(result.stack[0]).to.deep.equal(
          "0x000000000000000000000000000000000000000000000000000000000000001"
        ) &&
          expect(result.stack[1]).to.deep.equal(
            "0x000000000000000000000000000000000000000000000000000000000000000"
          );
      });
    });

    describe("SGT", function () {
      it("Should store 1 if a > b, else 0", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute(
          "0x60097FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF13600A600B13",
          "0x00",
          0
        );
        expect(result.stack[0]).to.deep.equal(
          "0x000000000000000000000000000000000000000000000000000000000000000"
        ) &&
          expect(result.stack[1]).to.deep.equal(
            "0x000000000000000000000000000000000000000000000000000000000000001"
          );
      });
    });

    describe("EQ", function () {
      it("Should store 1 if a == b, else 0", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x600A600A14600A600914", "0x00", 0);
        expect(result.stack[0]).to.deep.equal(
          "0x000000000000000000000000000000000000000000000000000000000000001"
        ) &&
          expect(result.stack[1]).to.deep.equal(
            "0x000000000000000000000000000000000000000000000000000000000000000"
          );
      });
    });

    describe("ISZERO", function () {
      it("Should store 1 if a == 0, else 0", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x600015600115", "0x00", 0);
        expect(result.stack[0]).to.deep.equal(
          "0x0000000000000000000000000000000000000000000000000000000000000001"
        ) &&
          expect(result.stack[1]).to.deep.equal(
            "0x000000000000000000000000000000000000000000000000000000000000000"
          );
      });
    });

    describe("AND", function () {
      it("Should bitwise AND correctly", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x600F600F1660FF600016", "0x00", 0);
        expect(result.stack[0]).to.deep.equal(
          "0x000000000000000000000000000000000000000000000000000000000000000F"
        ) &&
          expect(result.stack[1]).to.deep.equal(
            "0x000000000000000000000000000000000000000000000000000000000000000"
          );
      });
    });

    describe("OR", function () {
      it("Should bitwise OR correctly", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x600F60F01760FF60FF17", "0x00", 0);
        expect(result.stack[0]).to.deep.equal(
          "0x00000000000000000000000000000000000000000000000000000000000000FF"
        ) &&
          expect(result.stack[1]).to.deep.equal(
            "0x0000000000000000000000000000000000000000000000000000000000000FF"
          );
      });
    });

    describe("XOR", function () {
      it("Should bitwise XOR correctly", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x600F60F01860FF60FF18", "0x00", 0);
        expect(result.stack[0]).to.deep.equal(
          "0x00000000000000000000000000000000000000000000000000000000000000FF"
        ) &&
          expect(result.stack[1]).to.deep.equal(
            "0x000000000000000000000000000000000000000000000000000000000000000"
          );
      });
    });

    describe("NOT", function () {
      it("Should bitwise NOT correctly", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x600019", "0x00", 0);
        expect(result.stack[0]).to.deep.equal(
          "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
        );
      });
    });

    describe("BYTE", function () {
      it("Should extract the correct byte", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x60FF601F1A61FF00601E1A", "0x00", 0);
        expect(result.stack[0]).to.deep.equal(
          "0x00000000000000000000000000000000000000000000000000000000000000FF"
        ) &&
          expect(result.stack[1]).to.deep.equal(
            "0x0000000000000000000000000000000000000000000000000000000000000FF"
          );
      });
    });

    describe("SHL", function () {
      it("Should shift bits left", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x600160011B7FFF0000000000000000000000000000000000000000000000000000000000000060041B", "0x00", 0);
        expect(result.stack[0]).to.deep.equal(
          "0x000000000000000000000000000000000000000000000000000000000000002"
        ) &&
          expect(result.stack[1]).to.deep.equal(
            "0xF000000000000000000000000000000000000000000000000000000000000000"
          );
      });
    });

    describe("SHR", function () {
      it("Should shift bits right", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x600260011C60FF60041C", "0x00", 0);
        expect(result.stack[0]).to.deep.equal(
          "0x000000000000000000000000000000000000000000000000000000000000001"
        ) &&
          expect(result.stack[1]).to.deep.equal(
            "0x000000000000000000000000000000000000000000000000000000000000000f"
          );
      });
    });

    describe("SAR", function () {
      it("Should shift bits right with sign extension", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x600260011D7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF060041D", "0x00", 0);
        expect(result.stack[0]).to.deep.equal(
          "0x000000000000000000000000000000000000000000000000000000000000001"
        ) &&
          expect(result.stack[1]).to.deep.equal(
            "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
          );
      });
    });

    describe("SHA3", function () {
      it("Should keccak256 to the correct value", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x7FFFFFFFFF000000000000000000000000000000000000000000000000000000006000526004600020", "0x00", 0);
        // print_evm_state(result);
        expect(result.stack[0]).to.deep.equal(
          "0x29045a592007d0c246ef02c2223570da9522d0cf0f73282c79a1bc8f0bb2c238"
        );
      });
    });


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


    // 0x60 - 0x7F: PUSH1 - PUSH32
    describe("PUSH", function () {
      it("Should correctly store calldata from PUSH1-PUSH32", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute(
          "0x600161000262000003630000000464000000000565000000000006660000000000000767000000000000000868000000000000000009690000000000000000000A6A000000000000000000000B6B00000000000000000000000C6C0000000000000000000000000D6D000000000000000000000000000E6E00000000000000000000000000000F6F0000000000000000000000000000001070000000000000000000000000000000001171000000000000000000000000000000000012720000000000000000000000000000000000001373000000000000000000000000000000000000001474000000000000000000000000000000000000000015750000000000000000000000000000000000000000001676000000000000000000000000000000000000000000001777000000000000000000000000000000000000000000000018780000000000000000000000000000000000000000000000001979000000000000000000000000000000000000000000000000001A7A00000000000000000000000000000000000000000000000000001B7B0000000000000000000000000000000000000000000000000000001C7C000000000000000000000000000000000000000000000000000000001D7D00000000000000000000000000000000000000000000000000000000001E7E0000000000000000000000000000000000000000000000000000000000001F7F00000000000000000000000000000000000000000000000000000000000000FF",
          "0xCA11",
          374
        );
        expect(result.stack).to.deep.equal([
          "0x0000000000000000000000000000000000000000000000000000000000000001",
          "0x0000000000000000000000000000000000000000000000000000000000000002",
          "0x0000000000000000000000000000000000000000000000000000000000000003",
          "0x0000000000000000000000000000000000000000000000000000000000000004",
          "0x0000000000000000000000000000000000000000000000000000000000000005",
          "0x0000000000000000000000000000000000000000000000000000000000000006",
          "0x0000000000000000000000000000000000000000000000000000000000000007",
          "0x0000000000000000000000000000000000000000000000000000000000000008",
          "0x0000000000000000000000000000000000000000000000000000000000000009",
          "0x000000000000000000000000000000000000000000000000000000000000000a",
          "0x000000000000000000000000000000000000000000000000000000000000000b",
          "0x000000000000000000000000000000000000000000000000000000000000000c",
          "0x000000000000000000000000000000000000000000000000000000000000000d",
          "0x000000000000000000000000000000000000000000000000000000000000000e",
          "0x000000000000000000000000000000000000000000000000000000000000000f",
          "0x0000000000000000000000000000000000000000000000000000000000000010",
          "0x0000000000000000000000000000000000000000000000000000000000000011",
          "0x0000000000000000000000000000000000000000000000000000000000000012",
          "0x0000000000000000000000000000000000000000000000000000000000000013",
          "0x0000000000000000000000000000000000000000000000000000000000000014",
          "0x0000000000000000000000000000000000000000000000000000000000000015",
          "0x0000000000000000000000000000000000000000000000000000000000000016",
          "0x0000000000000000000000000000000000000000000000000000000000000017",
          "0x0000000000000000000000000000000000000000000000000000000000000018",
          "0x0000000000000000000000000000000000000000000000000000000000000019",
          "0x000000000000000000000000000000000000000000000000000000000000001a",
          "0x000000000000000000000000000000000000000000000000000000000000001b",
          "0x000000000000000000000000000000000000000000000000000000000000001c",
          "0x000000000000000000000000000000000000000000000000000000000000001d",
          "0x000000000000000000000000000000000000000000000000000000000000001e",
          "0x000000000000000000000000000000000000000000000000000000000000001f",
          "0x00000000000000000000000000000000000000000000000000000000000000ff",
        ]);
      });
    });

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
    //     let result = await evm.execute("0x60006000A07F000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F60206000527FA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C360206000A1", "0x00", 0);
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

    // describe("SIGNEXTEND", function () {
    //   it("Should ", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    //     let result = await evm.execute("0x60FF60000B607F60000B");
    //     print_evm_state(result);
    //   });
    // });

    // describe("SAR", function () {
    //   it("Should ", async function () {
    //     const { evm } = await loadFixture(deployFixture);
    // 	// 0x600260011D7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF060041D
    //     let result = await evm.execute("0x600260011D7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF060041D");
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

    // describe("CALLDATA STUFF", function () {
    // 	it("Execution", async function () {
    // 	  const { evm } = await loadFixture(deployFixture);
    // 	  //"0x6033600202595260206000f3"
    // 	  let result = await evm.execute("0x3436600135", "0x0011223344", 64);
    // 	  print_evm_state(result);
    // 	});
    //   });
  });
});
