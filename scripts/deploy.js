// const web3 = require("web3");
// const { ethers, upgrades } = require("hardhat");
// const { toWei } = web3.utils;
const main = async () => {
//   const [deployer] = await ethers.getSigners();

//   const ELPToken = await ethers.getContractFactory("Event");
  const Token = await ethers.getContractFactory("Token");
  console.log("Deploying EFUN...");

//   const elp = await upgrades.deployProxy(ELPToken, ["EFUN NFT", "EFT", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000"], {
//     initializer: "initialize",
//   });

  const elp = await upgrades.deploy(Token);

  console.log("EFUN deployed to: " + elp.address);
};

main()
  .then(() => process.exit(0))
  .catch(e => {
    console.log(e);
    process.exit(1);
  });