# iOS QA Checklist

日期：2026-06-21

## 环境

- Xcode：26.5，Build 17F42
- 模拟器：iPhone 17 Simulator
- 模拟器 ID：B22D77F4-C6DD-4EEC-9467-75363A39C3FD
- 模拟器 iOS：26.5
- 真机：iPhone 17 Pro，iOS 26.5.1
- 真机状态：`devicectl` 显示 `available (paired)`，但命令行签名缺少 Xcode Account / provisioning profile
- 工程：`apps/ios/MeiweiAssistant/MeiweiAssistant.xcodeproj`
- Scheme：`MeiweiAssistant`
- Bundle Identifier：`cn.hnchpower.meiwei`
- Version：`1.0.0`
- Build：`1`
- Signing：`CODE_SIGN_STYLE = Automatic`
- Team：不写入仓库；由本机 Xcode Signing & Capabilities 或命令行临时参数提供

## 已通过项

- `generic/platform=iOS` 无签名构建通过。
- Release 无签名构建通过：
  - `xcodebuild -project apps/ios/MeiweiAssistant/MeiweiAssistant.xcodeproj -scheme MeiweiAssistant -configuration Release -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO build`
- Archive 前置归档通过：
  - `xcodebuild -project apps/ios/MeiweiAssistant/MeiweiAssistant.xcodeproj -scheme MeiweiAssistant -configuration Release -destination 'generic/platform=iOS' -archivePath /tmp/MeiweiAssistant.xcarchive CODE_SIGNING_ALLOWED=NO archive`
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
- Archive 产物已确认包含关键 bundle 资源：
  - `Assets.car`
  - `LaunchScreen.storyboardc`
  - `Assets.scnassets/TrueD6.obj`
  - `recipes.json`
  - `titles.json`
  - `mystic.json`
  - `party-games.json`
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

- 真机 Debug 安装未通过；项目不写死 Team，命令行构建提示需要 Development Team。
- 临时传入本机证书 Team ID 后仍未通过；Xcode 报错：
  - `No Accounts: Add a new account in Accounts settings.`
  - `No profiles for 'cn.hnchpower.meiwei' were found`
- 真机截图未生成；需要先在本机 Xcode 登录 Apple Account，并为 `cn.hnchpower.meiwei` 生成 development provisioning profile。
- 未执行 TestFlight upload；需 App Store Connect App 记录、Distribution 签名和上传权限。
- 未做完整人工交互回归；本轮完成了模拟器启动、首页截图和构建级验证。

## 已知 Warning

- `IDERunDestination: Supported platforms for the buildables in the current scheme is empty.` 构建过程中出现，但不阻塞构建。
- `Metadata extraction skipped. No AppIntents.framework dependency found.` 当前没有使用 AppIntents，可忽略。

## TestFlight 上传前检查项

- 在 Xcode Settings > Accounts 登录 Apple Developer 账号。
- 在 Signing & Capabilities 选择可用于 `cn.hnchpower.meiwei` 的 Team。
- 保持 `Automatically manage signing`。
- 确认 App Store Connect 已创建 Bundle ID 为 `cn.hnchpower.meiwei` 的 App。
- 首次上传可继续使用 Build `1`；如果已经上传过同版本同 Build，再递增到 Build `2`。
- 使用 Release / Any iOS Device 执行 Archive。
- Organizer 中验证 archive 后上传到 App Store Connect。
- 上传前不要提交证书、`.mobileprovision`、导出 IPA、`.xcarchive`。
- 上传后在 TestFlight 等待处理，补隐私问卷、出口合规和测试信息。

## 已知产品限制

- 当前无后端同步，本地状态仅保存在设备本机。
- 当前无真实 AI 接口，AI 菜谱创作仍是本地入口/占位体验。
- 当前无 Android 原生实现。
- Web 端本阶段未重构。

## 下一阶段计划

- 配置 Apple Developer Team、Signing & Capabilities。
- 使用真机安装并复测今日推荐、骰子、分工、玄学、烹饪流程、称号弹窗和本地状态恢复。
- 准备 App Store Connect App 信息、隐私说明和 TestFlight 首包 archive。
- 补齐正式截图：今日、饭局 3D 骰子、玄学结果、菜谱详情、称号殿堂。
