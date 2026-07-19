# Moss 开源贡献计划

## Builder 身份

**Dev Builder** — 提交 Pull Request，为 Moss 开发新的 Protocol Adapter。

---

## 贡献方向

为 Moss 新增一个 **Monad 链上协议适配器（Protocol Adapter）**，让 AI Agent 可以通过 Moss 的标准化流程（discover → load → action → simulate）安全调用该协议。

---

## 为什么选这个方向

1. **Moss 最明确的贡献入口**：官方提供了 Protocol 模板（`packages/protocols/_template`）和完整的[接入指南](https://github.com/nishuzumi/moss/blob/main/docs/protocol-onboarding.md)，有清晰的 checklist 和 review 标准。
2. **独立性强**：新增 Protocol 包不会改动 core、simulator 等核心模块，PR 边界清晰，review 摩擦小。
3. **目前生态还很早期**：Moss 当前只支持 WMON、ERC-20/721、Kuru 四个协议，有大量 Monad 生态协议等待接入，贡献空间大。
4. **匹配我的技术栈**：项目使用 TypeScript + pnpm monorepo + vitest，是我熟悉的技术组合。

---

## 本周目标

**完成一个 Monad 协议适配器的开发，提交 Pull Request。**

### 预计产出

| 产出物 | 说明 |
| --- | --- |
| Protocol 包 | `@themoss/protocol-xxx`，包含 Capability、Query、Receipt |
| ABI 文件 | 有明确来源标注（compiled/explorer/vendored），走 ADR 0007 规范 |
| 地址验证 | 固定合约地址 + 链上 bytecode 检查 + token metadata 校验 |
| 参数契约 | Zod 类型定义，type 与 description 分离 |
| 单元测试 | 类型 fixture、tree 验证、Receipt 覆盖、失败用例 |
| E2E 测试 | 在 Monad 主网上跑通 happy path，零 Warning |
| Changeset | `pnpm changeset` 生成版本变更记录 |

---

## 本周计划

### Day 1 — 调研与环境搭建

- [ ] 浏览 [Monad 生态](https://monad.xyz) 选择一个适合接入的协议：
  - 优先选有**已验证合约**（Monad 浏览器可查 ABI）的协议
  - 优先选操作简洁的协议（如 staking/lending 的基础功能），避免一次性做太复杂
  - 候选方向：LSD（流动性质押）、Lending、Bridge
- [ ] Fork 仓库：`gitgdut/moss`
- [ ] `git clone` → `pnpm install` → `pnpm build` → `pnpm test`（用 `MOSS_SKIP_E2E=1` 先验证工具链）
- [ ] 跑通现有示例：`pnpm --filter @themoss/example-simple-flow swap`
- [ ] 阅读 `CONTEXT.md`、`docs/adr/` 中相关架构决策

### Day 2 — ABI 与地址准备

- [ ] 从 Monad 浏览器获取目标协议的已验证合约 ABI
- [ ] 按 ADR 0007 规范标注 ABI 来源（`explorer` 类型，附 URL + 日期）
- [ ] 验证固定合约地址：链上 bytecode 存在性 + token metadata（如是代币合约）
- [ ] 复制模板：`cp -R packages/protocols/_template packages/protocols/myprotocol`
- [ ] 替换所有 `CHANGEME` 标记，设置 package name + metadata

### Day 3 — Capability 与 Query 开发

- [ ] 定义 `@Protocol` 装饰器：name、category、contracts、依赖声明
- [ ] 定义 Zod 参数契约：type（上下文无关的值约束）+ description（字段用途）
- [ ] 实现 Capability（写操作）：
  - 每个 Capability 恰好一个直接 TransactionNode + 一个 Receipt parser
  - 需要 approve 时嵌套 ERC-20 Capability
- [ ] 实现 Query（只读操作）：报价、余额等

### Day 4 — Receipt 解析器

- [ ] 为每个 Capability 编写纯 Receipt parser
- [ ] 解析有序 Change（Event + native MON transfer）
- [ ] 保留原始 Change 对象的引用、长度、顺序
- [ ] 处理变更区间委托（跨协议 Receipt 调用）
- [ ] 输出结构化 Outcome + 人类可读文本

### Day 5 — 测试与验证

- [ ] 编译时类型 fixture：正向 + `@ts-expect-error` 反向用例
- [ ] 单元测试：Registry metadata、单交易约束验证
- [ ] Receipt 测试：完整覆盖、缺失 Change、重复 Change、重排 Change
- [ ] 链上 E2E：Monad 主网 happy path，零 Warning
- [ ] 运行完整验证流程：`pnpm lint` → `pnpm build` → `pnpm typecheck` → `pnpm test`

### Day 6 — 文档与提 PR

- [ ] 为 Protocol 包写 README：功能说明、参数单位、默认值、风险标签、地址来源、已知限制
- [ ] 从 `src/index.ts` 导出 Protocol class
- [ ] `pnpm changeset` 生成变更记录
- [ ] 基于 `main` 分支创建 PR
- [ ] PR 描述包含：live simulation 证据、框架影响说明、checklist 对照
- [ ] 按 `CONTRIBUTING.md` 完成 self-review

---

## 风险与预案

| 风险 | 预案 |
| --- | --- |
| 目标协议合约未开源/未验证 | 换一个有已验证合约的协议（LSD 类通常都是开源的） |
| `debug_traceCall` 在目标协议上失败 | 确认 RPC endpoint 支持；换 `https://rpc.monad.xyz` |
| Monad 主网 RPC 不稳定 | 用 `MOSS_SKIP_E2E=1` 先保证单元测试通过，E2E 可后补 |
| 协议依赖未在 `@themoss/system` 中定义 | 动态地址从链上获取，固定地址附 canonic source 证明 |
| 时间不够完成全部测试 | 优先保证核心 Capability + Receipt 验证，减少 Capability 数量 |

---

## 提交 Checklist（对照官方要求）

- [ ] Protocol package 从 template 复制，所有 CHANGEME 已替换
- [ ] ABI 有明确来源标注，非手写
- [ ] 固定地址附 canonical source + 链上 bytecode 检查
- [ ] `@Protocol` 类从入口文件直接导出，无额外注册对象
- [ ] 依赖显式声明，通过注入获取类型化实例
- [ ] 每个字段 = `{ type, description }`：type 上下文无关，description 字段专用
- [ ] 每个 Capability 恰好一个直接 TransactionNode + 一个 Receipt parser
- [ ] Receipt parser 是纯函数，保留原始 Change 对象引用、长度、顺序
- [ ] 编译时类型 fixture：正向 + `@ts-expect-error`
- [ ] 单元测试 + Receipt 测试 + 失败用例
- [ ] Monad 主网 happy path E2E，零 Warning
- [ ] `pnpm lint` `pnpm build` `pnpm typecheck` `pnpm test` 全部通过
- [ ] Changeset 已添加
