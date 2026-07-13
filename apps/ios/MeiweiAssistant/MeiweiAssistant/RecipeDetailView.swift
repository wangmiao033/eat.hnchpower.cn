import SwiftUI

struct RecipeDetailView: View {
    @EnvironmentObject private var growth: GrowthStore
    @EnvironmentObject private var shoppingList: ShoppingListStore
    let recipe: Recipe
    @State private var servings = 2
    @State private var checked: Set<String> = []
    @State private var showingCookingMode = false
    @State private var didComplete = false
    @State private var showingShoppingAdded = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                FoodArtwork(style: recipe.artwork)
                    .frame(height: 330)

                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 7) {
                        Text(recipe.tags.prefix(2).joined(separator: " · "))
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppTheme.accent)
                        Text(recipe.name)
                            .font(.system(size: 32, weight: .bold))
                        Text(recipe.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.secondary)
                            .lineSpacing(4)
                    }

                    HStack(spacing: 8) {
                        stat("\(recipe.timeMinutes) 分钟", label: "总用时")
                        stat(recipe.difficulty, label: "难度")
                        stat("\(servings) 人份", label: "可调")
                    }

                    ingredientCard

                    Button {
                        shoppingList.add(recipe: recipe, servings: servings)
                        showingShoppingAdded = true
                    } label: {
                        Label("加入采购清单", systemImage: "cart.badge.plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(SecondaryButtonStyle())

                    Button {
                        showingCookingMode = true
                    } label: {
                        Label("进入烹饪模式", systemImage: "timer")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    stepsCard
                    analysisCard

                    Button {
                        completeRecipe()
                    } label: {
                        Label(didComplete ? "已完成 · 已计入成长" : "完成这道菜", systemImage: didComplete ? "checkmark.circle.fill" : "checkmark")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(didComplete)

                    Text("完成后计入主线称号，并检查隐藏称号条件")
                        .font(.caption2)
                        .foregroundStyle(AppTheme.secondary)
                        .frame(maxWidth: .infinity)
                }
                .padding(20)
                .padding(.top, 5)
                .background(AppTheme.canvas, in: UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32))
                .offset(y: -28)
                .padding(.bottom, -28)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(AppTheme.canvas)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { } label: { Image(systemName: "heart") }
            }
        }
        .sheet(isPresented: $showingCookingMode) {
            CookingModeView(recipe: recipe) { completeRecipe() }
        }
        .alert("已加入采购清单", isPresented: $showingShoppingAdded) {
            Button("知道了", role: .cancel) { }
        } message: {
            Text("\(recipe.name) 的食材已按 \(servings) 人份加入，可在菜谱页的“采购清单”里勾选。")
        }
    }

    private func completeRecipe() {
        guard !didComplete else { return }
        didComplete = true
        growth.recordRecipeCompletion()
    }

    private var ingredientCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("食材").font(.headline)
                Spacer()
                HStack(spacing: 10) {
                    Button { servings = max(1, servings - 1) } label: { Image(systemName: "minus") }
                    Text("\(servings) 人份").font(.caption).foregroundStyle(AppTheme.secondary)
                    Button { servings += 1 } label: { Image(systemName: "plus") }
                }
                .buttonStyle(.plain)
            }

            ForEach(recipe.ingredients) { ingredient in
                Button {
                    if checked.contains(ingredient.id) { checked.remove(ingredient.id) }
                    else { checked.insert(ingredient.id) }
                } label: {
                    HStack {
                        Image(systemName: checked.contains(ingredient.id) ? "checkmark.square.fill" : "square")
                            .foregroundStyle(checked.contains(ingredient.id) ? AppTheme.accent : AppTheme.secondary)
                        Text(ingredient.name)
                            .strikethrough(checked.contains(ingredient.id))
                        Spacer()
                        Text(scaledIngredientAmount(ingredient.amount))
                            .foregroundStyle(AppTheme.secondary)
                    }
                    .font(.subheadline)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(18)
        .meiweiCard()
    }

    private func scaledIngredientAmount(_ amount: String) -> String {
        let trimmed = amount.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !trimmed.contains("适量") && !trimmed.contains("少许") else {
            return trimmed.isEmpty ? "适量" : trimmed
        }

        if trimmed.hasPrefix("半") {
            let unit = String(trimmed.dropFirst())
            let quantity = 0.5 * Double(servings) / 2.0
            return displayAmount(quantity: quantity, unit: unit)
        }

        let pattern = #"^([0-9]+(?:\.[0-9]+)?)(?:\s*)(.*)$"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: trimmed, range: NSRange(trimmed.startIndex..., in: trimmed)),
              let numberRange = Range(match.range(at: 1), in: trimmed)
        else {
            return trimmed
        }

        let value = Double(trimmed[numberRange]) ?? 0
        let unitRange = Range(match.range(at: 2), in: trimmed)
        let unit = unitRange.map { String(trimmed[$0]).trimmingCharacters(in: .whitespacesAndNewlines) }.flatMap { $0.isEmpty ? nil : $0 }
        let quantity = value * Double(servings) / 2.0
        return displayAmount(quantity: quantity, unit: unit)
    }

    private func displayAmount(quantity: Double, unit: String?) -> String {
        let rounded = (quantity * 10).rounded() / 10
        let number: String
        if rounded.rounded() == rounded {
            number = String(Int(rounded))
        } else {
            number = String(format: "%.1f", rounded)
        }
        return unit.map { "\(number) \($0)" } ?? number
    }

    private var stepsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("制作步骤").font(.headline)
                Spacer()
                Text("\(recipe.steps.count) 步").font(.caption).foregroundStyle(AppTheme.secondary)
            }
            .padding(.bottom, 14)

            ForEach(recipe.steps) { step in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(step.id)")
                        .font(.caption.bold())
                        .foregroundStyle(AppTheme.accent)
                        .frame(width: 28, height: 28)
                        .background(AppTheme.accent.opacity(0.12), in: Circle())
                    VStack(alignment: .leading, spacing: 5) {
                        Text(step.text).font(.subheadline).lineSpacing(3)
                        if let minutes = step.minutes {
                            Text("约 \(minutes) 分钟").font(.caption2).foregroundStyle(AppTheme.secondary)
                        }
                    }
                }
                .padding(.vertical, 10)
                if step.id != recipe.steps.last?.id { Divider().opacity(0.45) }
            }
        }
        .padding(18)
        .meiweiCard()
    }

    private var analysisCard: some View {
        VStack(spacing: 0) {
            infoRow("口味标签", value: recipe.tags.prefix(2).joined(separator: " · "))
            Divider().opacity(0.45)
            infoRow("备料提醒", value: "先切配再开火")
            Divider().opacity(0.45)
            infoRow("饮品搭配", value: recipe.beverage)
            Divider().opacity(0.45)
            infoRow("烹饪技巧", value: "按步骤控火")
        }
        .padding(.horizontal, 18)
        .meiweiCard()
    }

    private func stat(_ value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.subheadline.bold())
            Text(label).font(.caption2).foregroundStyle(AppTheme.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 13)
        .background(.white, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
    }

    private func infoRow(_ title: String, value: String) -> some View {
        HStack {
            Text(title).font(.subheadline.bold())
            Spacer()
            Text(value).font(.caption).foregroundStyle(AppTheme.secondary)
            Image(systemName: "chevron.right").font(.caption2).foregroundStyle(.tertiary)
        }
        .padding(.vertical, 16)
    }
}

