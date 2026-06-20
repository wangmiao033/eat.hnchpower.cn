import Foundation

enum CatalogJSONValue: Codable, Hashable {
    case string(String), int(Int), double(Double), bool(Bool)
    case array([CatalogJSONValue]), object([String: CatalogJSONValue]), null

    init(from decoder: Decoder) throws {
        let box = try decoder.singleValueContainer()
        if box.decodeNil() { self = .null }
        else if let value = try? box.decode(Bool.self) { self = .bool(value) }
        else if let value = try? box.decode(Int.self) { self = .int(value) }
        else if let value = try? box.decode(Double.self) { self = .double(value) }
        else if let value = try? box.decode(String.self) { self = .string(value) }
        else if let value = try? box.decode([CatalogJSONValue].self) { self = .array(value) }
        else { self = .object(try box.decode([String: CatalogJSONValue].self)) }
    }

    func encode(to encoder: Encoder) throws {
        var box = encoder.singleValueContainer()
        switch self {
        case .string(let value): try box.encode(value)
        case .int(let value): try box.encode(value)
        case .double(let value): try box.encode(value)
        case .bool(let value): try box.encode(value)
        case .array(let value): try box.encode(value)
        case .object(let value): try box.encode(value)
        case .null: try box.encodeNil()
        }
    }

    var stableKey: String {
        switch self {
        case .string(let value): value
        case .int(let value): String(value)
        case .double(let value): String(value)
        case .bool(let value): String(value)
        case .array(let value): "[" + value.map(\.stableKey).joined(separator: ",") + "]"
        case .object(let value): value.keys.sorted().map { "\($0)=\(value[$0]!.stableKey)" }.joined(separator: "&")
        case .null: "null"
        }
    }
}

struct AchievementRule: Codable, Hashable {
    let metric: String
    let `operator`: String
    let value: Int
    let filters: [String: CatalogJSONValue]?
    let window: String?
}

struct HiddenTitleRuleRecord: Codable, Identifiable {
    let id: String
    let type: String
    let category: String
    let title: String
    let condition: String
    let hint: String
    let rule: AchievementRule
}

struct MainTitleRuleRecord: Codable, Identifiable {
    let id: String
    let type: String
    let requiredRecipeCount: Int
    let quality: String
    let qualityKey: String
    let title: String
    let sortOrder: Int
}

struct TitleCatalogResource: Codable {
    let schemaVersion: Int
    let mainTitles: [MainTitleRuleRecord]
    let hiddenTitles: [HiddenTitleRuleRecord]
}

struct AchievementSnapshot {
    private(set) var counters: [String: Int] = [:]

    mutating func set(_ value: Int, metric: String, filters: [String: CatalogJSONValue]? = nil, window: String? = nil) {
        counters[AchievementRuleEngine.counterKey(metric: metric, filters: filters, window: window)] = value
    }

    mutating func increment(_ metric: String, by amount: Int = 1, filters: [String: CatalogJSONValue]? = nil, window: String? = nil) {
        let key = AchievementRuleEngine.counterKey(metric: metric, filters: filters, window: window)
        counters[key, default: 0] += amount
    }

    func value(for rule: AchievementRule) -> Int {
        let exact = AchievementRuleEngine.counterKey(metric: rule.metric, filters: rule.filters, window: rule.window)
        return counters[exact] ?? counters[rule.metric] ?? 0
    }
}

enum AchievementRuleEngine {
    static func loadCatalog(bundle: Bundle = .main) throws -> TitleCatalogResource {
        guard let url = bundle.url(forResource: "title-catalog", withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try JSONDecoder().decode(TitleCatalogResource.self, from: Data(contentsOf: url))
    }

    static func counterKey(metric: String, filters: [String: CatalogJSONValue]?, window: String?) -> String {
        let filterPart = (filters ?? [:]).keys.sorted().map { "\($0)=\(filters![$0]!.stableKey)" }.joined(separator: "&")
        return [metric, window ?? "", filterPart].joined(separator: "|")
    }

    static func isSatisfied(_ record: HiddenTitleRuleRecord, snapshot: AchievementSnapshot) -> Bool {
        let actual = snapshot.value(for: record.rule)
        switch record.rule.operator {
        case ">=": return actual >= record.rule.value
        case "==": return actual == record.rule.value
        default: return false
        }
    }

    static func newlySatisfied(catalog: TitleCatalogResource, snapshot: AchievementSnapshot, excluding unlocked: Set<String>) -> [HiddenTitleRuleRecord] {
        catalog.hiddenTitles.filter { !unlocked.contains($0.id) && isSatisfied($0, snapshot: snapshot) }
    }
}
