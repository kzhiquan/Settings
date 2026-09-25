# Settings fork

本仓库是 sindresorhus/Settings（原 Preferences）的 GitHub fork。

## 当前状态

2026-09-25 已将上游 main（f414757）全部更新融合到本地扩展分支，并合入 main。保留上游历史及原 KPreferences 的 0665b0f 提交。

- 产品与模块：Settings；使用 `import Settings`。
- 页面协议：SettingsPane；属性为 paneIdentifier、paneTitle、toolbarItemIcon。
- 窗口：SettingsWindowController(panes:)，show(pane:)。
- 本地扩展：viewShouldDisppear() 控制离开页面和关闭窗口；保留原拼写以维持该扩展兼容。
- updateLocalized() 刷新窗口标题及工具条页面标签，按项目身份匹配并跳过空白项。该扩展目前仅刷新工具条样式，页面内部控件由应用自行更新；不提供切换系统语言机制。
- 保留上游窗口激活顺序、非主窗口、Sonoma 工具条选中修复及 SwiftPM 本地化资源。

## 使用与迁移

SwiftPM URL：https://github.com/kzhiquan/Settings.git，分支 main。

旧 Preferences 模块不再由本分支提供，迁移需更改 import、页面协议及构造参数。本地仓库为 Packages/Settings；原 Packages/KPreferences 及 Menote 的现有引用未修改。

## 验证

`swift test --scratch-path /private/tmp/menote-settings-upstream-build` 构建及 2 项测试通过、0 失败：

1. 工具条乱序页面与 flexibleSpace 本地化刷新。
2. 页面拒绝切换后的身份／选中保持，关闭确认，允许切换，以及窗口不能成为 main。

未执行 Menote 集成构建及两页面真实视觉验收。
