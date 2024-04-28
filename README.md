### Random Number Generation Process:
1. Mainly composed of `ChainlinkClient`.
2. Initialize `VRFCoordinatorV2Interface`.
3. Use `requestRandomWords` function to initiate the request.
4. Obtain and utilize the random number in the callback function `fulfillRandomWords`.

### Main Structs:
![image](https://github.com/cxp-13/dynamic-nft/assets/84974164/e1e498e8-f9cd-4dd9-a3be-3c41fff22d1f)

### User Minting Sequence Diagram:
![image](https://github.com/cxp-13/dynamic-nft/assets/84974164/56b49b66-0a84-4792-a013-e8283a4abe24)

## `WeatherRequestConsumer` Contract
Main functionalities:
1. Off-chain data request: The contract utilizes functionalities provided by Chainlink to fetch weather data from an external API. By calling the `requestCurrentWeather` function, the contract sends a request to the specified API and retrieves the current weather temperature via Chainlink service.
2. Off-chain data processing: The contract receives off-chain data responses from Chainlink and passes the weather temperature information from the response as a parameter to the `changeERTStatus` function of the Models contract, thereby updating the NFT status based on external weather temperature.
3. Access control: The contract implements access control functionality, allowing only authorized users to call functions such as `requestCurrentWeather` to initiate weather data requests and other privileged operations.
4. Event notification: The contract defines multiple events, including requesting weather data, receiving weather data responses, etc., for monitoring the contract's state changes and operation status.
5. Security measures: The contract adopts security measures such as access control and event notification to enhance contract security and stability, preventing unauthorized operations and handling exceptional situations.
6. Off-chain service configuration: The contract requires configuration of off-chain service parameters during deployment, including off-chain API addresses, Chainlink node addresses, etc.

### Basic Architecture Diagrams:
![image](https://github.com/cxp-13/dynamic-nft/assets/84974164/02832a3a-d528-4c16-ab49-51b2a21e1937)
![image](https://github.com/cxp-13/dynamic-nft/assets/84974164/939f229f-429b-4804-9954-44325fd915fe)

### Temperature Retrieval Process:
1. Construct request using `buildChainlinkRequest`.
2. Send GET request to node using `sendChainlinkRequestTo`.
3. Node callback triggers `fulfillWeather` function, returning weather temperature.
4. Call `changeERTStatus` function of Models contract to alter temperature.


# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```
