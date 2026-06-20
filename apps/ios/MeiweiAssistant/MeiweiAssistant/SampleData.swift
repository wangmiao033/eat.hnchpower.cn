import Foundation

enum SampleData {
    static var recipes: [Recipe] {
        SharedDataStore.shared.recipes.isEmpty ? fallbackRecipes : SharedDataStore.shared.recipes
    }

    // Bundle JSON 不可用时的离线回退样例，正式维护入口在 shared/data/recipes.json。
    static let fallbackRecipes: [Recipe] = [
        Recipe(
            id: "tomato-egg",
            name: "番茄炒蛋",
            subtitle: "酸甜平衡、软嫩多汁，适合工作日晚餐。",
            timeMinutes: 12,
            difficulty: "简单",
            tags: ["快手", "下饭", "清淡"],
            ingredients: [
                .init(id: "tomato", name: "番茄", amount: "2 个"),
                .init(id: "egg", name: "鸡蛋", amount: "3 个"),
                .init(id: "scallion", name: "香葱", amount: "1 根"),
                .init(id: "seasoning", name: "盐、糖、食用油", amount: "适量")
            ],
            steps: [
                .init(id: 1, text: "番茄切块；鸡蛋打散，加少许盐和一勺清水。", minutes: 3),
                .init(id: 2, text: "热锅下油，鸡蛋炒至刚凝固即盛出，保留嫩度。", minutes: 3),
                .init(id: 3, text: "番茄炒出汁，倒回鸡蛋，加入盐和少量糖快速翻匀。", minutes: 6)
            ],
            calories: 320,
            protein: 18,
            healthScore: 8.4,
            beverage: "清香乌龙茶",
            artwork: .tomatoEgg
        ),
        Recipe(
            id: "mushroom-chicken",
            name: "香菇滑鸡",
            subtitle: "鸡肉鲜嫩，香菇吸满汤汁，清淡但不寡。",
            timeMinutes: 25,
            difficulty: "中等",
            tags: ["清淡", "高蛋白", "蒸菜"],
            ingredients: [
                .init(id: "chicken", name: "鸡腿肉", amount: "300 克"),
                .init(id: "mushroom", name: "香菇", amount: "6 朵"),
                .init(id: "ginger", name: "姜", amount: "4 片")
            ],
            steps: [
                .init(id: 1, text: "鸡腿肉切块，用盐、生抽、淀粉腌 10 分钟。", minutes: 10),
                .init(id: 2, text: "香菇切片，与姜丝一起铺在鸡肉上。", minutes: 3),
                .init(id: 3, text: "水开后蒸 12 分钟，出锅撒葱。", minutes: 12)
            ],
            calories: 410,
            protein: 36,
            healthScore: 8.8,
            beverage: "桂花乌龙",
            artwork: .mushroomChicken
        ),
        Recipe(
            id: "shrimp-broccoli",
            name: "虾仁西兰花",
            subtitle: "清爽高蛋白，十几分钟完成。",
            timeMinutes: 16,
            difficulty: "简单",
            tags: ["减脂", "高蛋白", "清淡"],
            ingredients: [
                .init(id: "shrimp", name: "虾仁", amount: "200 克"),
                .init(id: "broccoli", name: "西兰花", amount: "半颗"),
                .init(id: "garlic", name: "蒜", amount: "2 瓣")
            ],
            steps: [
                .init(id: 1, text: "西兰花焯水；虾仁加料酒和盐腌 5 分钟。", minutes: 6),
                .init(id: 2, text: "蒜末爆香，下虾仁炒至变色。", minutes: 4),
                .init(id: 3, text: "倒入西兰花，加盐和黑胡椒翻匀。", minutes: 6)
            ],
            calories: 280,
            protein: 31,
            healthScore: 9.1,
            beverage: "柠檬苏打水",
            artwork: .shrimpBroccoli
        ),
        Recipe(
            id: "mapo-tofu",
            name: "麻婆豆腐",
            subtitle: "麻、辣、鲜、香，适合配一碗热米饭。",
            timeMinutes: 20,
            difficulty: "中等",
            tags: ["辣", "下饭", "热菜"],
            ingredients: [
                .init(id: "tofu", name: "嫩豆腐", amount: "1 盒"),
                .init(id: "mince", name: "肉末", amount: "100 克"),
                .init(id: "douban", name: "豆瓣酱", amount: "1 勺")
            ],
            steps: [
                .init(id: 1, text: "豆腐切块焯水，去豆腥并定型。", minutes: 5),
                .init(id: 2, text: "炒香肉末、豆瓣酱和蒜末。", minutes: 6),
                .init(id: 3, text: "加水烧开后下豆腐，勾薄芡收汁。", minutes: 9)
            ],
            calories: 460,
            protein: 24,
            healthScore: 7.5,
            beverage: "冰镇酸梅汤",
            artwork: .mapoTofu
        ),
        Recipe(
            id: "potato-beef",
            name: "土豆炖牛肉",
            subtitle: "浓郁软糯，适合周末慢慢炖一锅。",
            timeMinutes: 55,
            difficulty: "中等",
            tags: ["硬菜", "下饭", "热菜"],
            ingredients: [
                .init(id: "beef", name: "牛腩", amount: "500 克"),
                .init(id: "potato", name: "土豆", amount: "2 个"),
                .init(id: "carrot", name: "胡萝卜", amount: "1 根")
            ],
            steps: [
                .init(id: 1, text: "牛肉焯水，土豆和胡萝卜切块。", minutes: 10),
                .init(id: 2, text: "炒香葱姜和牛肉，加生抽、老抽与热水。", minutes: 10),
                .init(id: 3, text: "炖 35 分钟后下土豆，再炖至软糯。", minutes: 35)
            ],
            calories: 620,
            protein: 42,
            healthScore: 7.8,
            beverage: "焙火乌龙",
            artwork: .beefPotato
        )
    ]
}

enum DailyRecipeProvider {
    static func recipe(for date: Date = .now, recipes: [Recipe] = SampleData.recipes) -> Recipe {
        guard !recipes.isEmpty else { preconditionFailure("Recipe list cannot be empty") }
        let day = Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 0
        return recipes[abs(day) % recipes.count]
    }
}
