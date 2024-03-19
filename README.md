原项目地址：https://github.com/TechPlanB/Dynamic-NTF
主要改进：
1. 重写了测试文件
2. 更新了chainlink最新版本的路径导入

## Model合约
主要作用：
Models合约的主要功能如下：
1.  NFT（非同质化代币）发行：Models合约继承了ERC721标准，实现了NFT的发行和管理功能。用户可以通过调用mint和preMint函数购买NFT，同时实现了限制每个地址持有NFT的数量以及限制总发行数量的功能。 
2.  链下数据处理：合约中使用Chainlink提供的VRF（可验证随机函数）功能，从链下获取随机数，并根据随机数的值选择对应的元数据，更新NFT的URI（统一资源标识符），实现了基于链下数据的NFT特性更新。 
3.  元数据管理：合约中定义了多个元数据列表，包含不同等级的NFT元数据URL。根据链下随机数的值，选择相应的元数据URL作为NFT的URI，以展示不同等级的NFT。 
4.  状态更新：合约中实现了根据温度等级更新NFT状态的逻辑。根据外部传入的温度值，合约根据不同的温度范围将NFT的状态更新为相应的等级，从而实现了温度对NFT状态的影响。 
5.  权限控制：合约中实现了管理员权限控制功能，只有合约的所有者才能执行特定的操作，例如添加白名单、切换模式等。 
6.  事件通知：合约中定义了多个事件，包括NFT发行请求、NFT发行成功等，以便监控合约的状态变化和操作情况。 
7.  安全性保障：合约中采取了多项安全性措施，包括权限控制、限制NFT发行数量、限制NFT持有数量等，提高了合约的安全性和稳定性。 
获取随机数流程：
1. 主要由ChainlinkClient组成
2. 初始化VRFCoordinatorV2Interface
3. 使用requestRandomWords函数发起请求
4. 在回调函数fulfillRandomWords中获取随机数并使用
### 主要结构体
![image](https://github.com/cxp-13/dynamic-nft/assets/84974164/e1e498e8-f9cd-4dd9-a3be-3c41fff22d1f)
### 用户铸造时序图
![image](https://github.com/cxp-13/dynamic-nft/assets/84974164/56b49b66-0a84-4792-a013-e8283a4abe24)
## weatherRequestConsumer合约
主要功能：
WeatherRequestConsumer合约的主要功能如下：
1.  链下数据请求：合约使用Chainlink提供的功能从外部API获取天气数据。通过调用requestCurrentWeather函数，合约向指定的API发出请求，并通过Chainlink服务获取当前天气温度。 
2.  链下数据处理：合约接收来自Chainlink的链下数据响应，并将响应中的天气温度信息作为参数传递给Models合约的changeERTStatus函数，从而实现了根据外部天气温度更新NFT状态的功能。 
3.  权限控制：合约实现了权限控制功能，只有授权的用户才能调用requestCurrentWeather函数发起天气数据请求，以及其他需要权限的操作。 
4.  事件通知：合约定义了多个事件，包括请求天气数据、接收天气数据响应等，以便监控合约的状态变化和操作情况。 
5.  安全性保障：合约采取了权限控制和事件通知等措施，提高了合约的安全性和稳定性，防止未授权的操作和异常情况对合约造成损害。 
6.  链下服务配置：合约在部署时需要配置链下服务的相关参数，包括链下API的地址、Chainlink节点的地址等。 
### 基本架构图：
![image](https://github.com/cxp-13/dynamic-nft/assets/84974164/939f229f-429b-4804-9954-44325fd915fe)
获取温度流程：
1. 构建请求buildChainlinkRequest
2. 向节点发送get请求sendChainlinkRequestTo
3. 节点回调fulfillWeather函数，返回天气温度
4. 调用Model合约的changeERTStatus函数改变温度
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
