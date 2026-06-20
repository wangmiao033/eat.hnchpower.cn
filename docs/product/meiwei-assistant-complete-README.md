# 美味助手 · iOS 完整整合包

这次不是单独的玄学页面包，而是把此前完成的 iOS 设计、每日推荐、AI 创作、菜谱详情、烹饪模式、饭局游戏、真六面骰子、厨房分工、称号系统与玄学厨房合并到同一套工程中。

## 直接查看

- 打开 `WebPrototype/index.html` 查看完整交互原型。
- macOS 上打开 `iOS/MeiweiAssistant.xcodeproj` 查看原生工程。
- 若需要重新生成工程，可安装 XcodeGen 后在 `iOS` 目录运行 `xcodegen generate`。

## 工程入口

- `MeiweiAssistantApp.swift`：App 入口。
- `RootTabView.swift`：今日 / 饭局 / 玄学 / 菜谱 / 我的。
- `TrueSixSidedRecipeDiceView.swift`：最终真六面 SceneKit 骰子。
- `MysticKitchenView.swift`：玄学厨房六种玩法。
- `TitleSystem.swift`：完整称号展示与成长状态。
- `AchievementRuleEngine.swift`：读取完整 JSON 并评估隐藏称号规则。

## 数量

- Swift 源文件：20 个。
- 主线称号：25 个。
- 隐藏称号：75 个。

## 构建要求

- Xcode 15 或更高版本。
- iOS 17 或更高版本。
- 首次打开后配置开发者签名 Team。

工程文件由当前环境生成，尚未在 macOS/Xcode 中执行最终签名构建；源文件、资源引用和备用 XcodeGen 配置均已放入包内。
