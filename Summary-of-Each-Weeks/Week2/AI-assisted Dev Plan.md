 # AI-assisted Dev Plan



**我要做的最小功能是什么？**
  一个 Go 命令行工具，用户输入以太坊地址 → 工具读链上余额 →
  AI 生成人类可读的持仓摘要。

**谁会使用它？**
  懒得打开 Etherscan 翻余额的 Web3 用户。

**用户完成的一个动作是什么？**
  $ portfolio 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045
  → 「你持有 0.5 ETH、1000 USDC、3 个 NFT，总估值约 $2500」

**我需要读哪 1–3 个文档？**

  1. https://goethereumbook.org/en/account-balance/  （读 ETH 余额）
  2. https://goethereumbook.org/en/erc20/               （读 ERC-20 余额）
  3. Go 调用 OpenAI/DeepSeek API（任意一篇教程即可）

**本周真实实现什么？哪些可以 mock？**

| 模块           | 真实做              | mock                       |
| -------------- | ------------------- | -------------------------- |
| 读 ETH 余额    | ✅ 连 Sepolia 测试网 | 不用 mock，测试网免费      |
| 读 ERC-20 余额 | ✅ 查 1-2 个代币合约 | 代币列表写死，不做自动发现 |
| AI 摘要生成    | ✅ 调用 DeepSeek API | 提示词写死，不做复杂对话   |
| 价格估值       | mock 写死           | CoinGecko API 下周再说     |
| NFT 检测       | mock 跳过           | 第一期不做                 |

**我如何证明它做出来了？**
  录一个 30 秒终端截图：
  输入命令 → 输出持仓摘要 → 结束。