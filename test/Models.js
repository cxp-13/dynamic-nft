// const { ethers } = require("ethers");
require("dotenv").config();
const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Models Contract", function () {
  // 配置以太坊网络和合约地址
  const contractAddress = "0xdF99078fF4a18153380499965bfA534ED307F57E"; // 合约地址
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
  const abi = [
    "function mint() public payable onlyMintWindow",
    "function preMint() public payable",
    "function addWhiteList(address[] addresses) public",
    "function transferWindowState() public",
    "function getCurrentDegree() view returns (int256)",
    "function getCurrentWindowState() view returns (uint8)",
    "function getMaxNumberOftoken() view returns (uint256)",
    "function withdraw() payable",
    "function changeERTStatus(int256 _degree) public",
    "function tokenURI(uint256 tokenId) public view returns (string memory)",
    "function balanceOf(address owner) public view virtual returns (uint256)",
  ];
  let contract = null;

  beforeEach(async function () {
    contract = new ethers.Contract(contractAddress, abi, wallet);
    console.log("Contract loaded:", contract.target);
  });

  it("Should mint new token for user", async function () {
    await contract.addWhiteList([wallet2]);
    await contract
      .connect(wallet2)
      .preMint({ value: ethers.parseEther("0.0001") });
  });

  it("Should withdraw", async function () {
    let balanceBefore = await provider.getBalance(contract.target);
    balanceBefore = ethers.formatEther(balanceBefore);
    await contract.withdraw();
    let balanceAfter = await provider.getBalance(contract.target);
    balanceAfter = ethers.formatEther(balanceAfter);
    console.log("balanceBefore", balanceBefore, "balanceAfter", balanceAfter);
  });

  it("Print TokenURI", async function () {
    let tokenURI = await contract.tokenURI(0);
    let tokenURI1 = await contract.tokenURI(1);
    console.log("Token URI:", tokenURI, tokenURI1);
  });

  it("Test transferWindowState", async function () {
    await contract.transferWindowState();
    let curState = await contract.getCurrentWindowState();
    console.log("Current state:", curState);
  });

  it("Change the degree", async function () {
    await contract.changeERTStatus(36);
    let degree = await contract.getCurrentDegree();
    console.log("Current degree:", degree.toString());
  });
});
