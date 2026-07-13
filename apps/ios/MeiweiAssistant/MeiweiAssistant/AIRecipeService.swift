import Foundation
import Security

struct AIRecipeSettings {
    var provider: String
    var model: String
    var apiKey: String

    var isConfigured: Bool {
        !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

enum AIRecipeMode: Equatable {
    case gemini
    case localFallback
}

struct AIRecipeResult {
    let recipes: [Recipe]
    let mode: AIRecipeMode
    let message: String
}

enum AIRecipeError: LocalizedError {
    case emptyIngredients
    case badResponse
    case apiError(String)
    case noRecipe

    var errorDescription: String? {
        switch self {
        case .emptyIngredients:
            return "先写一点手边食材，AI 才知道从哪里下锅。"
        case .badResponse:
            return "AI 返回格式不完整，已切换到本地生成。"
        case .apiError(let message):
            return message.isEmpty ? "AI 服务暂时不可用，已切换到本地生成。" : message
        case .noRecipe:
            return "这次没有生成可用菜谱，已切换到本地生成。"
        }
    }
}

final class AIRecipeSettingsStore {
    static let shared = AIRecipeSettingsStore()

    private let providerKey = "meiwei.ai.provider"
    private let modelKey = "meiwei.ai.model"
    private let apiKeyKey = "meiwei.ai.gemini.apiKey"

    private init() {}

    var settings: AIRecipeSettings {
        AIRecipeSettings(
            provider: UserDefaults.standard.string(forKey: providerKey) ?? "Gemini",
            model: UserDefaults.standard.string(forKey: modelKey) ?? "gemini-2.5-flash-lite",
            apiKey: KeychainStore.read(service: apiKeyKey) ?? ""
        )
    }

    func save(_ settings: AIRecipeSettings) {
        UserDefaults.standard.set(settings.provider, forKey: providerKey)
        UserDefaults.standard.set(settings.model, forKey: modelKey)
        KeychainStore.save(settings.apiKey.trimmingCharacters(in: .whitespacesAndNewlines), service: apiKeyKey)
    }

    func clearAPIKey() {
        KeychainStore.delete(service: apiKeyKey)
    }
}

private enum KeychainStore {
    private static let account = "default"

    static func read(service: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data,
              let text = String(data: data, encoding: .utf8) else {
#if targetEnvironment(simulator)
            return UserDefaults.standard.string(forKey: fallbackKey(service: service))
#else
            return nil
#endif
        }
        return text
    }

    static func save(_ value: String, service: String) {
        delete(service: service)
        guard let data = value.data(using: .utf8), !value.isEmpty else {
#if targetEnvironment(simulator)
            UserDefaults.standard.removeObject(forKey: fallbackKey(service: service))
#endif
            return
        }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
#if targetEnvironment(simulator)
        if status == errSecSuccess {
            UserDefaults.standard.removeObject(forKey: fallbackKey(service: service))
        } else {
            UserDefaults.standard.set(value, forKey: fallbackKey(service: service))
        }
#endif
    }

    static func delete(service: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
#if targetEnvironment(simulator)
        UserDefaults.standard.removeObject(forKey: fallbackKey(service: service))
#endif
    }

#if targetEnvironment(simulator)
    private static func fallbackKey(service: String) -> String {
        "meiwei.simulator.keychain.\(service).\(account)"
    }
#endif
}

final class AIRecipeService {
    static let shared = AIRecipeService()

    private let settingsStore: AIRecipeSettingsStore
    private let session: URLSession

    init(settingsStore: AIRecipeSettingsStore = .shared, session: URLSession = .shared) {
        self.settingsStore = settingsStore
        self.session = session
    }

    func generateRecipes(ingredients rawIngredients: String, preferences: [String]) async -> AIRecipeResult {
        let ingredients = rawIngredients.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !ingredients.isEmpty else {
            return AIRecipeResult(recipes: [], mode: .localFallback, message: AIRecipeError.emptyIngredients.localizedDescription)
        }

        let settings = settingsStore.settings
        guard settings.isConfigured else {
            return AIRecipeResult(
                recipes: Self.localRecipes(ingredients: ingredients, preferences: preferences),
                mode: .localFallback,
                message: "未配置免费 AI Key，已用本地生成先补 3 道可做菜。"
            )
        }

        var lastError: Error?
        for model in Self.geminiModelFallbacks(preferredModel: settings.model) {
            do {
                var requestSettings = settings
                requestSettings.model = model
                let recipes = try await generateWithGemini(ingredients: ingredients, preferences: preferences, settings: requestSettings)
                let note = model == settings.model ? "" : "（已自动切换备用模型）"
                return AIRecipeResult(recipes: recipes, mode: .gemini, message: "已用 \(settings.provider) · \(model) 生成\(note)。")
            } catch {
                lastError = error
            }
        }

        let fallback = Self.localRecipes(ingredients: ingredients, preferences: preferences)
        return AIRecipeResult(recipes: fallback, mode: .localFallback, message: lastError?.localizedDescription ?? AIRecipeError.apiError("").localizedDescription)
    }

    private func generateWithGemini(ingredients: String, preferences: [String], settings: AIRecipeSettings) async throws -> [Recipe] {
        guard let encodedKey = settings.apiKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(settings.model):generateContent?key=\(encodedKey)") else {
            throw AIRecipeError.apiError("AI Key 或模型名格式不正确。")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 45

        let prompt = Self.prompt(ingredients: ingredients, preferences: preferences)
        request.httpBody = try JSONEncoder().encode(GeminiRequest(contents: [
            GeminiContent(parts: [GeminiPart(text: prompt)])
        ]))

        let (data, response) = try await session.data(for: request)
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            let message = (try? JSONDecoder().decode(GeminiErrorResponse.self, from: data).error.message) ?? "AI 请求失败：HTTP \(http.statusCode)"
            throw AIRecipeError.apiError(message)
        }

        let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
        guard let text = geminiResponse.candidates.first?.content.parts.compactMap(\.text).joined(separator: "\n"),
              let jsonData = Self.jsonData(from: text) else {
            throw AIRecipeError.badResponse
        }

        let payload = try JSONDecoder().decode(AIRecipePayload.self, from: jsonData)
        let recipes = payload.recipes.prefix(3).enumerated().map { index, item in
            item.recipe(index: index)
        }
        guard !recipes.isEmpty else { throw AIRecipeError.noRecipe }
        return Array(recipes)
    }

    private static func geminiModelFallbacks(preferredModel: String) -> [String] {
        var models = [
            preferredModel.trimmingCharacters(in: .whitespacesAndNewlines),
            "gemini-2.5-flash-lite",
            "gemini-2.0-flash"
        ]
        models.removeAll { $0.isEmpty }

        var seen = Set<String>()
        return models.filter { seen.insert($0).inserted }
    }

    private static func prompt(ingredients: String, preferences: [String]) -> String {
        """
        你是「美味助手」里的中文家常菜谱创作助手。请基于用户现有食材生成 3 道真实可做的菜，不要编造昂贵或难买食材。

        用户食材：\(ingredients)
        口味与场景：\(preferences.isEmpty ? "家常、易做" : preferences.joined(separator: "、"))

        要求：
        - 只返回 JSON，不要 Markdown，不要解释。
        - JSON 顶层字段为 recipes，数组长度必须为 3。
        - 每道菜必须能在家做，步骤清晰，适合普通厨房。
        - timeMinutes 为整数，difficulty 使用「简单」「中等」「较难」。
        - ingredients 至少 4 项，每项包含 name 和 amount。
        - steps 必须 3 到 5 步，每步一句话。
        - tags 使用中文短标签。
        - 不要输出身体指标、疾病、治疗、减重承诺或安全承诺相关内容。

        JSON 结构：
        {
          "recipes": [
            {
              "name": "菜名",
              "subtitle": "一句话说明",
              "timeMinutes": 20,
              "difficulty": "简单",
              "tags": ["家常", "下饭"],
              "ingredients": [{"name": "番茄", "amount": "2 个"}],
              "steps": ["第一步", "第二步", "第三步"],
              "beverage": "焙火乌龙"
            }
          ]
        }
        """
    }

    private static func jsonData(from text: String) -> Data? {
        var cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned.hasPrefix("```") {
            cleaned = cleaned
                .replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```JSON", with: "")
                .replacingOccurrences(of: "```", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        guard let start = cleaned.firstIndex(of: "{"),
              let end = cleaned.lastIndex(of: "}") else {
            return cleaned.data(using: .utf8)
        }
        return String(cleaned[start...end]).data(using: .utf8)
    }

    private static func localRecipes(ingredients: String, preferences: [String]) -> [Recipe] {
        let parsed = ingredients
            .split { "，,、\n ".contains($0) }
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        let items = parsed.isEmpty ? ["鸡蛋", "青菜", "米饭"] : parsed
        let primary = items.first ?? "鸡蛋"
        let secondary = items.dropFirst().first ?? "青菜"
        let quick = preferences.contains("20 分钟内")
        let light = preferences.contains("清淡") || preferences.contains("少油")
        let hasMeatEggPreference = preferences.contains("肉蛋搭配")

        return [
            Recipe(
                id: "ai-local-\(abs((ingredients + "stir").hashValue))",
                name: "\(primary)\(secondary)快手小炒",
                subtitle: "把手边食材先炒香，再用一口锅收成下饭菜。",
                timeMinutes: quick ? 15 : 22,
                difficulty: "简单",
                tags: ["AI 本地", "快手", light ? "少油" : "下饭"],
                ingredients: [
                    RecipeIngredient(id: "local-1-1", name: primary, amount: "适量"),
                    RecipeIngredient(id: "local-1-2", name: secondary, amount: "适量"),
                    RecipeIngredient(id: "local-1-3", name: "蒜", amount: "2 瓣"),
                    RecipeIngredient(id: "local-1-4", name: "生抽", amount: "1 勺")
                ],
                steps: [
                    RecipeStep(id: 1, text: "把 \(primary) 和 \(secondary) 处理成容易入口的大小，蒜切末。", minutes: 5),
                    RecipeStep(id: 2, text: "热锅少油，先下蒜末炒香，再放入主要食材翻炒。", minutes: 6),
                    RecipeStep(id: 3, text: "加生抽和少量水收汁，出锅前按口味补盐。", minutes: 4)
                ],
                beverage: "清香乌龙茶",
                artwork: .noodles
            ),
            Recipe(
                id: "ai-local-\(abs((ingredients + "rice").hashValue))",
                name: "\(primary)盖饭碗",
                subtitle: "适合一个人快速吃饱，也方便把剩菜变成正经一餐。",
                timeMinutes: 18,
                difficulty: "简单",
                tags: ["AI 本地", "一人食", "饱腹"],
                ingredients: [
                    RecipeIngredient(id: "local-2-1", name: primary, amount: "适量"),
                    RecipeIngredient(id: "local-2-2", name: "米饭", amount: "1 碗"),
                    RecipeIngredient(id: "local-2-3", name: secondary, amount: "适量"),
                    RecipeIngredient(id: "local-2-4", name: "蚝油", amount: "半勺")
                ],
                steps: [
                    RecipeStep(id: 1, text: "把食材切小块，米饭提前盛入碗中。", minutes: 4),
                    RecipeStep(id: 2, text: "锅中炒熟 \(primary)，再加入 \(secondary) 和调味料。", minutes: 8),
                    RecipeStep(id: 3, text: "加一点热水形成薄汁，盖在米饭上即可。", minutes: 3)
                ],
                beverage: "焙火乌龙",
                artwork: .tomatoEgg
            ),
            Recipe(
                id: "ai-local-\(abs((ingredients + "soup").hashValue))",
                name: "\(secondary)\(primary)暖胃汤",
                subtitle: "不想大动干戈时，用一锅热汤把食材变温柔。",
                timeMinutes: 20,
                difficulty: "简单",
                tags: ["AI 本地", "清淡", "暖胃"],
                ingredients: [
                    RecipeIngredient(id: "local-3-1", name: secondary, amount: "适量"),
                    RecipeIngredient(id: "local-3-2", name: primary, amount: "适量"),
                    RecipeIngredient(id: "local-3-3", name: "姜", amount: "2 片"),
                    RecipeIngredient(id: "local-3-4", name: "盐", amount: "少许")
                ],
                steps: [
                    RecipeStep(id: 1, text: "锅中加水和姜片煮开，先放耐煮食材。", minutes: 6),
                    RecipeStep(id: 2, text: "加入 \(primary) 和 \(secondary)，保持小火煮到熟透。", minutes: 10),
                    RecipeStep(id: 3, text: "出锅前用盐调味，想更香可滴几滴香油。", minutes: 2)
                ],
                beverage: "温热麦茶",
                artwork: .mushroomChicken
            )
        ]
    }
}

private struct GeminiRequest: Encodable {
    let contents: [GeminiContent]
}

private struct GeminiContent: Codable {
    let parts: [GeminiPart]
}

private struct GeminiPart: Codable {
    let text: String?
}

private struct GeminiResponse: Decodable {
    let candidates: [Candidate]

    struct Candidate: Decodable {
        let content: GeminiContent
    }
}

private struct GeminiErrorResponse: Decodable {
    let error: GeminiAPIError

    struct GeminiAPIError: Decodable {
        let message: String
    }
}

private struct AIRecipePayload: Decodable {
    let recipes: [AIRecipeRecord]
}

private struct AIRecipeRecord: Decodable {
    struct Ingredient: Decodable {
        let name: String
        let amount: String
    }

    let name: String
    let subtitle: String
    let timeMinutes: Int
    let difficulty: String
    let tags: [String]
    let ingredients: [Ingredient]
    let steps: [String]
    let beverage: String

    func recipe(index: Int) -> Recipe {
        let safeName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let seed = safeName.isEmpty ? UUID().uuidString : safeName
        return Recipe(
            id: "ai-\(abs((seed + String(index)).hashValue))",
            name: safeName.isEmpty ? "AI 灵感菜谱" : safeName,
            subtitle: subtitle,
            timeMinutes: max(5, min(120, timeMinutes)),
            difficulty: difficulty,
            tags: tags.isEmpty ? ["AI 生成"] : Array(tags.prefix(5)),
            ingredients: ingredients.prefix(8).enumerated().map { idx, ingredient in
                RecipeIngredient(id: "ai-\(abs(seed.hashValue))-\(idx)", name: ingredient.name, amount: ingredient.amount)
            },
            steps: steps.prefix(6).enumerated().map { idx, step in
                RecipeStep(id: idx + 1, text: step, minutes: nil)
            },
            beverage: beverage.isEmpty ? "清香乌龙茶" : beverage,
            artwork: Self.artwork(tags: tags, name: safeName)
        )
    }

    private static func artwork(tags: [String], name: String) -> ArtworkStyle {
        let text = (tags + [name]).joined(separator: " ")
        if text.contains("番茄") || text.contains("蛋") { return .tomatoEgg }
        if text.contains("虾") || text.contains("西兰花") { return .shrimpBroccoli }
        if text.contains("鸡") || text.contains("菌") || text.contains("菇") { return .mushroomChicken }
        if text.contains("豆腐") || text.contains("辣") { return .mapoTofu }
        if text.contains("牛") || text.contains("土豆") { return .beefPotato }
        return .noodles
    }
}
