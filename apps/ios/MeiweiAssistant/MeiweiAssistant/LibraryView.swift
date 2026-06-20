import SwiftUI

struct LibraryView: View {
    @State private var segment = 0
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("个人收藏").font(.caption.weight(.semibold)).foregroundStyle(AppTheme.secondary)
                        Text("我的菜谱").font(.system(size: 34, weight: .bold))
                    }
                    Spacer()
                    Image(systemName: "square.grid.2x2")
                        .frame(width: 42, height: 42)
                        .background(.thinMaterial, in: Circle())
                }

                Picker("菜谱分类", selection: $segment) {
                    Text("收藏").tag(0)
                    Text("做过").tag(1)
                    Text("菜单").tag(2)
                }
                .pickerStyle(.segmented)

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(SampleData.recipes.prefix(4)) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {
                            VStack(alignment: .leading, spacing: 0) {
                                ZStack(alignment: .topTrailing) {
                                    FoodArtwork(style: recipe.artwork).frame(height: 130)
                                    Image(systemName: "heart.fill")
                                        .font(.caption)
                                        .padding(9)
                                        .background(.ultraThinMaterial, in: Circle())
                                        .padding(10)
                                }
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(recipe.name).font(.subheadline.bold())
                                    Text("\(recipe.timeMinutes) 分钟 · \(recipe.tags.first ?? recipe.difficulty)")
                                        .font(.caption2)
                                        .foregroundStyle(AppTheme.secondary)
                                }
                                .padding(12)
                            }
                            .meiweiCard()
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text("更多工具").font(.title3.bold()).padding(.top, 8)
                NavigationLink {
                    TableMenuView()
                } label: {
                    toolRow("一桌好菜", subtitle: "按人数与场景生成完整菜单", icon: "frying.pan")
                }
                .buttonStyle(.plain)

                NavigationLink {
                    SauceAssistantView()
                } label: {
                    toolRow("酱料助手", subtitle: "根据口味定制酱汁配方", icon: "drop")
                }
                .buttonStyle(.plain)
                NavigationLink {
                    CreateRecipeView()
                } label: {
                    toolRow("AI 菜谱创作", subtitle: "输入食材与口味，生成可执行菜谱", icon: "sparkles")
                }
                .buttonStyle(.plain)
            }
            .padding(18)
            .padding(.bottom, 22)
        }
        .background(AppTheme.canvas.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    private func toolRow(_ title: String, subtitle: String, icon: String) -> some View {
        HStack(spacing: 13) {
            Image(systemName: icon)
                .foregroundStyle(AppTheme.accent)
                .frame(width: 44, height: 44)
                .background(AppTheme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline.bold())
                Text(subtitle).font(.caption2).foregroundStyle(AppTheme.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 21, style: .continuous))
    }
}
