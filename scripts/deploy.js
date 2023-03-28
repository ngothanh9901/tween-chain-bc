// const web3 = require("web3");
const { ethers, upgrades } = require("hardhat");
// import NFTRewardFactory from '../artifacts/contracts/NFTReward.sol/NFTReward.json'
// const { toWei } = web3.utils;
const main = async () => {
//   const [deployer] = await ethers.getSigners();

//   const ELPToken = await ethers.getContractFactory("Event");
  // const Token = await ethers.getContractFactory("Token");
  const NFTReward = await ethers.getContractFactory("NFTReward");
  console.log("Deploying EFUN...");

  const elp = await upgrades.deployProxy(NFTReward, ["0xb791517E95fe28d0FedE8F07C337baE0394ac9dA", "THANG", "THA", "localhost"], {
    initializer: "initialize",
  });

  // const elp = await upgrades.deploy(Token);

  console.log("EFUN deployed to: " + elp.address);
};

main()
  .then(() => process.exit(0))
  .catch(e => {
    console.log(e);
    process.exit(1);
  });