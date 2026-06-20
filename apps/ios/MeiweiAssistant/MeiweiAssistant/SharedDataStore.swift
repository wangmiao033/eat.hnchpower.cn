import Foundation
import SwiftUI

struct SharedPartyRole: Identifiable, Hashable {
    let id: String
    let label: String
    let icon: String
    let description: String
}

struct MysticCastOutcome {
    let recipe: Recipe
    let score: Int
    let flavor: String
    let ingredient: String
    let message: String
}

struct MysticMoodRecord: Decodable, Identifiable, Hashable {
    let id: String
    let emoji: String
    let flavor: String
    let burden: String
    let recipeBias: [String]
}

private struct SharedRecipeRecord: Decodable {
    struct Ingredient: Decodable {
        let name: String
        let amount: String
    }

    let id: String
    let name: String
    let cuisine: String
    let category: String
    let time: Int
    let difficulty: String
    let calories: Int
    let tags: [String]
    let moodTags: [String]
    let luckyIngredients: [String]
    let flavor: String
    let reason: String
    let ingredients: [Ingredient]
    let steps: [String]
    let tips: [String]
}

private struct MysticCatalogResource: Decodable {
    let modes: [MysticModeRecord]
    let moods: [MysticMoodRecord]
    let tarotCards: [MysticTarotRecord]
    let flavorSticks: [MysticFlavorStickRecord]
    let zodiacSigns: [String]
    let animalSigns: [String]
}

private struct MysticModeRecord: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let subtitle: String
    let icon: String
    let description: String
}

private struct MysticTarotRecord: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let meaning: String
    let recipeBias: [String]
}

private struct MysticFlavorStickRecord: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let blessing: String
    let recipeBias: [String]
}

private struct PartyCatalogResource: Decodable {
    let roles: [RoleRecord]
    let defaultPlayers: [PlayerRecord]
    let diceFaceRecipeSlots: [DiceFaceRecipeSlot]

    struct RoleRecord: Decodable {
        let id: String
        let label: String
        let icon: String
        let description: String
    }

    struct PlayerRecord: Decodable {
        let id: String
        let name: String
    }

    struct DiceFaceRecipeSlot: Decodable {
        let face: Int
        let label: String
        let recipeIds: [String]
    }
}

final class SharedDataStore {
    static let shared = SharedDataStore()

    let recipes: [Recipe]
    let titleRules: TitleCatalogResource?
    let mysticMoods: [MysticMoodRecord]
    let partyRoles: [SharedPartyRole]
    let defaultPartyParticipantNames: [String]

    private let recipeRecords: [SharedRecipeRecord]
    private let mysticCatalog: MysticCatalogResource?
    private let partyCatalog: PartyCatalogResource?

    private init(bundle: Bundle = .main) {
        recipeRecords = Self.load([SharedRecipeRecord].self, resource: "recipes", bundle: bundle) ?? []
        recipes = recipeRecords.map(Self.makeRecipe)
        titleRules = Self.load(TitleCatalogResource.self, resource: "titles", bundle: bundle)
            ?? (try? AchievementRuleEngine.loadCatalog(bundle: bundle))
        mysticCatalog = Self.load(MysticCatalogResource.self, resource: "mystic", bundle: bundle)
        mysticMoods = mysticCatalog?.moods ?? []
        partyCatalog = Self.load(PartyCatalogResource.self, resource: "party-games", bundle: bundle)
        partyRoles = partyCatalog?.roles.map {
            SharedPartyRole(id: $0.id, label: $0.label, icon: $0.icon, description: $0.description)
        } ?? []
        defaultPartyParticipantNames = partyCatalog?.defaultPlayers.map(\.name).filter { !$0.isEmpty } ?? []
    }

    var mainTitles: [MainTitleDefinition]? {
        guard let records = titleRules?.mainTitles, !records.isEmpty else { return nil }
        return records
            .sorted { $0.sortOrder < $1.sortOrder }
            .map {
                MainTitleDefinition(
                    id: $0.id,
                    requiredRecipeCount: $0.requiredRecipeCount,
                    quality: Self.quality(rawValue: $0.quality, key: $0.qualityKey),
                    title: $0.title
                )
            }
    }

