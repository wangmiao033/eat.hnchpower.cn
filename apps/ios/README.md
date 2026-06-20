# iOS Native App

原生 iOS 工程位于：

```text
apps/ios/MeiweiAssistant/
```

技术方向：

- SwiftUI 构建主要界面
- SceneKit / RealityKit 承载真六面 3D 骰子
- UserDefaults + Codable JSON 做第一版本地状态
- 后续与 `shared/data` 和服务端接口对齐

禁止事项：

- 不使用 WKWebView 承载主功能
- 不使用 Capacitor
- 不依赖 Vue 页面
