require("dotenv").config();
const { ethers } = require("hardhat");
const { expect } = require("chai");

// 确保该合约有足够的LINK代币！！！
describe("WeatherRequestConsumer Contract", function () {
  // 配置以太坊网络和合约地址
  const weatherRequestConsumerAddress =
    "0xbFA7537F7Fa20b87058b8838aF2826F11760cb75"; 
  const modelAddress = "0xdF99078fF4a18153380499965bfA534ED307F57E"; 
  const linkAddress = "0x779877A7B0D9E8603169DdbD7836e478b4624789";

  // 配置以太坊账号私钥
  const privateKey = process.env.PRIVATE_KEY;
  const privateKey2 = process.env.PRIVATE_KEY2;

  // 实例化一个以太坊 provider
  const INFURA_SEPOLIA_URL =
    "https://sepolia.infura.io/v3/6b7f3960da564093ade725a5b8e6d3b4";
  const provider = new ethers.JsonRpcProvider(INFURA_SEPOLIA_URL);
  // 实例化一个以太坊签名者（wallet）
  const wallet = new ethers.Wallet(privateKey, provider);
  const wallet2 = new ethers.Wallet(privateKey2, provider);

  // 实例化智能合约接口
  const weatherRequestConsumerAbi = [
    "function withdrawLink() public",
    "function requestCurrentWeather() public",
    "function addRequestedPromision(address _user) public",
    "function changeUrlforWeather(string calldata _url) public",
  ];
  const modelAbi = ["function getCurrentDegree() view returns (int256)"];
  let weatherRequestConsumerContract = null;
  let modelContract = null;

  beforeEach(async function () {
    weatherRequestConsumerContract = new ethers.Contract(
      weatherRequestConsumerAddress,
      weatherRequestConsumerAbi,
      wallet
    );
    modelContract = new ethers.Contract(modelAddress, modelAbi, wallet);
    console.log("Contract loaded:", weatherRequestConsumerContract.target);
  });

  it("Should request current weather", async function () {
    await weatherRequestConsumerContract.requestCurrentWeather();
    let curDegree = await modelContract.getCurrentDegree();
    console.log("Current degree:", curDegree.toString());
  });
});
