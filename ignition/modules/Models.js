const { ethers } = require("hardhat");
const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const MAX_NUMBER_OF_TOKEN = 1893456000;
const subscription_ID = 10279n;


module.exports = buildModule("ModelsModule", (m) => {
  const maxNumberOftoken = m.getParameter("maxNumberOftoken", MAX_NUMBER_OF_TOKEN);
  const subscriptionId = m.getParameter("subscriptionId", subscription_ID);
  // const VRFADDRESS = m.getParameter("VRFADDRESS", VRFADDRESS);
  // const keyHash = m.getParameter("keyHash", keyHash);
  const VRFADDRESS = "0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625";
  const keyHash = "0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c";


  const models = m.contract("Models", [maxNumberOftoken, subscriptionId,VRFADDRESS, keyHash]);

  return { models };
});
