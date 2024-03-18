const { ethers } = require("hardhat");
const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const JOB_ID = "fcf4140d696d44b687012232948bdd5d";
const ORACLE = "0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD";
const LINK_ADDRESS = "0x779877A7B0D9E8603169DdbD7836e478b4624789";
const MODEL_ADDRESS = "0xdF99078fF4a18153380499965bfA534ED307F57E";

module.exports = buildModule("WeatherRequestConsumer", (m) => {
  const jobId = m.getParameter("jobId", JOB_ID);
  const oracle = m.getParameter("oracle", ORACLE);
  const linkAddress = m.getParameter("linkAddress", LINK_ADDRESS);
  const oracleAddress = m.getParameter("oracleAddress", MODEL_ADDRESS);

  const weatherRequestConsumer = m.contract("WeatherRequestConsumer", [
    jobId,
    oracle,
    linkAddress,
    oracleAddress,
  ]);

  return { weatherRequestConsumer };
});
