# 美味助手 Monorepo

三端独立工程：

- `apps/web`：Vue/Vite 网页端和官网。
- `apps/ios/MeiweiAssistant`：原生 iOS App，SwiftUI + SceneKit。
- `apps/android`：预留原生 Android，后续 Kotlin/Compose。
- `shared/data`：三端共用的菜谱、称号、玄学和饭局规则 JSON。
- `shared/schemas`：共享数据字段说明。
- `shared/api`：后续后端接口协议。
- `docs`：产品文档、设计图和 Web 原型归档，不参与运行。
- `public-assets`：设计素材源文件、图标、3D 骰子模型等。

## Web

```bash
cd apps/web
npm install
npm run build
npm run dev
```

## iOS

打开：

```text
apps/ios/MeiweiAssistant/MeiweiAssistant.xcodeproj
```

iOS 使用 SwiftUI + SceneKit，不依赖 WebView，不使用 Capacitor。

## Shared Data

```text
shared/data/recipes.json
shared/data/titles.json
shared/data/mystic.json
shared/data/party-games.json
```

后续 Web、iOS、Android 都应优先消费这些 JSON 或由后端返回同结构数据。
