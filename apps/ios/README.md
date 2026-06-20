# iOS Native App

原生 iOS 工程位于：

```text
apps/ios/MeiweiAssistant/
```

技术方向：

- SwiftUI 构建主要界面
- SceneKit 承载真六面 3D 骰子
- `shared/data/*.json` 作为 bundle 资源读取菜谱、称号、玄学和饭局规则
- UserDefaults + Codable 做第一版本地状态
- 后续服务端接口保持与 `shared/data` 同结构

当前原生入口：

- `MeiweiAssistant/RootTabView.swift`：五个底部入口，顺序为今日、饭局、玄学、菜谱、我的
- `MeiweiAssistant/TodayView.swift`：每日推荐、开始做饭、AI 创作入口
- `MeiweiAssistant/PartyGameView.swift`：饭局互动、分工抽签、3D 食谱骰子
- `MeiweiAssistant/TrueSixSidedRecipeDiceView.swift`：SceneKit 真六面 D6，使用 `Assets.scnassets/TrueD6.obj`
- `MeiweiAssistant/MysticKitchenView.swift`：今日食运、心情开锅、塔罗菜牌、幸运数字、缘分合锅、五味灵签
- `MeiweiAssistant/LibraryView.swift`：菜谱库、收藏、做过、一桌好菜、酱料助手
- `MeiweiAssistant/ProfileView.swift` 与 `TitleHallView.swift`：主线称号、隐藏称号、称号殿堂、设置

命令行验证：

```bash
xcodebuild -project apps/ios/MeiweiAssistant/MeiweiAssistant.xcodeproj \
  -scheme MeiweiAssistant \
  -destination 'generic/platform=iOS' \
  CODE_SIGNING_ALLOWED=NO build
```

禁止事项：

- 不使用 WKWebView 承载主功能
- 不使用 Capacitor
- 不依赖 Vue 页面