    var hiddenTitles: [HiddenTitleDefinition]? {
        guard let records = titleRules?.hiddenTitles, !records.isEmpty else { return nil }
        return records.map {
            HiddenTitleDefinition(
                id: $0.id,
                category: $0.category,
                title: $0.title,
                hint: $0.hint,
                description: "解锁条件：\($0.condition)。",
                symbol: Self.symbol(for: $0)
            )
        }
    }

    func recipe(id: String) -> Recipe? {
        recipes.first { $0.id == id }
    }

    func recipeForDiceFace(_ face: Int) -> Recipe {
        let ids = partyCatalog?.diceFaceRecipeSlots.first { $0.face == face }?.recipeIds ?? []
        return firstRecipe(matching: ids) ?? recipes[safe: max(0, min(recipes.count - 1, face - 1))] ?? SampleData.fallbackRecipes[0]
    }

    func castMystic(mode: String, mood: String, number: Int) -> MysticCastOutcome {
        let recipe: Recipe
        let flavor: String
        let message: String

        switch mode {
        case "mood":
            let record = mysticCatalog?.moods.first { $0.id == mood }
            recipe = firstRecipe(matching: record?.recipeBias ?? []) ?? recipes.first ?? SampleData.fallbackRecipes[0]
            flavor = record?.flavor ?? recipe.tags.first ?? "家常"
            message = "\(mood) 的时候，适合让 \(flavor) 帮你把这一餐稳住。"
        case "tarot":
            let card = mysticCatalog?.tarotCards.randomElement()
            recipe = firstRecipe(matching: card?.recipeBias ?? []) ?? recipes.randomElement() ?? SampleData.fallbackRecipes[0]
            flavor = card?.name ?? recipe.tags.first ?? "菜牌"
            message = card?.meaning ?? "今晚的牌面指向一道能真正下锅的菜。"
        case "number":
            let safeRecipes = recipes.isEmpty ? SampleData.fallbackRecipes : recipes
            recipe = safeRecipes[abs(number) % safeRecipes.count]
            flavor = "幸运数字 \(max(1, min(99, number)))"
            message = "数字已经落位，今晚按这个节奏开火。"
        case "couple":
            let ids = ["mushroom-chicken", "potato-beef", "teriyaki-chicken-rice"]
            recipe = firstRecipe(matching: ids) ?? recipes.first ?? SampleData.fallbackRecipes[0]
            flavor = "双人合拍"
            message = "两个人吃饭，最重要的是一锅能分着夹、能一起收尾。"
        case "sticks":
            let stick = mysticCatalog?.flavorSticks.randomElement()
            recipe = firstRecipe(matching: stick?.recipeBias ?? []) ?? recipes.randomElement() ?? SampleData.fallbackRecipes[0]
            flavor = stick?.name ?? recipe.tags.first ?? "灵签"
            message = stick?.blessing ?? "五味落签，今晚就按这一口来。"
        default:
            let day = Calendar.current.ordinality(of: .day, in: .era, for: .now) ?? 0
            let zodiac = mysticCatalog?.zodiacSigns[safe: day % max(1, mysticCatalog?.zodiacSigns.count ?? 1)] ?? "今日"
            let animal = mysticCatalog?.animalSigns[safe: day % max(1, mysticCatalog?.animalSigns.count ?? 1)] ?? "食运"
            recipe = DailyRecipeProvider.recipe(recipes: recipes.isEmpty ? SampleData.fallbackRecipes : recipes)
            flavor = "\(zodiac) × \(animal)"
            message = "今日食运建议少纠结，多开火。让一道真正能完成的菜，替今天收个好尾。"
        }

        return MysticCastOutcome(
            recipe: recipe,
            score: score(for: recipe, mode: mode),
            flavor: flavor,
            ingredient: recipeRecords.first { $0.id == recipe.id }?.luckyIngredients.first ?? recipe.ingredients.first?.name ?? "时令食材",
            message: message
        )
    }

    private func firstRecipe(matching ids: [String]) -> Recipe? {
        ids.compactMap(recipe(id:)).first
    }

