import SwiftUI

struct CreateRecipeView: View {
    private let preferences = ["20 分钟内", "下饭", "清淡", "高蛋白", "一人食", "少油"]
    private let cuisines = [
        ("家常菜", "熟悉、稳妥、容易复刻"),
        ("川味", "麻辣鲜香，层次分明"),
        ("粤味", "清鲜少油，突出本味"),
        ("日式", "简洁清爽，季节感")
    ]

    @State private var ingredients = ""
    @State private var selectedPreferences: Set<String> = ["20 分钟内", "下饭"]
    @State private var isGenerating = false
    @State private var generated: [Recipe] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("AI 做饭助手")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.accent)
                    Text("手边有什么？")
                        .font(.system(size: 34, weight: .bold))
                    Text("告诉我食材与口味，整理成真正能下锅的菜谱。")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondary)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("我的食材").font(.subheadline.bold())
                    ZStack(alignment: .bottomTrailing) {
                        TextEditor(text: $ingredients)
                            .frame(minHeight: 95)
                            .scrollContentBackground(.hidden)
                            .padding(8)
                            .background(Color.black.opacity(0.04), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay(alignment: .topLeading) {
                                if ingredients.isEmpty {
                                    Text("例如：番茄、鸡蛋、青椒、豆腐……")
                                        .font(.subheadline)
                                        .foregroundStyle(.tertiary)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 17)
                                        .allowsHitTesting(false)
                                }
                            }
                        HStack(spacing: 8) {
                            Image(systemName: "camera")
                            Image(systemName: "mic")
                        }
                        .font(.subheadline)
                        .padding(10)
                    }

                    Text("口味与场景").font(.subheadline.bold())
                    FlowLayout(spacing: 8) {
                        ForEach(preferences, id: \.self) { item in
                            Button(item) { toggle(item) }
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 13)
                                .padding(.vertical, 10)
                                .background(selectedPreferences.contains(item) ? AppTheme.accent.opacity(0.14) : Color.black.opacity(0.05), in: Capsule())
                                .foregroundStyle(selectedPreferences.contains(item) ? AppTheme.accent : AppTheme.secondary)
                        }
                    }

                    Text("料理风格").font(.subheadline.bold())
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(cuisines, id: \.0) { cuisine in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(cuisine.0).font(.subheadline.bold())
                                    Text(cuisine.1)
                                        .font(.caption2)
                                        .foregroundStyle(AppTheme.secondary)
                                        .lineLimit(2)
                                }
                                .frame(width: 105, alignment: .leading)
                                .padding(13)
                                .background(Color.black.opacity(0.04), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                            }
                        }
                    }

                    Button {
                        generate()
                    } label: {
                        HStack {
                            if isGenerating { ProgressView().tint(.white) }
                            Text(isGenerating ? "正在整理你的菜谱…" : "生成 3 道适合我的菜")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(isGenerating)

                    Text("只在生成时调用 AI；偏好建议保存在本机。")
                        .font(.caption2)
                        .foregroundStyle(AppTheme.secondary)
                        .frame(maxWidth: .infinity)
                }
                .padding(18)
                .meiweiCard()

                if !generated.isEmpty {
                    Text("为你生成").font(.title3.bold())
                    ForEach(generated) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {
                            HStack(spacing: 14) {
                                FoodArtwork(style: recipe.artwork)
                                    .frame(width: 86, height: 86)
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(recipe.name).font(.headline)
                                    Text("\(recipe.ingredients.prefix(3).map(\.name).joined(separator: " · ")) ｜ \(recipe.timeMinutes) 分钟")
                                        .font(.caption)
                                        .foregroundStyle(AppTheme.secondary)
                                        .lineLimit(2)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(.tertiary)
                            }
                            .padding(12)
                            .meiweiCard()
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(18)
            .padding(.bottom, 20)
        }
        .background(AppTheme.canvas.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func toggle(_ item: String) {
        if selectedPreferences.contains(item) { selectedPreferences.remove(item) }
        else { selectedPreferences.insert(item) }
    }

    private func generate() {
        isGenerating = true
        Task {
            try? await Task.sleep(for: .milliseconds(650))
            await MainActor.run {
                generated = Array(SampleData.recipes.prefix(3))
                isGenerating = false
            }
        }
    }
}

// 一个轻量的自动换行布局，避免依赖第三方组件。
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var lineHeight: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                x = 0
                y += lineHeight + spacing
                lineHeight = 0
            }
            x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
        return CGSize(width: width, height: y + lineHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var lineHeight: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX
                y += lineHeight + spacing
                lineHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
    }
}
