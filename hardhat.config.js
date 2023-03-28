require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-chai-matchers");

/** @type import('hardhat/config').HardhatUserConfig */
const MY_API_KEY = "QRUIZUNJ91I2I5CJIUD86PGC559654Y8N5";

module.exports = {
  solidity: "0.8.4",

  networks: {
    hardhat: {
      chainId: 1337,
    },
    matic: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: ['29a9a9aac92cef02bf1f97b3da3d1a7cbaa4bdb5140fd65350d4eafa2c09d2a4'],
      api_keys: {
        polygonscan: MY_API_KEY,
      },
    },
   
  }

};
