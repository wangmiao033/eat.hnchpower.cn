import SwiftUI

struct TableMenuView: View {
    @State private var people = 4
    @State private var scene = "朋友小聚"
    @State private var taste = "家常"
    @State private var generated = false

    private let scenes = ["日常晚餐", "朋友小聚", "家庭聚餐", "生日宴"]
    private let tastes = ["家常", "清淡", "下饭", "鲜香"]

    private var dishCount: Int { min(SampleData.recipes.count, max(2, people + 1)) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("TABLE PLANNER").font(.caption2.weight(.heavy)).tracking(1.3).foregroundStyle(AppTheme.accent)
                    Text("一桌好菜").font(.system(size: 34, weight: .bold))
                    Text("按人数、场景和口味，组合一份能真正执行的菜单。")
                        .font(.subheadline).foregroundStyle(AppTheme.secondary)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Stepper("用餐人数 · \(people) 人", value: $people, in: 1...10)
                        .font(.headline)
                    optionSection("用餐场景", options: scenes, selected: $scene)
                    optionSection("整体口味", options: tastes, selected: $taste)
                    Button {
                        withAnimation(.snappy) { generated = true }
                    } label: {
                        Label("生成一桌好菜", systemImage: "sparkles").frame(maxWidth: .infinity)
                    }.buttonStyle(PrimaryButtonStyle())
                }
                .padding(18).meiweiCard()

                if generated {
                    VStack(alignment: .leading, spacing: 13) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("今晚菜单").font(.title3.bold())
                                Text("\(scene) · \(people) 人 · \(taste)").font(.caption).foregroundStyle(AppTheme.secondary)
                            }
                            Spacer()
                            Text("\(dishCount) 道").font(.caption.bold()).foregroundStyle(AppTheme.accent)
                        }

                        ForEach(Array(SampleData.recipes.prefix(dishCount).enumerated()), id: \.element.id) { index, recipe in
                            NavigationLink {
                                RecipeDetailView(recipe: recipe)
                            } label: {
                                HStack(spacing: 12) {
                                    FoodArtwork(style: recipe.artwork)
                                        .frame(width: 72, height: 62)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(index == 0 ? "主菜 · \(recipe.name)" : recipe.name).font(.subheadline.bold())
                                        Text("\(recipe.timeMinutes) 分钟 · \(recipe.tags.first ?? recipe.difficulty)")
                                            .font(.caption2).foregroundStyle(AppTheme.secondary)
                                    }
                                    Spacer(); Image(systemName: "chevron.right").font(.caption).foregroundStyle(.tertiary)
                                }
                            }.buttonStyle(.plain)
                            if index < dishCount - 1 { Divider().opacity(0.45) }
                        }
                    }
                    .padding(18).meiweiCard().transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }.padding(18)
        }
        .background(AppTheme.canvas.ignoresSafeArea())
        .navigationTitle("一桌好菜").navigationBarTitleDisplayMode(.inline)
    }

    private func optionSection(_ title: String, options: [String], selected: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(title).font(.subheadline.bold())
            FlowLayout(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    Button(option) { selected.wrappedValue = option }
                        .font(.caption.bold()).padding(.horizontal, 12).padding(.vertical, 9)
                        .background(selected.wrappedValue == option ? AppTheme.ink : Color.black.opacity(0.05), in: Capsule())
                        .foregroundStyle(selected.wrappedValue == option ? .white : AppTheme.ink)
                }.buttonStyle(.plain)
            }
        }
    }
}
