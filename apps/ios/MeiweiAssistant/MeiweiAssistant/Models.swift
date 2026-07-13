import Foundation

struct Recipe: Identifiable, Hashable {
    let id: String
    let name: String
    let subtitle: String
    let timeMinutes: Int
    let difficulty: String
    let tags: [String]
    let ingredients: [RecipeIngredient]
    let steps: [RecipeStep]
    let beverage: String
    let artwork: ArtworkStyle
}

struct RecipeIngredient: Identifiable, Hashable {
    let id: String
    let name: String
    let amount: String
}

struct RecipeStep: Identifiable, Hashable {
    let id: Int
    let text: String
    let minutes: Int?
}

enum ArtworkStyle: String, Hashable {
    case tomatoEgg
    case shrimpBroccoli
    case mushroomChicken
    case mapoTofu
    case beefPotato
    case noodles
}

enum AppTab: Hashable {
    case today
    case party
    case mystic
    case create
    case library
    case profile
}
