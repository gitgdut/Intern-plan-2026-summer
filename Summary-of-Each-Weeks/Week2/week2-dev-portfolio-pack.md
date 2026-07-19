# Week 2 Dev Portfolio Pack 

---

## 一、我想做什么

**一个能读链上数据 + AI 出摘要的 Go 命令行工具。**

最终形态：用户输入地址 → 工具查 ETH 余额 + ERC-20 → AI 生成「你持有 X ETH、Y USDC，总估值 $Z」的自然语言摘要。

---

## 二、我实际做到了哪一步

### ✅ 已完成

| 项目 | 说明 | 链接 |
|------|------|------|
| **Portfolio CLI** | Go 读 Sepolia ETH 余额 + mock 代币，5s 超时 fallback | https://github.com/gitgdut/portfolio-cli |
| **Uniswap V2 Minimal** | Solidity 最小实现，x*y=k，6/6 测试通过 | https://github.com/gitgdut/uniswap-v2-minimal |

### 运行证据

```
──────────────────────────────────────────────────
📍 地址: 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045
──────────────────────────────────────────────────
ETH:  0.000000 ETH (查询超时，使用 mock 数据)
USDC:  1000.00 ($1000.00)
UNI:  50.00 ($300.00)
──────────────────────────────────────────────────
💰 总估值: ≈ $1300+ETH (mock token 价格)
🤖 AI 摘要: 待接入 DeepSeek API
```

### ⏳ 下周待做

| 模块 | 当前状态 | 下周 |
|------|---------|------|
| ETH 余额 | ✅ go-ethereum + Sepolia | 换国内可用的 RPC |
| ERC-20 余额 | ❌ mock | 接真实 USDC 合约 |
| 代币价格 | ❌ mock | CoinGecko API |
| AI 摘要 | ❌ 占位 | DeepSeek API |

---

## 三、AI Collaboration Log

### Uniswap V2 开发中的协作

| AI 做的 | 人做的 |
|---------|--------|
| 读 Uniswap V2 文档，中文总结 x*y=k 机制 | — |
| 生成完整 Solidity 合约骨架 + 4 个测试 | 发现并修复 2 个关键 bug |
| 写注释和 [AI 辅助实现] 标记 | 跑 `forge test` 验证，修正测试用例 |

**AI 不能做的事：**
1. 自己跑测试验证——代码看起来自洽，一跑就暴露 bug
2. 判断 K 检查是否真的有效——需要理解数学
3. 决定代码简化到什么程度——这是人的设计判断

---

## 四、Known Issues

| 问题 | 影响 | 状态 |
|------|------|------|
| Sepolia RPC 国内直连超时 | ETH 余额退化为 mock | 已做 5s 超时 + fallback |
| ERC-20 余额为写死数据 | 只能演示 ETH 查询 | 下周接真实合约 |
| 无 AI 摘要 | 输出为结构化数据 | 下周接 DeepSeek API |
| Uniswap V2 无 Factory 合约 | 只能手动部署 Pair | 学习用途已够 |

---

## 五、Week 3 我能承担什么开发角色

**Go 后端 + Solidity 合约。**

| 能做 | 证据 |
|------|------|
| Go 连链读写 | portfolio-cli（go-ethereum, Sepolia RPC） |
| Solidity 合约开发测试 | Uniswap V2 minimal（Foundry, 6/6 测试） |
| Web3 协议接入 | Moss PR #92（TypeScript, Monad 主网适配器） |
| 开源协作 | 2 个 PR 提交给 Moss（代码 + 文档） |

**不能做：** 前端 UI（不会写完整前端项目）。

**需要队友：** 1 个前端 + 1 个合约互相 review。

---

## 附录：所有 Dev 相关产出

| 产出 | 链接/位置 |
|------|----------|
| Portfolio CLI 代码 | https://github.com/gitgdut/portfolio-cli |
| Portfolio CLI README | 同上 repo |
| Uniswap V2 代码 | https://github.com/gitgdut/uniswap-v2-minimal |
| AI Collaboration Log | 本文档第三部分 |
| Week 3 Role Statement | `submissions/week3-self-intro.md` |