    private static func load<T: Decodable>(_ type: T.Type, resource: String, bundle: Bundle) -> T? {
        guard let url = bundle.url(forResource: resource, withExtension: "json") else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: Data(contentsOf: url))
        } catch {
            assertionFailure("Failed to decode \(resource).json: \(error)")
            return nil
        }
    }

    private static func makeRecipe(_ record: SharedRecipeRecord) -> Recipe {
        Recipe(
            id: record.id,
            name: record.name,
            subtitle: record.reason,
            timeMinutes: record.time,
            difficulty: difficultyLabel(record.difficulty),
            tags: record.tags.isEmpty ? [record.category, record.cuisine] : record.tags,
            ingredients: record.ingredients.enumerated().map { index, ingredient in
                RecipeIngredient(id: "\(record.id)-ingredient-\(index)", name: ingredient.name, amount: ingredient.amount)
            },
            steps: record.steps.enumerated().map { index, text in
                RecipeStep(id: index + 1, text: text, minutes: nil)
            },
            calories: record.calories,
            protein: proteinEstimate(for: record),
            healthScore: healthScoreEstimate(for: record),
            beverage: beverage(for: record),
            artwork: artwork(for: record.id)
        )
    }

    private static func difficultyLabel(_ value: String) -> String {
        switch value {
        case "easy": "简单"
        case "medium": "中等"
        case "hard": "较难"
        default: value
        }
    }

    private static func proteinEstimate(for record: SharedRecipeRecord) -> Int {
        if record.tags.contains(where: { $0.contains("高蛋白") }) { return 32 }
        if record.name.contains("牛") { return 42 }
        if record.name.contains("鸡") { return 34 }
        if record.name.contains("虾") { return 31 }
        if record.name.contains("蛋") || record.name.contains("豆腐") { return 20 }
        return 16
    }

    private static func healthScoreEstimate(for record: SharedRecipeRecord) -> Double {
        if record.tags.contains(where: { $0.contains("减脂") || $0.contains("清淡") }) { return 8.8 }
        if record.tags.contains(where: { $0.contains("麻辣") || $0.contains("硬菜") }) { return 7.6 }
        return 8.2
    }

    private static func beverage(for record: SharedRecipeRecord) -> String {
        if record.tags.contains(where: { $0.contains("麻辣") || $0.contains("酸辣") }) { return "冰镇酸梅汤" }
        if record.tags.contains(where: { $0.contains("清淡") || $0.contains("减脂") }) { return "清香乌龙茶" }
        return "焙火乌龙"
    }

    private static func artwork(for id: String) -> ArtworkStyle {
        switch id {
        case "tomato-egg": .tomatoEgg
        case "shrimp-broccoli": .shrimpBroccoli
        case "mushroom-chicken": .mushroomChicken
        case "mapo-tofu": .mapoTofu
        case "potato-beef": .beefPotato
        default: .noodles
        }
    }

    private static func quality(rawValue: String, key: String) -> TitleQuality {
        if let quality = TitleQuality(rawValue: rawValue) { return quality }
        switch key {
        case "fine": return .fine
        case "rare": return .rare
        case "epic": return .epic
        case "legendary": return .legendary
        case "mythic": return .mythic
        case "supreme": return .supreme
        default: return .common
        }
    }

    private static func symbol(for record: HiddenTitleRuleRecord) -> String {
        switch record.rule.metric {
        case "cookingStreakDays": "flame.fill"
        case "diceRollCount", "randomRecipeRerollAfterRejectCount", "sameRandomCategoryStreak": "die.face.5.fill"
        case "mysticCastCount": "moon.stars.fill"
        case "favoriteRecipeCount": "heart.fill"
        case "recipeShareCount": "square.and.arrow.up.fill"
        case "recipeCompletionCount", "recipesCompletedInWindow": "fork.knife"
        default: "sparkles"
        }
    }

    private func score(for recipe: Recipe, mode: String) -> Int {
        let base = 86 + abs(recipe.id.hashValue + mode.hashValue) % 10
        return min(99, base)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
