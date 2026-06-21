# iOS QA Checklist

日期：2026-06-21

## 环境

- Xcode：26.5，Build 17F42
- 模拟器：iPhone 17 Simulator
- 模拟器 ID：B22D77F4-C6DD-4EEC-9467-75363A39C3FD
- 模拟器 iOS：26.5
- 真机：iPhone 17 Pro，iOS 26.5.1
- 真机状态：`devicectl` 显示 `connected`，已完成 Debug 安装验证和 Release archive 产物重装启动验证
- 工程：`apps/ios/MeiweiAssistant/MeiweiAssistant.xcodeproj`
- Scheme：`MeiweiAssistant`
- Bundle Identifier：`cn.hnchpower.eat`
- Bundle ID 说明：由 Web 域名 `eat.hnchpower.cn` 采用反向域名格式确定
- Version：`1.0.0`
- Build：`1`
- Signing：`CODE_SIGN_STYLE = Automatic`
- Team：不写入仓库；本机临时使用 `XU97BSCFY6` 完成 Debug/Release 本地签名验证

## 已通过项

- `generic/platform=iOS` 无签名构建通过。
- Release 无签名构建通过：
  - `xcodebuild -project apps/ios/MeiweiAssistant/MeiweiAssistant.xcodeproj -scheme MeiweiAssistant -configuration Release -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO build`
- Archive 前置归档通过：
  - `xcodebuild -project apps/ios/MeiweiAssistant/MeiweiAssistant.xcodeproj -scheme MeiweiAssistant -configuration Release -destination 'generic/platform=iOS' -archivePath /tmp/MeiweiAssistant.xcarchive CODE_SIGNING_ALLOWED=NO archive`
- Release Archive 本机签名归档通过：
  - `xcodebuild -project apps/ios/MeiweiAssistant/MeiweiAssistant.xcodeproj -scheme MeiweiAssistant -configuration Release -destination 'generic/platform=iOS' -archivePath /tmp/MeiweiAssistant-release-signed.xcarchive DEVELOPMENT_TEAM=XU97BSCFY6 -allowProvisioningUpdates archive`
  - Archive Bundle ID：`cn.hnchpower.eat`
  - Signing Identity：`Apple Development: 云 上征途 (37A3W2NV9Z)`
  - Provisioning Profile：`iOS Team Provisioning Profile: *`
  - 说明：该 archive 可验证 Release 打包和本机安装，但不是 TestFlight 分发签名产物。
- App Store Connect 导出预检通过：
  - `xcodebuild -exportArchive -archivePath /tmp/MeiweiAssistant-release-signed.xcarchive -exportPath /tmp/MeiweiAssistant-export -exportOptionsPlist /tmp/meiwei-export-options.plist -allowProvisioningUpdates`
  - 导出 IPA：`/tmp/MeiweiAssistant-export/MeiweiAssistant.ipa`
  - Distribution：`Cloud Managed Apple Distribution`
  - Provisioning Profile：`iOS Team Store Provisioning Profile: cn.hnchpower.eat`
  - Entitlements：`beta-reports-active = true`，`get-task-allow = false`
  - Version：`1.0.0`
  - Build：`1`
- iPhone 17 Simulator 构建通过。
- App 可安装到模拟器。
- App 可启动到前台，未再出现共享 JSON 解码崩溃。
- 首页截图通过，文件：`docs/product/ios-home-smoke.png`。
- iPhone 17 Pro 真机 Debug 构建通过，临时命令行参数为 `DEVELOPMENT_TEAM=XU97BSCFY6`。
- iPhone 17 Pro 真机安装通过：
  - `bundleID = cn.hnchpower.eat`
- iPhone 17 Pro 真机启动通过，进程列表可见：
  - `/private/var/containers/Bundle/Application/.../MeiweiAssistant.app/MeiweiAssistant`
