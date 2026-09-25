# Preferences 兼容分支

此仓库是 sindresorhus/Settings（原 Preferences）的 GitHub fork。

- main 保留上游最新版 Settings。
- codex/preferences-integration 基于上游重构前提交，并融合本地 KPreferences 的 0665b0f 提交历史。
- 保留 Preferences 产品、模块和 PreferencePane API，不宣称已包含新版 Settings 的修复。
- 合入页面离开确认（原接口 viewShouldDisppear 保持兼容）与 updateLocalized；修复工具条空白项目造成的本地化数组下标问题。
- 未导入本地快照中无业务意义的全文件可执行权限；现有 Example、许可证和上游历史保留。

## 使用

SwiftPM URL：https://github.com/kzhiquan/Settings.git
分支：codex/preferences-integration
产品及 import：Preferences

原 /Packages/KPreferences 与 kzhiquan/KPreferences 均保留，Menote 本地引用未切换。
本分支用于后续通用／关于两页面集成验证；构建通过不代表真实 UI 验收。

## 验证（2026-09-25）

- 上游基点：ffeaaad（2.5.0）；本地新增业务差异集中在四个 Swift 文件。
- `swift build --scratch-path /private/tmp/menote-preferences-integration-build` 通过。
- `swift test --scratch-path /private/tmp/menote-preferences-integration-build` 最终 1 项通过、0 失败；覆盖空白项和页面顺序不同的本地化刷新。首次夹具缺少 NSToolbar allowed identifiers，完善真实工具条配置后通过，未放宽断言。
- 尚未执行 Menote 集成构建、页面切换拦截自动化及真实窗口视觉验收。
