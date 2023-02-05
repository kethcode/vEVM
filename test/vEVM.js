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
    it("Should display opcodes in sequence", async function () {
      const { evm } = await loadFixture(deployFixture);
        let result = await evm.execute("0x6001600201");
        console.log("  code:", "0x6001600201");
    //   let result = await evm.execute("0x61010201");
    //   console.log("  code:", "0x61010201");
    //   let result = await evm.execute("0x64010203040501");
    //   console.log("  code:", "0x64010203040501");
      print_evm_state(result);
    });
  });
});
