import Foundation

struct ShoppingListItem: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var category: String
    var quantity: Double?
    var unit: String?
    var displayAmount: String
    var recipeNames: [String]
    var isChecked: Bool
}

@MainActor
final class ShoppingListStore: ObservableObject {
    @Published private(set) var items: [ShoppingListItem] = [] {
        didSet { save() }
    }

    private let storageKey = "meiwei.shoppingList.items.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    private let defaults: UserDefaults

    var pendingCount: Int {
        items.filter { !$0.isChecked }.count
    }

    var checkedCount: Int {
        items.filter(\.isChecked).count
    }

    var groupedItems: [(category: String, items: [ShoppingListItem])] {
        let order = ["肉蛋", "蔬菜", "主食", "豆制品", "干货", "调料", "常备", "其他"]
        let grouped = Dictionary(grouping: items.sorted { lhs, rhs in
            if lhs.isChecked != rhs.isChecked { return !lhs.isChecked }
            return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
        }, by: \.category)

        return order.compactMap { category in
            guard let values = grouped[category], !values.isEmpty else { return nil }
            return (category, values)
        }
    }

    func add(recipe: Recipe, servings: Int) {
        let safeServings = max(1, servings)
        var next = items

        for ingredient in recipe.ingredients.flatMap({ expandedIngredients(from: $0) }) {
            let scaled = scaledAmount(ingredient.amount, servings: safeServings)
            let category = category(for: ingredient.name)
            let itemID = normalizedID(name: ingredient.name, unit: scaled.unit)

            if let index = next.firstIndex(where: { $0.id == itemID }) {
                next[index].recipeNames.appendIfMissing(recipe.name)
                next[index].isChecked = false

                if let oldQuantity = next[index].quantity, let addedQuantity = scaled.quantity, next[index].unit == scaled.unit {
                    next[index].quantity = oldQuantity + addedQuantity
                    next[index].displayAmount = displayAmount(quantity: oldQuantity + addedQuantity, unit: scaled.unit)
                } else if !next[index].displayAmount.contains(scaled.display) {
                    next[index].displayAmount = "\(next[index].displayAmount) + \(scaled.display)"
                }
            } else {
                next.append(
                    ShoppingListItem(
                        id: itemID,
                        name: ingredient.name,
                        category: category,
                        quantity: scaled.quantity,
                        unit: scaled.unit,
                        displayAmount: scaled.display,
                        recipeNames: [recipe.name],
                        isChecked: false
                    )
                )
            }
        }

        items = next.sorted { lhs, rhs in
            if lhs.category != rhs.category { return categoryRank(lhs.category) < categoryRank(rhs.category) }
            return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
        }
    }

    func toggle(_ item: ShoppingListItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isChecked.toggle()
    }

    func remove(_ item: ShoppingListItem) {
        items.removeAll { $0.id == item.id }
    }

    func clearChecked() {
        items.removeAll { $0.isChecked }
    }

    func clearAll() {
        items = []
    }

    private func load() {
        guard let data = defaults.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([ShoppingListItem].self, from: data)
        else { return }
        items = decoded
    }

    private func save() {
        guard let encoded = try? JSONEncoder().encode(items) else { return }
        defaults.set(encoded, forKey: storageKey)
    }

    private func expandedIngredients(from ingredient: RecipeIngredient) -> [RecipeIngredient] {
        let parts = ingredient.name
            .components(separatedBy: CharacterSet(charactersIn: "、/，"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard parts.count > 1, ingredient.amount.contains("适量") else { return [ingredient] }
        return parts.map { RecipeIngredient(id: "\(ingredient.id)-\($0)", name: $0, amount: ingredient.amount) }
    }

    private func scaledAmount(_ amount: String, servings: Int) -> (quantity: Double?, unit: String?, display: String) {
        let trimmed = amount.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !trimmed.contains("适量") && !trimmed.contains("少许") else {
            return (nil, nil, trimmed.isEmpty ? "适量" : trimmed)
        }

        if trimmed.hasPrefix("半") {
            let unit = String(trimmed.dropFirst())
            let quantity = 0.5 * Double(servings) / 2.0
            return (quantity, unit, displayAmount(quantity: quantity, unit: unit))
        }

        let pattern = #"^([0-9]+(?:\.[0-9]+)?)(?:\s*)(.*)$"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: trimmed, range: NSRange(trimmed.startIndex..., in: trimmed)),
              let numberRange = Range(match.range(at: 1), in: trimmed)
        else {
            return (nil, nil, trimmed)
        }

        let value = Double(trimmed[numberRange]) ?? 0
        let unitRange = Range(match.range(at: 2), in: trimmed)
        let unit = unitRange.map { String(trimmed[$0]).trimmingCharacters(in: .whitespacesAndNewlines) }.flatMap { $0.isEmpty ? nil : $0 }
        let quantity = value * Double(servings) / 2.0
        return (quantity, unit, displayAmount(quantity: quantity, unit: unit))
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

    private func category(for name: String) -> String {
        let meatKeywords = ["鸡", "牛", "猪", "肉", "虾", "鱼", "蛋", "腩", "排骨"]
        let vegetableKeywords = ["番茄", "西兰花", "香菇", "土豆", "胡萝卜", "葱", "姜", "蒜", "辣椒", "茄子", "冬瓜", "青菜", "罗勒", "九层塔", "黄瓜", "花菜"]
        let stapleKeywords = ["米饭", "面", "粉", "饼", "馒头"]
        let tofuKeywords = ["豆腐", "腐竹", "豆皮"]
        let dryKeywords = ["花生", "干辣椒", "八角", "花椒", "木耳"]
        let seasoningKeywords = ["盐", "糖", "生抽", "老抽", "醋", "料酒", "蚝油", "豆瓣酱", "淀粉", "鱼露", "味淋", "蜂蜜", "黑胡椒", "食用油"]

        if meatKeywords.contains(where: name.contains) { return "肉蛋" }
        if vegetableKeywords.contains(where: name.contains) { return "蔬菜" }
        if stapleKeywords.contains(where: name.contains) { return "主食" }
        if tofuKeywords.contains(where: name.contains) { return "豆制品" }
        if dryKeywords.contains(where: name.contains) { return "干货" }
        if seasoningKeywords.contains(where: name.contains) { return "调料" }
        return "其他"
    }

    private func normalizedID(name: String, unit: String?) -> String {
        let base = name
            .replacingOccurrences(of: "末", with: "")
            .replacingOccurrences(of: "丝", with: "")
            .replacingOccurrences(of: "片", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return "\(base)-\(unit ?? "loose")"
    }

    private func categoryRank(_ category: String) -> Int {
        ["肉蛋", "蔬菜", "主食", "豆制品", "干货", "调料", "常备", "其他"].firstIndex(of: category) ?? 99
    }
}

private extension Array where Element == String {
    mutating func appendIfMissing(_ value: String) {
        if !contains(value) {
            append(value)
        }
    }
}