- iPhone 17 Pro 真机全新安装 Release archive 产物通过：
  - 先卸载旧 App：`xcrun devicectl device uninstall app --device 5B779D9A-A4E4-53D6-98AA-E2647E8D4306 cn.hnchpower.eat`
  - 安装 archive app：`xcrun devicectl device install app --device 5B779D9A-A4E4-53D6-98AA-E2647E8D4306 /tmp/MeiweiAssistant-release-signed.xcarchive/Products/Applications/MeiweiAssistant.app`
  - 启动：`xcrun devicectl device process launch --device 5B779D9A-A4E4-53D6-98AA-E2647E8D4306 cn.hnchpower.eat`
  - 设备安装信息：`美味助手 / cn.hnchpower.eat / 1.0.0 / 1`
  - 进程列表可见：`/private/var/containers/Bundle/Application/.../MeiweiAssistant.app/MeiweiAssistant`
- 真机构建产物已确认包含关键 bundle 资源：
  - `Assets.car`
  - `LaunchScreen.storyboardc`
  - `Assets.scnassets/TrueD6.obj`
  - `recipes.json`
  - `titles.json`
  - `mystic.json`
  - `party-games.json`
- 构建产物 `Info.plist` 已确认：
  - `CFBundleIdentifier = cn.hnchpower.eat`
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
- 导出 IPA 已确认包含关键 bundle 资源：
  - `Payload/MeiweiAssistant.app/Assets.car`
  - `Payload/MeiweiAssistant.app/LaunchScreen.storyboardc`
  - `Payload/MeiweiAssistant.app/Assets.scnassets/TrueD6.obj`
  - `Payload/MeiweiAssistant.app/recipes.json`
  - `Payload/MeiweiAssistant.app/titles.json`
  - `Payload/MeiweiAssistant.app/mystic.json`
  - `Payload/MeiweiAssistant.app/party-games.json`
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

- 真机截图未生成；当前 Xcode 26.5 的 `devicectl` 没有通用 screenshot 子命令，本机也未安装 `idevicescreenshot` / `ios-deploy`。
- App Store Connect 导出登录前失败过一次：
  - 失败原因：`exportArchive No Accounts`
  - 失败原因：`exportArchive No profiles for 'cn.hnchpower.eat' were found`
  - Xcode Accounts 登录后已通过导出预检。
- 未执行 TestFlight upload；需要在 Xcode Organizer 中继续上传并完成 App Store Connect 处理。
- 未做完整人工交互回归；本轮完成了模拟器启动、首页截图、真机安装、真机启动、Release archive 重装和构建级资源验证。

## 已知 Warning

- `IDERunDestination: Supported platforms for the buildables in the current scheme is empty.` 构建过程中出现，但不阻塞构建。
- `Metadata extraction skipped. No AppIntents.framework dependency found.` 当前没有使用 AppIntents，可忽略。

## TestFlight 上传前检查项

- 在 Xcode Settings > Accounts 登录 Apple Developer 账号。已完成。
- 在 Signing & Capabilities 选择可用于 `cn.hnchpower.eat` 的 Team；当前本机 Debug 验证可用 Team 为 `XU97BSCFY6`。
- 保持 `Automatically manage signing`。
- 确认 App Store Connect 已创建 Bundle ID 为 `cn.hnchpower.eat` 的 App。
- 确认本机 Xcode Accounts 对命令行 archive/export 可见。已完成，`xcodebuild -exportArchive` 通过。
- 确认 Apple Developer Portal 中存在 `cn.hnchpower.eat` 的 explicit App ID 和 App Store distribution profile。已由导出结果确认。
- 确认分发签名。已使用 `Cloud Managed Apple Distribution` 导出。
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

- 使用 Xcode Organizer 上传 TestFlight。
- 上传前人工复测今日推荐、骰子、分工、玄学、烹饪流程、称号弹窗和本地状态恢复。
- 补齐正式截图：今日、饭局 3D 骰子、玄学结果、菜谱详情、称号殿堂。
