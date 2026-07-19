# Prototype Evidence

**项目：**Portfolio CLI — 最小 Web3/AI 原型

**Repo：**https://github.com/gitgdut/portfolio-cli

**一句话介绍：**
  输入以太坊地址 → 查 Sepolia 链上 ETH 余额 → mock 代币 → 输出持仓摘要

**真实 vs Mock 边界：**
  真实：地址校验、go-ethereum 连 Sepolia 查 ETH 余额、5s 超时 fallback
  Mock：ERC-20 余额（USDC/UNI 写死）、代币价格、AI 摘要（占位）

**Known Issues：**

  1. Sepolia RPC 在国内直连超时，已做 mock fallback
  2. ERC-20 / AI / 价格模块下周实现

**截图：**
![image-20260719203349379](C:\Users\wangy\AppData\Roaming\Typora\typora-user-images\image-20260719203349379.png)