require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config(); // 加载环境变量

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/6b7f3960da564093ade725a5b8e6d3b4", // 替换为 Sepolia API 的节点 URL
      accounts: [process.env.PRIVATE_KEY], // 设置部署账户的私钥
    },
  },
};
