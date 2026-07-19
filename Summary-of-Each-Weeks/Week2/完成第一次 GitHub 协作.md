# 完成第一次 GitHub 协作



## 贡献类型

Documentation (Tutorial)

## PR 链接

https://github.com/nishuzumi/moss/pull/103

## 简要描述
  为 Moss 项目贡献了一篇「Building Your First Protocol Adapter」教程，
  以自己开发的 FastLane shMONAD 适配器为真实案例，手把手教新开发者
  从 Fork → 创建包 → 写 ABI/Protocol/测试 → 提交 PR 的完整流程。

  教程里记录了 3 个实际踩过的坑：

       1. pnpm build 必须在 typecheck 之前跑
       2. 需要 caller 地址时必须加 ctx: ActionCtx
       3. 不能手写 ABI，必须从验证源获取