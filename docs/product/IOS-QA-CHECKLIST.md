# iOS QA Checklist

日期：2026-06-21

## 环境

- Xcode：26.5，Build 17F42
- 测试设备：iPhone 17 Simulator
- 设备 ID：B22D77F4-C6DD-4EEC-9467-75363A39C3FD
- iOS：26.5
- 工程：`apps/ios/MeiweiAssistant/MeiweiAssistant.xcodeproj`
- Scheme：`MeiweiAssistant`
- Bundle Identifier：`cn.hnchpower.meiwei`
- Version：`1.0.0`
- Build：`1`

## 已通过项

- `generic/platform=iOS` 无签名构建通过。
- iPhone 17 Simulator 构建通过。
- App 可安装到模拟器。
- App 可启动到前台，未再出现共享 JSON 解码崩溃。
- 首页截图通过，文件：`docs/product/ios-home-smoke.png`。
- 构建产物 `Info.plist` 已确认：
  - `CFBundleIdentifier = cn.hnchpower.meiwei`
  - `CFBundleDisplayName = 美味助手`
  - `CFBundleShortVersionString = 1.0.0`
  - `CFBundleVersion = 1`
  - `UILaunchStoryboardName = LaunchScreen`
- AppIcon 已由现有图标素材生成 iPhone 和 App Store 尺寸。
- 启动页已配置为暖白背景、中间图标、标题和副标题。
- iOS 源码未使用 `WKWebView` 或 Capacitor。
- 今日页首屏明确展示“今天吃什么”和今日推荐，可进入菜谱详情。
- 饭局页保留 SceneKit 真六面 3D 骰子和厨房分工入口。
- 玄学页保留六种玩法入口，结果落到共享菜谱数据。
- 菜谱页可见菜谱库、收藏、做过、菜单、一桌好菜、酱料助手。
- 我的页可见主线称号、隐藏称号和本地进度。
- 成长状态使用 `UserDefaults + Codable` 持久化。

## 未通过项

- 未做真机签名安装测试；当前没有配置 Apple Developer Team 和 provisioning profile。
- 未执行 TestFlight archive/upload；需账号、证书和 App Store Connect App 记录。
- 未做完整人工交互回归；本轮完成了模拟器启动、首页截图和构建级验证。

## 已知 Warning

- `IDERunDestination: Supported platforms for the buildables in the current scheme is empty.` 构建过程中出现，但不阻塞构建。
- `Metadata extraction skipped. No AppIntents.framework dependency found.` 当前没有使用 AppIntents，可忽略。

## 下一阶段计划

- 配置 Apple Developer Team、Signing & Capabilities。
- 使用真机安装并复测今日推荐、骰子、分工、玄学、烹饪流程、称号弹窗和本地状态恢复。
- 准备 App Store Connect App 信息、隐私说明和 TestFlight 首包 archive。
- 补齐正式截图：今日、饭局 3D 骰子、玄学结果、菜谱详情、称号殿堂。
