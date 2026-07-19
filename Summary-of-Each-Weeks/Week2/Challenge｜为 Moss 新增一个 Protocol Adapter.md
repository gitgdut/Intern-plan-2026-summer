# 为 Moss 新增一个 Protocol Adapter



##  Pull Request 链接

**https://github.com/nishuzumi/moss/pull/92**

## GitHub 用户主页

https://github.com/gitgdut

## Adapter 名称

@themoss/protocol-fastlane

##  Adapter 的功能介绍

**FastLane shMONAD = Monad 上的"活期存款"**

类比传统银行：

**存人民币到银行**

• 传统金融: 存人民币到银行

• FastLane shMONAD: 存 MON 到 FastLane

**银行给你一张存单**

• 传统金融: 银行给你一张存单

• FastLane shMONAD: 得到 **shMON** 代币（你的"存单"）

**银行拿你的钱去放贷赚利息**

• 传统金融: 银行拿你的钱去放贷赚利息

• FastLane shMONAD: FastLane 拿 MON 去质押给验证节点赚收益

**存单的价值随时间增长**

• 传统金融: 存单的价值随时间增长

• FastLane shMONAD: **shMON 能换回的 MON 越来越多**（吃利息）

**随时可以拿存单取回钱**

• 传统金融: 随时可以拿存单取回钱

• FastLane shMONAD: 随时用 shMON 换回 MON（unlock）

**核心逻辑**



```
你存 1 MON  →  FastLane 给你 ~1 shMON
                                      ↓
                    FastLane 拿 MON 去帮验证节点质押
                                      ↓
                    节点出块产生收益
                                      ↓
未来 1 shMON ≈ 1.05 MON（价值变多了）
```

这就是 **LST（Liquid Staking Token，流动性质押代币）**——你既能赚质押收益，手里的 shMON 还能随时交易、转账（流动性不锁死）。

我们写的 Adapter 就是让 AI Agent 能自动执行这个"存款 / 取款"操作。

