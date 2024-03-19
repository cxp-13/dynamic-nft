原项目地址：https://github.com/TechPlanB/Dynamic-NTF
主要改进：
1. 重写了测试文件
2. 更新了chainlink最新版本的路径导入

## Model合约
### 主要结构体
![image](https://github.com/cxp-13/dynamic-nft/assets/84974164/e1e498e8-f9cd-4dd9-a3be-3c41fff22d1f)
### 用户铸造时序图
![image](https://github.com/cxp-13/dynamic-nft/assets/84974164/56b49b66-0a84-4792-a013-e8283a4abe24)
## weatherRequestConsumer合约
基本架构图：
![image](https://github.com/cxp-13/dynamic-nft/assets/84974164/939f229f-429b-4804-9954-44325fd915fe)

获取随机数流程：
1. 主要由ChainlinkClient组成
2. 初始化VRFCoordinatorV2Interface
3. 使用requestRandomWords函数发起请求
4. 在回调函数fulfillRandomWords中获取随机数并使用

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
