# 对Moss的理解

## 收藏截图

![](C:\Users\wangy\AppData\Roaming\Typora\typora-user-images\image-20260715160646416.png)



## Moss的本质

**Moss** 是一个面向 [Monad](https://monad.xyz/) 区块链的 Agent 交易中间层，核心理念是：**Agent 不应该自己手搓 calldata，Moss 帮你把复杂的 DApp 交互封装成统一、安全的能力调用**。



## Moss解决的问题

以"简单"的 DEX swap 为例，Agent 要自己搞定：router 地址、exact-in/exact-out 变体、原生代币包装/解包、refund/sweep 清理调用、滑点小数精度计算……任何一步出错都可能丢钱。

Moss 把这一切抽象成一个统一流程：



```
discover → load → action → simulate
```

Agent 只需要用人话描述意图（"用 1 MON 换 USDC"），Moss 负责组装正确的交易。



## 应用场景

随着未来区块链的功能越来越多，链上操作的过程越来越复杂，Moss能够在保证用户操作安全的情况下简化操作，使得用户的使用体验大大提升，这在大多数区块链应用都能用到，比如游戏、DAO治理、多功能钱包等等，降低用户的难度有利于这些链上应用的普及。

