// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// import "@chainlink/contracts/node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/vendor/openzeppelin-solidity/v4.8.0/contracts/utils/Counters.sol";
// import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
// import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
// import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
import "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";

error NOT__IN__WHITE__LIST();
error NO__ENOUGH__ETH();
error MAX__NUMBER__OF__ETC__OVER__1();
error OVER__MAX__NUM__OF__BES();
error IpfsNFT__TransferFailed();

contract Models is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    Ownable,
    VRFConsumerBaseV2
{
    using Counters for Counters.Counter;

    mapping(uint => string[]) private allMetaData;
    uint private lengthOfMetaData;

    mapping(address => bool) private whiteList;

    uint private immutable maxNumberOftoken;

    WindowState private currentWindowState;

    //All variables blow are belong to VRF
    VRFCoordinatorV2Interface COORDINATOR;

    // Your subscription ID.
    uint64 immutable s_subscriptionId;

    // bytes32 keyHash = Sepolia 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;
    // Goerli 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15
    bytes32 immutable keyHash;
    uint32 public immutable callbackGasLimit;

    // The default is 3, but you can set this higher.
    uint16 constant requestConfirmations = 3;

    // For this example, retrieve 2 random values in one request.
    // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
    uint32 constant numWords = 1;

    /* requestId --> NFT TOKEN */
    mapping(uint256 => uint) public resToToken;

    // configure a default value for 10
    int256 public currentDegree = 20;

    // configure a default value for Warm
    DegreeState public currentDegreeLevel = DegreeState.Warm;

    mapping(uint => uint) tokenIdtoModeValue;

    Counters.Counter private _tokenIdCounter;

    enum WindowState {
        PreMintWindow,
        MintWindow
    }

    enum DegreeState {
        Warm, // 15< x > 30
        Hot, // 30 <= x
        Cool, // 5 < x >= 15
        Cold // x <=5
    }

    event MintRequest(uint256 indexed requestId);
    event MintSuccess(uint256 indexed requestId);

    /**
     *  hardcode for SEPOLIA 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625
     *  hardcode for Goerli  0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D
     * */
    constructor(
        uint _maxNumberOftoken,
        uint64 _subscriptionId,
        address _VRFADDRESS,
        bytes32 _keyHash
    )
        ERC721("MODELS", "MDS")
        VRFConsumerBaseV2(_VRFADDRESS)
        Ownable(msg.sender)
    {
        COORDINATOR = VRFCoordinatorV2Interface(_VRFADDRESS);
        keyHash = _keyHash;
        s_subscriptionId = _subscriptionId;
        currentWindowState = WindowState.PreMintWindow;
        callbackGasLimit = 250000;
        maxNumberOftoken = _maxNumberOftoken;
        string[] storage AliPics = allMetaData[0];
        AliPics.push(
            "https://ipfs.filebase.io/ipfs/QmRaYSHrPyKyvMbtWGh9WCEQkqbgRtVh3wPezKzwBkMWXL"
        );
        AliPics.push(
            "https://ipfs.filebase.io/ipfs/Qmbs3QcGaKao9pPszzuYqsrUhEKC6nh1sXQrPRYpp2fx3G"
        );
        AliPics.push(
            "https://ipfs.filebase.io/ipfs/QmRs3fNGpwkXfYkcojDrV8inp3NGWAX9Cj41Y1321ZTpoL"
        );
        AliPics.push(
            "https://ipfs.filebase.io/ipfs/QmaFL6iYQ2KvYFsVDEfcAKg3ApdX7Gc1AmfRznuaU6CYPy"
        );
        string[] storage HarshPics = allMetaData[1];
        HarshPics.push(
            "https://ipfs.filebase.io/ipfs/QmV33JkRRmRJVyx5cMJMsdhjLFmhFqceNNidXQVQ4n59cE"
        );
        HarshPics.push(
            "https://ipfs.filebase.io/ipfs/QmTAPAPPuz8x5uDfVAYdqquX8aK1MozKgGyjzYDah3L5sp"
        );
        HarshPics.push(
            "https://ipfs.filebase.io/ipfs/QmZNZ9JhSH1Z26sMpMbzCBf3VzPogkDMtuXWWS9ceb5fNx"
        );
        HarshPics.push(
            "https://ipfs.filebase.io/ipfs/Qmbj3ztbvQq2PAkCcreVZfBt1699cDSrWwZRN9CVCezfYA"
        );
        string[] storage MyicahelPics = allMetaData[2];
        MyicahelPics.push(
            "https://ipfs.filebase.io/ipfs/QmVsuhSmR5BmuaNCghUvX3B397yyKHNkS5PWMKyCbs2maj"
        );
        MyicahelPics.push(
            "https://ipfs.filebase.io/ipfs/QmX4SLs4SAWpk2RStDxw29mzkMZwDkeEjKFxZqEuhoXo9v"
        );
        MyicahelPics.push(
            "https://ipfs.filebase.io/ipfs/QmTh3FT6sTe9KfDVv61Zf3J3Qy9YFP4m69UGZddZ4deKNi"
        );
        MyicahelPics.push(
            "https://ipfs.filebase.io/ipfs/QmPLdY8Me41618WhaqLickpwXrzYx5vPHienELhBbJt9hj"
        );
        string[] storage KietPics = allMetaData[3];
        KietPics.push(
            "https://ipfs.filebase.io/ipfs/QmfLV6wQDh8kCZxUM7sYhK8BdVrzJ2fK7GUGfpvHtXxGPA"
        );
        KietPics.push(
            "https://ipfs.filebase.io/ipfs/QmYRdwqFo3p1EEDZuJf9MBQuFNcNHup9zD751WQAaBSSM1"
        );
        KietPics.push(
            "https://ipfs.filebase.io/ipfs/QmSnZT33AkmGuUEyrMf6P8qjFV7N7oubAjSvh2BfEiHVAv"
        );
        KietPics.push(
            "https://ipfs.filebase.io/ipfs/QmYBFkTDRdhk6qHhHPEQvERTd7DAFxp5fecReNXxiEUUs7"
        );
        lengthOfMetaData = 4;
    }

    modifier onlyPreMintWindow() {
        require(
            currentWindowState == WindowState.PreMintWindow,
            "PreMint has not opened yet!"
        );
        _;
    }

    modifier onlyMintWindow() {
        require(
            currentWindowState == WindowState.MintWindow,
            "Mint has not opened yet!"
        );
        _;
    }

    // 正常铸造
    function mint() public payable onlyMintWindow {
        require(
            msg.value == 0.0005 ether,
            " The price of each MDS is 0.0005 ether."
        );
        if (balanceOf(msg.sender) >= 1) revert MAX__NUMBER__OF__ETC__OVER__1();
        if (totalSupply() >= maxNumberOftoken) revert OVER__MAX__NUM__OF__BES();
        request();
    }

    // 白名单的用户提前铸造
    function preMint() public payable onlyPreMintWindow {
        require(
            msg.value == 0.0001 ether,
            " The price of each MDS is 0.0001 ether."
        );
        if (!whiteList[msg.sender]) revert NOT__IN__WHITE__LIST();
        if (balanceOf(msg.sender) >= 1) revert MAX__NUMBER__OF__ETC__OVER__1();
        if (totalSupply() >= maxNumberOftoken) revert OVER__MAX__NUM__OF__BES();
        request();
    }

    // 添加白名单
    function addWhiteList(address[] calldata addresses) public onlyOwner {
        for (uint i = 0; i < addresses.length; i++) {
            whiteList[addresses[i]] = true;
        }
    }

    // 切换到正常模式
    function transferWindowState() public onlyOwner {
        if (currentWindowState == WindowState.PreMintWindow) {
            currentWindowState = WindowState.MintWindow;
        }
    }

    // 获取当前模式
    function getCurrentWindowState() public view returns (WindowState) {
        return currentWindowState;
    }

    // 获取最大可以铸造的代币数量
    function getMaxNumberOftoken() public view returns (uint) {
        return maxNumberOftoken;
    }

    // 假设订阅资金充足。
    function request() internal returns (uint256 requestId) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();

        // 如果订阅没有设置和资金，将恢复。
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        // 不要在fulfillRandomWords中放入_safeMint函数，它将比您配置的callbackGasLimit花费更多的汽油
        _safeMint(msg.sender, tokenId);
        resToToken[requestId] = tokenId;
        emit MintRequest(requestId);
    }

    // VRF 的回调函数
    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        // 获取当前模式
        uint256 modeValue = (_randomWords[0] % lengthOfMetaData);
        uint tokenId = resToToken[_requestId];
        tokenIdtoModeValue[tokenId] = modeValue;
        // 根据上面配置的元数据，使用暖和作为默认天气
        _setTokenURI(tokenId, allMetaData[modeValue][uint8(DegreeState.Warm)]);
        emit MintSuccess(_requestId);
    }

    // 根据温度改变当前的温度等级
    function changeERTStatus(int256 _degree) public {
        // 比较新温度和当前温度之间的差异
        if (_degree != currentDegree) {
            // 如果有差异，则将最新温度更改为当前温度
            currentDegree = _degree;
            // 比较新温度和当前温度等级之间的等级
            DegreeState newDegreeLevel = checkWheatherLevel(_degree);
            if (newDegreeLevel != currentDegreeLevel) {
                // 如果有差异，则将最新温度等级更改为当前温度等级
                currentDegreeLevel = newDegreeLevel;
                // 更新 ERC 的元数据
                uint totalSupply = totalSupply();
                for (uint i = 0; i < totalSupply; i++) {
                    // i == tokenId
                    uint modeValue = tokenIdtoModeValue[i];
                    _setTokenURI(
                        i,
                        allMetaData[modeValue][uint8(currentDegreeLevel)]
                    );
                }
            }
        }
    }

    // 根据温度判断当前等级
    function checkWheatherLevel(
        int256 _degree // 10.9 摄氏度会返回1090
    ) private pure returns (DegreeState) {
        if (_degree >= 30 * 100) {
            return DegreeState.Hot;
        } else if (_degree > 15 * 100) {
            return DegreeState.Warm;
        } else if (_degree > 5 * 100) {
            return DegreeState.Cool;
        } else {
            return DegreeState.Cold;
        }
    }

    // 取出存在该合约的全部钱
    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        if (!success) {
            revert IpfsNFT__TransferFailed();
        }
    }

    // 获取当前温度
    function getCurrentDegree() public view returns (int256) {
        return currentDegree;
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
