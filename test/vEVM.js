const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

const print_evm_state = (state) => {
  console.log("    pc:", state.pc);
  console.log("return:", state.returnData);
  console.log(" stack:", state.stack);
};

describe("vEVM", function () {
  async function deployFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const EVM = await ethers.getContractFactory("vEVM");
    const evm = await EVM.deploy();

    return { evm, owner, otherAccount };
  }

  describe("execute", function () {
    describe("PUSH1", function () {
      it("Should push a byte1 to the stack", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x6001");
        console.log("  code:", "0x6001");
        print_evm_state(result);
      });
    });

    describe("PUSH2", function () {
      it("Should push a byte2 to the stack", async function () {
        const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x610102");
        console.log("  code:", "0x610102");
        print_evm_state(result);
      });
    });

	describe("PUSH3", function () {
		it("Should push a byte3 to the stack", async function () {
		  const { evm } = await loadFixture(deployFixture);
		  let result = await evm.execute("0x62010203");
		  console.log("  code:", "0x62010203");
		  print_evm_state(result);
		});
	  });

    // it("Should display opcodes in sequence", async function () {
    //   const { evm } = await loadFixture(deployFixture);
    //   let result = await evm.execute("0x6001600201");
    //   console.log("  code:", "0x6001600201");

    //         let result = await evm.execute("0x6001600201");
    //   console.log("  code:", "0x6001600201
    //   //   let result = await evm.execute("0x61010201");
    //   //   console.log("  code:", "0x61010201");
    //   //   let result = await evm.execute("0x64010203040501");
    //   //   console.log("  code:", "0x64010203040501");
    //   print_evm_state(result);
    // });
  });
});
