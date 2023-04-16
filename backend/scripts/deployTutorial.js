const { ethers } = require("hardhat");
const hre = require("hardhat");

require("@nomiclabs/hardhat-etherscan");

const delay = (ms) => new Promise((res) => setTimeout(res, ms));

async function main() {
  const { chainId } = await ethers.provider.getNetwork();
  console.log(chainId);

  const [deployer] = await ethers.getSigners();

  console.log("\nDeployer address:", deployer.address);
  console.log("Deployer balance:", (await deployer.getBalance()).toString());

  const tutorial_factory = await ethers.getContractFactory("tutorial");
  const tutorial = await tutorial_factory.deploy();
  await tutorial.deployed();
  console.log("tutorial address:", tutorial.address);

  // const tx = await tutorial.setAnswerHash("0x1234567890");

  // if (chainId != 31337) {
  //   await delay(60000);

  //   await hre.run("verify:verify", {
  //     address: evm.address,
  //   });
  //   console.log("evm verified");
  // }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
