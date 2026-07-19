#  Moss 介绍



## 提交说明

 本文介绍开源框架 Moss——一个为 AI Agent 安全调用链上协议而设计的基础设施。文章从「Agent 如何安全与 DeFi 交互」的核心难题出发，解析 Moss 的 discover → load → action → simulate 四步标准化流程，并结合代码示例说明其「只构建、不签名」的安全哲学与架构设计。



## 正文

### Moss：让 AI Agent 安全调用链上协议的开源框架

**一句话介绍**

**Moss** 是一个开源 TypeScript 框架，它把 Monad 链上的 DeFi 协议交互，封装成 AI Agent 可以直接调用的标准化「能力（Capability）」。它的核心哲学是：**只构建和验证未签名交易，永不签名、永不发送**。

GitHub: [nishuzumi/moss](https://github.com/nishuzumi/moss)

\---

**AI Agent × Web3 的核心难题**

在 AI Agent 进入 Web3 世界的浪潮中，一个根本性问题浮出水面：

**AI Agent 如何安全、正确地与链上协议交互？**

传统做法是让 Agent 直接操作合约 ABI、手动拼接 calldata、自己管理 multicall 逻辑。但这带来了三个致命问题：

**1. 认知负荷过高**

一个简单的「用 1 MON 换 USDC」操作，Agent 需要知道：
\- Kuru 的合约地址和 ABI
\- USDC 的合约地址
\- swap 函数的参数格式
\- 滑点保护的 bps 表示法
\- 如果是 ERC-20 代币，还需要先 approve

这对人类开发者来说都是繁琐的，对 LLM Agent 来说更是容易出错的噩梦。

**2. 安全边界模糊**

Agent 直接操作 ABI 意味着它可以直接构造任意 calldata。一个微小的幻觉（比如把地址写错一位）就可能导致资金损失。更危险的是，Agent 可能在未经充分验证的情况下就批准交易。

**3. 验证成本高昂**

即使交易执行成功，如何确认结果真的符合用户意图？靠 Agent 自己读交易回执来「理解」发生了什么——这在 LLM 的幻觉倾向下，几乎是在赌博。

\---

**Moss 的解决方案**

Moss 的设计理念来自一个关键洞察：



>  **协议的操作知识应该由协议自己维护，而不是散落在每个 Agent 的 prompt 里。**

它的解决方案可以概括为四个标准化步骤：



```
discover → load → action → simulate
```

**Step 1:** `discover` **— 发现可用的操作**

Agent 不需要预先知道有哪些协议、什么方法。它只需要描述用户想做什么，Moss 的 Registry 就能返回匹配的操作坐标：



```
// 问：有哪些 swap 能力？
{ "verb": "swap" }

// 答：
[{
  "protocol": "kuru",
  "method": "swap",
  "kind": "capability",
  "verb": "swap",
  "category": "dex",
  "tags": [],
  "summary": "Swap tokens on Kuru"
}]
```

**Step 2:** `load` **— 加载操作契约**

选定一个操作后，Agent 需要知道它的完整调用契约——而不是靠猜测。Moss 的 `load` 返回每个参数的两类独立信息：

\- **类型描述（type）**：值本身的格式、单位、约束。比如 `slippage` 的类型会说明它是 basis points，合法范围是 1～5000；
\- **字段描述（description）**：这个参数在当前操作中的具体作用。比如同一个 `slippage` 字段，在 swap 中用于限制价格滑点。

这避免了 Agent 根据参数名猜测含义（比如把 bps 误当成百分比）。

**Step 3:** `action` **— 构建 Capability Tree**

这是 Moss 最核心的设计。Agent 不直接接触 ABI，而是调用 `action`，由 Protocol 包内部完成所有 calldata 构造，返回一棵 **Capability Tree**：



```
Capability: kuru.swap
├── Capability: erc20.approve    (如果输入是 ERC-20)
│   └── Transaction: approve()
└── Transaction: swap()
```

关键设计原则：
\- 每个 Capability **恰好拥有一笔直接交易**和一个 Receipt 解析器
\- 嵌套的 Capability（如 approve）自动组合到树中
\- Agent 永远不需要手动处理这种依赖关系

**Step 4:** `simulate` **— 模拟并验证**

Moss 通过 `debug_traceCall` 在真实链状态上模拟执行，产生**不可变的、有序的原始 Change 记录**。然后每个 Protocol 的 Receipt 解析器将这些 Change 转化为结构化 Receipt，并由 core 递归验证：

\- ✅ 每个 Change 都被 Receipt 覆盖
\- ✅ Change 顺序严格保持
\- ✅ 没有遗漏、重复或重排

任何环节失败（回滚、trace 失败、覆盖不完整）都会产生终止性 **Warning**，Agent 在 Warning 面前必须停止。

\---

**Moss 的安全哲学**

Moss 不是一个「执行引擎」——它**永远不会签名，永远不会发送交易**。这使它处于一个独特的安全位置：



```
用户意图 → Agent (Moss) → 模拟验证 → 签名方（独立）→ 链上执行
                                   ↑
                            签名方独立审查
                            每笔交易的 Receipt
```

这个架构带来了三层安全保证：

1. **构建层安全**：Protocol 包本身经过 review 和测试，是受信任的可执行代码。Agent 只是传递参数，不接触 calldata。



2. **模拟层安全**：通过 `debug_traceCall` 获取真实链上证据，Receipt 解析必须完整覆盖每个 Change。



3. **意图对齐层**：Agent 强制要求将每条有序 Receipt 文本与用户原始请求逐一对比。MCP 工具明确要求：「绝不只因为字符串里包含 'Kuru Swap' 就批准交易。」


\---

**当前生态**

Moss 目前只支持 Monad 主网（chain ID 143），这是一个刻意的设计选择——专注于一个生态，保证质量。

已支持的 Protocol：

**WMON**

• Protocol: WMON

• Capabilities: wrap, unwrap

• Queries: balanceOf

**ERC-20 / 原生 MON**

• Protocol: ERC-20 / 原生 MON

• Capabilities: transfer, approve

• Queries: balanceOf, allowance, metadata

**ERC-721**

• Protocol: ERC-721

• Capabilities: transfer

• Queries: ownerOf, balanceOf

**Kuru (DEX)**

• Protocol: Kuru (DEX)

• Capabilities: swap

• Queries: quote

\---

**代码示例：一次完整的 Swap**
 (1/2)

[GitHub](https://github.com/nishuzumi/moss)
GitHub - nishuzumi/moss
Contribute to nishuzumi/moss development by creating an account on GitHub.

```
import { NATIVE, Registry } from "@themoss/core";
import * as erc from "@themoss/erc";
import * as kuru from "@themoss/protocol-kuru";
import { createTraceSimulator } from "@themoss/simulator";
import * as system from "@themoss/system";
import { monadRuntime, USDC_ADDRESS } from "@themoss/system";

const runtime = await monadRuntime();
const registry = new Registry(runtime).use(system, erc, kuru);
const simulator = createTraceSimulator(runtime, {
  receipt: (capability, changes) => registry.parseReceipt(capability, changes),
});

const account = "0xcccccccccccccccccccccccccccccccccccccccc";

// 1. 先报价
const quote = await registry.action("kuru", "quote", account, {
  tokenIn: NATIVE,
  tokenOut: USDC_ADDRESS,
  amountIn: "1",
});

// 2. 构建 swap Capability
const result = await registry.action("kuru", "swap", account, {
  tokenIn: NATIVE,
  tokenOut: USDC_ADDRESS,
  amountIn: "1",
  slippage: 50, // 0.5%
});

// 3. 模拟执行，验证 Receipt
const simulation = await simulator.simulate(result);
if (simulation.halted || simulation.results.some(r => r.warnings.length > 0)) {
  throw new Error("模拟失败，不要签名！");
}

// 4. 对齐意图
for (const item of simulation.results) {
  console.log(item.receipt?.outcome); // 结构化证据
  console.log(item.receipt?.text);    // 人类可读文本
}
```

\---

**Moss 对 AI Agent × Web3 的意义**

Moss 解决的不是「如何让 Agent 调用链上协议」这个表面问题——这个问题的表面解法（给 Agent 塞 ABI JSON）早就有人做了。

Moss 解决的是更深层的问题：**如何让 Agent 安全地调用链上协议，并且在每一步都有可验证的证据。**

它的贡献在于定义了一种范式：

1. **协议知识下沉**：操作的细节属于 Protocol 包，不属于 Agent
2. **证据驱动**：不是「我执行成功了」，而是「有可验证的有序 Change 记录证明执行成功」
3. **签名分离**：签名的决定权始终属于独立的签名方，Agent 只是构建者
4. **标准化契约**：每种操作都有严格的类型契约，Agent 不需要猜测参数含义


这可能是 AI Agent 安全操作链上资产的基础设施方向之一。

\---

**如何参与**

Moss 是 MIT 开源项目，目前还很早期（23 fork、53 star），正在积极开发中。

\- **阅读文档**：[nishuzumi/moss](https://github.com/nishuzumi/moss) README + docs/
\- **跑通示例**：`pnpm --filter @themoss/example-simple-flow swap`
\- **贡献 Protocol**：从 `packages/protocols/_template` 复制模板，按 [Protocol 接入指南](https://github.com/nishuzumi/moss/blob/main/docs/protocol-onboarding.md) 开发

\---

*本文基于 Moss 仓库 main 分支最新代码撰写，写作时参考了 README、CONTEXT.md、agent-skill.md、mcp-tools.md、getting-started 等官方文档。*

\---

以上就是文章正文。你觉得内容和篇幅合适吗？需要调整的地方告诉我——比如增减某些部分、调整语气、或补充更多技术细节。确认后我帮你存到仓库里。 (2/2)

[GitHub](https://github.com/nishuzumi/moss)
GitHub - nishuzumi/moss
Contribute to nishuzumi/moss development by creating an account on GitHub.