struct CookingModeView: View {
    let recipe: Recipe
    let onComplete: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var stepIndex = 0

    private var safeSteps: [RecipeStep] {
        recipe.steps.isEmpty
            ? [RecipeStep(id: 1, text: "这道菜的步骤还在整理中，先按食材准备、下锅加热、调味收汁三步完成。", minutes: nil)]
            : recipe.steps
    }

    private var currentStep: RecipeStep {
        safeSteps[min(max(0, stepIndex), safeSteps.count - 1)]
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                ProgressView(value: Double(min(stepIndex + 1, safeSteps.count)), total: Double(safeSteps.count))
                    .tint(AppTheme.accent)

                Spacer()
                Text("步骤 \(min(stepIndex + 1, safeSteps.count)) / \(safeSteps.count)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.accent)
                Text(currentStep.text)
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                if let minutes = currentStep.minutes {
                    Label("约 \(minutes) 分钟", systemImage: "timer")
                        .font(.headline)
                        .foregroundStyle(AppTheme.secondary)
                }
                Spacer()

                HStack(spacing: 12) {
                    Button("上一步") { stepIndex = max(0, stepIndex - 1) }
                        .buttonStyle(SecondaryButtonStyle())
                        .disabled(stepIndex == 0)
                    Button(stepIndex >= safeSteps.count - 1 ? "完成" : "下一步") {
                        if stepIndex >= safeSteps.count - 1 { onComplete(); dismiss() }
                        else { stepIndex += 1 }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding(24)
            .background(AppTheme.canvas.ignoresSafeArea())
            .navigationTitle(recipe.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("关闭") { dismiss() }
                }
            }
        }
    }
}
