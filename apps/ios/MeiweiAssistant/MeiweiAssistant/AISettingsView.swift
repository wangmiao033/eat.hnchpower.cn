import SwiftUI

struct AISettingsView: View {
    @State private var provider = ""
    @State private var model = ""
    @State private var apiKey = ""
    @State private var savedMessage = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header

                VStack(alignment: .leading, spacing: 14) {
                    Text("免费 AI 接入")
                        .font(.headline)
                    Text("当前使用 Gemini API 的自带免费额度模式。App 不内置官方付费 key，你可以在 Google AI Studio 创建自己的 API Key，保存在本机 Keychain。")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Link(destination: URL(string: "https://aistudio.google.com/app/apikey")!) {
                        Label("去 Google AI Studio 创建 API Key", systemImage: "safari")
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                .padding(18)
                .meiweiCard()

                VStack(alignment: .leading, spacing: 14) {
                    Text("服务配置")
                        .font(.headline)

                    field(title: "服务商", text: $provider, placeholder: "Gemini")
                    field(title: "模型", text: $model, placeholder: "gemini-2.5-flash")

                    VStack(alignment: .leading, spacing: 8) {
                        Text("API Key")
                            .font(.caption.bold())
                            .foregroundStyle(AppTheme.secondary)
                        SecureField("AIza…", text: $apiKey)
                            .textContentType(.password)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .padding(13)
                            .background(Color.black.opacity(0.04), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }

                    HStack(spacing: 10) {
                        Button("保存配置") { save() }
                            .buttonStyle(PrimaryButtonStyle())

                        Button("清除 Key") { clearKey() }
                            .font(.subheadline.bold())
                            .foregroundStyle(AppTheme.secondary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 13)
                            .background(Color.black.opacity(0.05), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }

                    if !savedMessage.isEmpty {
                        Label(savedMessage, systemImage: "checkmark.seal.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(AppTheme.accent)
                    }
                }
                .padding(18)
                .meiweiCard()

                VStack(alignment: .leading, spacing: 10) {
                    Label("为什么不是直接内置免费 key？", systemImage: "lock.shield")
                        .font(.headline)
                    Text("移动 App 里的 key 无法真正保密。当前先用 BYOK 方式，不产生服务器成本；等后续接后端时，再把 AI Key 放到服务端代理里。")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondary)
                }
                .padding(18)
                .background(AppTheme.sand.opacity(0.52), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
            .padding(18)
        }
        .background(AppTheme.canvas.ignoresSafeArea())
        .navigationTitle("AI 服务配置")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: load)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("让菜谱库变大")
                .font(.system(size: 32, weight: .bold))
            Text("输入家里现有食材，让 AI 生成真实可做的三道菜。")
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondary)
        }
    }

    private func field(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(AppTheme.secondary)
            TextField(placeholder, text: text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(13)
                .background(Color.black.opacity(0.04), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }

    private func load() {
        let settings = AIRecipeSettingsStore.shared.settings
        provider = settings.provider
        model = settings.model
        apiKey = settings.apiKey
    }

    private func save() {
        AIRecipeSettingsStore.shared.save(AIRecipeSettings(
            provider: provider.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Gemini" : provider,
            model: model.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "gemini-2.5-flash" : model,
            apiKey: apiKey
        ))
        savedMessage = apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "已保存模型配置，当前会使用本地生成兜底。" : "已保存，AI 菜谱创作将优先调用 Gemini。"
    }

    private func clearKey() {
        AIRecipeSettingsStore.shared.clearAPIKey()
        apiKey = ""
        savedMessage = "已清除 API Key，生成时会使用本地兜底。"
    }
}
