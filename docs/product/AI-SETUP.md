# 美味助手 AI 接入说明

日期：2026-06-21

## 当前方案

- 服务商：Google Gemini API
- App 默认模型：`gemini-2.5-flash-lite`
- 备用模型：用户配置模型请求失败时，会自动尝试 `gemini-2.5-flash-lite`、`gemini-2.0-flash`
- 使用方式：BYOK，用户在 App 内填写自己的 API Key
- Key 存储：iOS Keychain，本机保存，不提交到仓库
- 无 Key 时：使用本地生成兜底，仍可生成 3 道可做菜谱

## 为什么这样做

移动 App 内置 API Key 无法真正保密，打包后可以被逆向提取。当前先使用用户自带 Key，避免产生服务端成本，也避免把付费 Key 暴露在客户端。

后续如果要做正式商业版，建议改成：

```text
iOS App -> 自有后端 -> AI Provider
```

由后端保存 Key、做限流、审核、日志和成本控制。

## 用户配置路径

```text
我的 -> 高级设置 -> AI 服务配置
```

填写：

- 服务商：`Gemini`
- 模型：`gemini-2.5-flash-lite`
- API Key：从 Google AI Studio 创建

## 功能行为

### 已配置 API Key

「AI 菜谱创作」会调用 Gemini，按用户输入的食材、口味和场景生成 3 道菜谱。结果会转成 App 内的 `Recipe` 模型，可进入菜谱详情和烹饪流程。如果当前模型高负载或不可用，会自动尝试备用模型。

### 未配置 API Key 或请求失败

App 会自动使用本地生成兜底：

- 仍返回 3 道菜
- 标记为本地生成
- 不阻塞用户继续进入菜谱详情

## 注意事项

- 当前不提交任何 API Key。
- 当前不上传用户输入到自有后端。
- 配置 Gemini Key 后，用户输入的食材和偏好会发送给 Google Gemini API。
- 当前没有登录、计费、限流和服务端代理。
