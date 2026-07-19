# GitHub 探索日志




**Arnis 项目探索日志**

** 基本信息**

**仓库**

• 项目: 仓库

• 内容: [louis-e/arnis](https://github.com/louis-e/arnis)

**简介**

• 项目: 简介

• 内容: 将真实世界地理位置生成高精度 Minecraft 世界

**语言**

• 项目: 语言

• 内容: **Rust**（核心引擎） + JavaScript/HTML/CSS（GUI）

**框架**

• 项目: 框架

• 内容: Tauri v2（桌面 GUI）

**许可**

• 项目: 许可

• 内容: Apache-2.0

**⭐ Stars**

• 项目: ⭐ Stars

• 内容: ~17,000

**🍴 Forks**

• 项目: 🍴 Forks

• 内容: ~1,400

**📝 Commits**

• 项目: 📝 Commits

• 内容: 2,262

**创建时间**

• 项目: 创建时间

• 内容: 2022年9月

**作者**

• 项目: 作者

• 内容: Louis Erbkamm（德国，个人项目）

\---

**🏗️ 项目目录结构**



```
arnis/
├── src/                          # Rust 核心源码（~50个模块）
│   ├── main.rs                   # 入口
│   ├── args.rs                   # CLI 参数解析（clap）
│   ├── gui.rs / gui/             # Tauri GUI 层 + 内置网页前端
│   │   ├── index.html            # 地图 UI（Leaflet + MapLibre GL）
│   │   ├── js/                   # 前端 JS（地图交互、搜索、3D预览）
│   │   ├── css/                  # 前端样式
│   │   └── locales/              # 18种语言翻译（含中文）
│   ├── coordinate_system/        # 地理坐标 ↔ 游戏坐标 转换
│   ├── element_processing/       # OSM 元素处理（建筑/道路/桥梁/铁路/自然...）
│   │   ├── buildings.rs          # 建筑生成
│   │   ├── highways.rs           # 道路生成
│   │   ├── bridges.rs            # 桥梁生成
│   │   ├── railways.rs           # 铁路生成
│   │   ├── landuse.rs            # 土地利用
│   │   ├── natural.rs            # 自然景观
│   │   ├── subprocessor/         # 子处理器（建筑内饰、战利品）
│   │   └── ... (15+ 文件)
│   ├── structures/               # 3D 结构体生成（汽车/船/直升机/风车/喷泉...）
│   ├── trees/                    # 树木生成（含 Schematic 树木库）
│   ├── world_editor/             # Minecraft 世界文件写入
│   │   ├── java.rs               # Java 版（.mca 区域文件）
│   │   ├── bedrock.rs            # 基岩版（.mcworld）
│   │   └── luanti.rs             # Luanti（Minetest）支持
│   ├── retrieve_data.rs          # OSM/高程数据获取
│   ├── overture.rs               # Overture Maps 数据源
│   ├── tile.rs                   # 瓦片化处理
│   ├── projection/               # 地图投影（Web Mercator）
│   ├── climate.rs                # 气候/生物群系映射（Köppen分类）
│   ├── water_depth.rs            # 水域深度
│   ├── biome.rs                  # 生物群系
│   └── preview_3d.rs             # 3D 预览
├── assets/                       # 静态资源
│   ├── minecraft/                # MC 数据包（加高世界高度）
│   ├── climate/                  # Köppen 气候数据
│   └── tree-packs/               # 树木schematic库（印度/南美树种）
├── tests/                        # 测试
├── capabilities/                 # Tauri 权限声明
├── .github/                      # CI/CD + Issue 模板
│   └── workflows/
│       ├── ci-build.yml           # 三平台构建
│       ├── release.yml            # 发布流程
│       └── duplicate-issues.yml   # 自动标记重复issue
├── docs/                         # ADR 架构决策记录（Wiki 为主）
├── Cargo.toml                    # Rust 依赖声明
└── README.md
```

\---

**📦 GitHub 各模块的作用**

***\*Issues**（108 open）**

• 模块: **Issues**（108 open）

• 作用: 用标签分类：`bug` / `feature` / `discussion`，模板引导提交者描述清楚问题

***\*Pull Requests**（19 open）**

• 模块: **Pull Requests**（19 open）

• 作用: 社区贡献入口，合并到 main → CI 自动构建 → Maintainer 统一发版

***\*Actions****

• 模块: **Actions**

• 作用: 三平台（Win/Mac/Linux）自动构建 + 发版 + 重复 issue 自动标记

***\*Wiki**（8页）**

• 模块: **Wiki**（8页）

• 作用: 代码架构、贡献指南、坐标系、元素处理器等技术文档

***\*Discussions****

• 模块: **Discussions**

• 作用: 用 Issue 模板里的 `discussion` 标签替代

***\*Tags**（22个）**

• 模块: **Tags**（22个）

• 作用: 语义化版本：v1.x → v2.x → 刚发 v3.0.0

\---

**🔍 一个感兴趣的 Issue**

**#924 — [FEATURE] Survival friendly（生存模式适配）**



>  用户希望生成的 Minecraft 世界不只是"观光"，还支持生存模式游玩。具体诉求：
>
> 1. 地下不填满石头，而是让 Minecraft 自然生成洞穴/矿石
> 2. 海洋中随机生成珊瑚、海草等
> 3. 仅地形模式下也能随机生成 MC 原版村庄
> 4. 只生成道路不生成建筑（目前建筑和道路是绑定的）

**为什么有趣**：这个 Issue 揭示了项目定位的张力——当前 Arnis 偏"数字孪生/观光"，但大量用户希望"在地球上玩生存"。它涉及核心架构决策（生成区 vs 自然生成区的边界），是典型的"用户需求推动产品方向"的案例。

\---

**💡 我的学习收获**

1. **Rust 项目工程化范本**

   \- `src/` 下近 50 个模块，每个模块职责单一（建筑/道路/桥梁/树木各一个文件）
   \- `element_processing/` 用"子处理器"模式实现建筑内饰等扩展功能
   \- Tauri 桌面框架 + Leaflet 地图前端混搭（Rust 做计算，Web 做 UI）

2. **开源项目的组织方式**

   \- **Issue 模板**分三类（bug/feature/discussion），引导用户规范提交
   \- **Wiki 做深度文档**，README 做快速入门，分工清晰
   \- **CI 自动化**：三平台构建 + 自动标记重复 issue，降低维护负担 (1/2)
[2026/7/15 16:37] My Hermes: - **标签系统**：`good first issue` / `help wanted` 引导新贡献者

3. **Solo Maintainer 的生存策略**

   \- 作者 Louis 一个人维护 17k star 的项目
   \- 自己写核心 PR（#1173-#1183 全是作者自己），社区贡献为辅
   \- 统一发版节奏，不随 PR 合并即时发布
   \- 清晰声明"官方渠道"，防止恶意分发（README 末尾强调两次）

4. **技术亮点**

   \- 使用 `debug_traceCall` 级别的瓦片化处理
   \- Köppen 气候分类 → Minecraft 生物群系映射
   \- Overture Maps 作为 OSM 的补充数据源
   \- 同时支持 Java 版（.mca 区域文件）和基岩版（.mcworld）

\---

这份日志涵盖了探索一个开源项目的基本维度：项目定位 → 代码结构 → 协作工具 → 社区动态 → 技术架构。你可以以此为模板，快速了解任何 GitHub 项目。 (2/2)