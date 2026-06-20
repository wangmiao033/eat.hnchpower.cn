import SwiftUI

struct TodayView: View {
    private let recipes = SampleData.recipes
    @State private var selectedIndex: Int

    init() {
        let daily = DailyRecipeProvider.recipe()
        _selectedIndex = State(initialValue: SampleData.recipes.firstIndex(of: daily) ?? 0)
    }

    private var selectedRecipe: Recipe { recipes[selectedIndex] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                dailyCard
                inspiration
            }
            .padding(.bottom, 24)
        }
        .background(AppTheme.canvas.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text(Date.now.formatted(.dateTime.month().day().weekday(.wide)))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.secondary)
                Text("今天吃什么")
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .tracking(-1.2)
            }
            Spacer()
            HStack(spacing: 9) {
                NavigationLink {
                    CreateRecipeView()
                } label: {
                    Image(systemName: "sparkles")
                        .font(.subheadline.bold())
                        .foregroundStyle(AppTheme.ink)
                        .frame(width: 42, height: 42)
                        .background(.white.opacity(0.78), in: Circle())
                        .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
                }
                .buttonStyle(.plain)

                Text("味")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(LinearGradient(colors: [Color.orange, AppTheme.accent], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 18)
    }

    private var dailyCard: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                FoodArtwork(style: selectedRecipe.artwork)
                    .frame(height: 270)
                Text("每日一菜")
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(16)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("TODAY'S PICK")
                    .font(.caption2.weight(.bold))
                    .tracking(1.3)
                    .foregroundStyle(AppTheme.accent)
                Text(selectedRecipe.name)
                    .font(.system(size: 30, weight: .bold))
                Text("\(selectedRecipe.subtitle) 今天先从这道能下锅的推荐开始。")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondary)
                    .lineSpacing(4)

                HStack(spacing: 8) {
                    metric("\(selectedRecipe.timeMinutes) 分钟")
                    metric(selectedRecipe.difficulty)
                    metric("约 \(selectedRecipe.calories) kcal")
                }

                HStack(spacing: 10) {
                    NavigationLink {
                        RecipeDetailView(recipe: selectedRecipe)
                    } label: {
                        Label("开始做", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    Button {
                        withAnimation(.snappy) {
                            selectedIndex = (selectedIndex + 1) % recipes.count
                        }
                    } label: {
                        Label("换一道", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                .padding(.top, 5)
            }
            .padding(20)
        }
        .meiweiCard()
        .padding(.horizontal, 18)
    }

    private var inspiration: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack {
                Text("今晚灵感").font(.title3.bold())
                Spacer()
                Text("查看全部").font(.caption).foregroundStyle(AppTheme.secondary)
            }

            HStack(spacing: 12) {
                ForEach(recipes.filter { $0.id != selectedRecipe.id }.prefix(2)) { recipe in
                    NavigationLink {
                        RecipeDetailView(recipe: recipe)
                    } label: {
                        VStack(alignment: .leading, spacing: 0) {
                            FoodArtwork(style: recipe.artwork).frame(height: 110)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(recipe.name).font(.subheadline.bold())
                                Text("\(recipe.timeMinutes) 分钟 · \(recipe.tags.first ?? recipe.difficulty)")
                                    .font(.caption2)
                                    .foregroundStyle(AppTheme.secondary)
                            }
                            .padding(12)
                        }
                        .frame(maxWidth: .infinity)
                        .meiweiCard()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 28)
    }

    private func metric(_ text: String) -> some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(Color.black.opacity(0.05), in: Capsule())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .frame(height: 50)
            .background(AppTheme.ink.opacity(configuration.isPressed ? 0.82 : 1), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.bold())
            .padding(.horizontal, 15)
            .frame(height: 50)
            .background(Color.black.opacity(configuration.isPressed ? 0.09 : 0.05), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
