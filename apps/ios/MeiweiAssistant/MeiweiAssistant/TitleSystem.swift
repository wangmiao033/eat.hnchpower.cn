import SwiftUI

// MARK: - Definitions

enum TitleQuality: String, CaseIterable, Codable, Identifiable {
    case common = "普通"
    case fine = "精良"
    case rare = "稀有"
    case epic = "史诗"
    case legendary = "传说"
    case mythic = "神话"
    case supreme = "至尊"

    var id: String { rawValue }

    var primaryColor: Color {
        switch self {
        case .common: Color(red: 0.82, green: 0.82, blue: 0.80)
        case .fine: Color(red: 0.45, green: 0.66, blue: 1.00)
        case .rare: Color(red: 0.73, green: 0.53, blue: 1.00)
        case .epic: Color(red: 0.95, green: 0.64, blue: 0.36)
        case .legendary: Color(red: 1.00, green: 0.43, blue: 0.33)
        case .mythic: Color(red: 0.96, green: 0.84, blue: 0.43)
        case .supreme: Color(red: 0.95, green: 0.78, blue: 0.42)
        }
    }

    var surfaceColor: Color {
        switch self {
        case .common: Color(red: 0.95, green: 0.95, blue: 0.93)
        case .fine: Color(red: 0.92, green: 0.95, blue: 1.00)
        case .rare: Color(red: 0.96, green: 0.93, blue: 1.00)
        case .epic: Color(red: 1.00, green: 0.95, blue: 0.89)
        case .legendary: Color(red: 1.00, green: 0.94, blue: 0.91)
        case .mythic: Color(red: 1.00, green: 0.98, blue: 0.86)
        case .supreme: AppTheme.ink
        }
    }
}

struct MainTitleDefinition: Identifiable, Hashable, Codable {
    let id: String
    let requiredRecipeCount: Int
    let quality: TitleQuality
    let title: String
}

struct HiddenTitleDefinition: Identifiable, Hashable, Codable {
    let id: String
    let category: String
    let title: String
    let hint: String
    let description: String
    let symbol: String
}

struct TitleUnlockPresentation: Identifiable, Equatable {
    enum Kind: Equatable {
        case main(TitleQuality)
        case hidden
        case completion
    }

    let id = UUID()
    let kind: Kind
    let kicker: String
    let title: String
    let message: String
    let nextMessage: String?
}

// MARK: - Catalog

enum TitleCatalog {
    static var main: [MainTitleDefinition] {
        SharedDataStore.shared.mainTitles ?? fallbackMain
    }

    static var hidden: [HiddenTitleDefinition] {
        SharedDataStore.shared.hiddenTitles ?? fallbackHidden
    }

    private static let fallbackMain: [MainTitleDefinition] = [
        .init(id: "main_001", requiredRecipeCount: 1, quality: .common, title: "小厨师"),
        .init(id: "main_002", requiredRecipeCount: 2, quality: .common, title: "厨房新手"),
        .init(id: "main_003", requiredRecipeCount: 3, quality: .common, title: "锅铲学徒"),
        .init(id: "main_004", requiredRecipeCount: 5, quality: .common, title: "烟火小将"),
        .init(id: "main_005", requiredRecipeCount: 8, quality: .fine, title: "香气捕手"),
        .init(id: "main_006", requiredRecipeCount: 10, quality: .fine, title: "家常料理师"),
        .init(id: "main_007", requiredRecipeCount: 15, quality: .fine, title: "调味达人"),
        .init(id: "main_008", requiredRecipeCount: 20, quality: .fine, title: "风味探索家"),
        .init(id: "main_009", requiredRecipeCount: 30, quality: .rare, title: "黄金锅铲手"),
        .init(id: "main_010", requiredRecipeCount: 40, quality: .rare, title: "厨房掌勺人"),
        .init(id: "main_011", requiredRecipeCount: 50, quality: .rare, title: "百味料理师"),
        .init(id: "main_012", requiredRecipeCount: 60, quality: .rare, title: "私房大厨"),
        .init(id: "main_013", requiredRecipeCount: 80, quality: .epic, title: "味觉魔法师"),
        .init(id: "main_014", requiredRecipeCount: 100, quality: .epic, title: "星级主厨"),
        .init(id: "main_015", requiredRecipeCount: 120, quality: .epic, title: "美食鉴赏家"),
        .init(id: "main_016", requiredRecipeCount: 150, quality: .epic, title: "传说厨神"),
        .init(id: "main_017", requiredRecipeCount: 200, quality: .legendary, title: "食神降临"),
        .init(id: "main_018", requiredRecipeCount: 300, quality: .legendary, title: "万味宗师"),
        .init(id: "main_019", requiredRecipeCount: 500, quality: .legendary, title: "御膳总管"),
        .init(id: "main_020", requiredRecipeCount: 800, quality: .legendary, title: "宫廷御厨"),
        .init(id: "main_021", requiredRecipeCount: 1_000, quality: .mythic, title: "天下第一厨"),
        .init(id: "main_022", requiredRecipeCount: 1_500, quality: .mythic, title: "炉火至尊"),
        .init(id: "main_023", requiredRecipeCount: 2_000, quality: .mythic, title: "人间烟火之王"),
        .init(id: "main_024", requiredRecipeCount: 3_000, quality: .mythic, title: "饕餮圣者"),
        .init(id: "main_025", requiredRecipeCount: 5_000, quality: .supreme, title: "至尊食神")
    ]

    // Full catalog: 74 original hidden titles plus “天机开锅”.
    private static let fallbackHidden: [HiddenTitleDefinition] = [
.init(
    id: "hidden_streak_003",
    category: "坚持类",
    title: "烟火初燃",
    hint: "灶火连续亮了三天。",
    description: "解锁条件：连续做饭 3 天。",
    symbol: "flame.fill"
),
.init(
    id: "hidden_streak_007",
    category: "坚持类",
    title: "坚持掌勺人",
    hint: "一周的晚餐，都有你的烟火气。",
    description: "解锁条件：连续做饭 7 天。",
    symbol: "flame.fill"
),
.init(
    id: "hidden_streak_015",
    category: "坚持类",
    title: "厨房修行者",
    hint: "半个月的重复，正在变成熟练。",
    description: "解锁条件：连续做饭 15 天。",
    symbol: "flame.fill"
),
.init(
    id: "hidden_streak_030",
    category: "坚持类",
    title: "铁锅战神",
    hint: "整整一个月，锅铲没有冷下来。",
    description: "解锁条件：连续做饭 30 天。",
    symbol: "flame.fill"
),
.init(
    id: "hidden_streak_100",
    category: "坚持类",
    title: "人间烟火守护者",
    hint: "一百天的烟火，需要真正的坚持。",
    description: "解锁条件：连续做饭 100 天。",
    symbol: "flame.fill"
),
.init(
    id: "hidden_streak_365",
    category: "坚持类",
    title: "烟火仙人",
    hint: "四季轮转，灶台始终有人守着。",
    description: "解锁条件：连续做饭 365 天。",
    symbol: "flame.fill"
),
.init(
    id: "hidden_time_late_001",
    category: "时间类",
    title: "深夜食堂新人",
    hint: "夜深了，厨房还亮着灯……",
    description: "解锁条件：第一次深夜 22:00 后做菜。",
    symbol: "clock.fill"
),
.init(
    id: "hidden_time_late_010",
    category: "时间类",
    title: "深夜食堂老板",
    hint: "夜色渐深，你的食堂却越来越熟练。",
    description: "解锁条件：深夜做菜 10 次。",
    symbol: "clock.fill"
),
.init(
    id: "hidden_time_late_100",
    category: "时间类",
    title: "深夜食神",
    hint: "一百个深夜，都是你的营业时间。",
    description: "解锁条件：深夜做菜 100 次。",
    symbol: "clock.fill"
),
.init(
    id: "hidden_time_early_005",
    category: "时间类",
    title: "清晨料理师",
    hint: "太阳还没起床，厨房已经有了香气。",
    description: "解锁条件：早上 7:00 前做菜 5 次。",
    symbol: "clock.fill"
),
.init(
    id: "hidden_time_weekend_020",
    category: "时间类",
    title: "周末厨房王",
    hint: "周末不只休息，也适合认真开火。",
    description: "解锁条件：周末做菜 20 次。",
    symbol: "clock.fill"
),
.init(
    id: "hidden_burst_day_003",
    category: "爆发类",
    title: "今日爆炒王",
    hint: "今天的灶台，比平时忙得多。",
    description: "解锁条件：一天完成 3 道菜。",
    symbol: "bolt.fill"
),
.init(
    id: "hidden_burst_day_005",
    category: "爆发类",
    title: "厨房超负荷",
    hint: "火力全开，厨房已进入高负荷模式。",
    description: "解锁条件：一天完成 5 道菜。",
    symbol: "bolt.fill"
),
.init(
    id: "hidden_burst_week_010",
    category: "爆发类",
    title: "爆肝料理人",
    hint: "这一周，你几乎把厨房当成了主场。",
    description: "解锁条件：一周完成 10 道菜。",
    symbol: "bolt.fill"
),
.init(
    id: "hidden_dish_vegetable_010",
    category: "菜品类",
    title: "绿色料理师",
    hint: "绿色正在成为你的拿手风味。",
    description: "解锁条件：完成 10 道素菜。",
    symbol: "fork.knife"
),
.init(
    id: "hidden_dish_vegetable_030",
    category: "菜品类",
    title: "蔬菜守护神",
    hint: "一片菜叶，也能被你做出层次。",
    description: "解锁条件：完成 30 道素菜。",
    symbol: "fork.knife"
),
.init(
    id: "hidden_dish_meat_010",
    category: "菜品类",
    title: "肉食掌门人",
    hint: "对肉香的理解，开始有了门派。",
    description: "解锁条件：完成 10 道肉菜。",
    symbol: "fork.knife"
),
.init(
    id: "hidden_dish_meat_030",
    category: "菜品类",
    title: "烤肉霸主",
    hint: "火候与肉香，已经被你牢牢掌握。",
    description: "解锁条件：完成 30 道肉菜。",
    symbol: "fork.knife"
),
.init(
    id: "hidden_dish_spicy_010",
    category: "菜品类",
    title: "辣椒挑战者",
    hint: "舌尖开始接受更热烈的挑战。",
    description: "解锁条件：完成 10 道辣菜。",
    symbol: "fork.knife"
),
.init(
    id: "hidden_dish_spicy_030",
    category: "菜品类",
    title: "辣王降临",
    hint: "辣度不再是阻碍，而是你的武器。",
    description: "解锁条件：完成 30 道辣菜。",
    symbol: "fork.knife"
),
.init(
    id: "hidden_dish_dessert_010",
    category: "菜品类",
    title: "甜蜜小厨",
    hint: "一点糖，让厨房变得柔软。",
    description: "解锁条件：完成 10 道甜品。",
    symbol: "fork.knife"
),
.init(
    id: "hidden_dish_dessert_030",
    category: "菜品类",
    title: "甜品魔导师",
    hint: "甜度、温度与口感都听你的指挥。",
    description: "解锁条件：完成 30 道甜品。",
    symbol: "fork.knife"
),
.init(
    id: "hidden_dish_soup_010",
    category: "菜品类",
    title: "一碗暖心人",
    hint: "一碗热汤，足以照顾一顿饭。",
    description: "解锁条件：完成 10 道汤类。",
    symbol: "fork.knife"
),
.init(
    id: "hidden_dish_soup_030",
    category: "菜品类",
    title: "汤王在世",
    hint: "慢火熬出的温度，已经成为你的专长。",
    description: "解锁条件：完成 30 道汤类。",
    symbol: "fork.knife"
),
.init(
    id: "hidden_skill_retry_001",
    category: "失败与熟练类",
    title: "不服输的厨师",
    hint: "一次失手，不代表今晚没有好饭。",
    description: "解锁条件：第一次做失败后重新完成。",
    symbol: "arrow.counterclockwise"
),
.init(
    id: "hidden_skill_fail_010",
    category: "失败与熟练类",
    title: "炸锅也不退",
    hint: "锅会糊，心态不能糊。",
    description: "解锁条件：失败 10 次后仍继续完成。",
    symbol: "arrow.counterclockwise"
),
.init(
    id: "hidden_skill_repeat_003",
    category: "失败与熟练类",
    title: "熟练掌勺人",
    hint: "重复三次，手感开始形成。",
    description: "解锁条件：同一道菜做 3 次。",
    symbol: "arrow.counterclockwise"
),
.init(
    id: "hidden_skill_repeat_010",
    category: "失败与熟练类",
    title: "这道菜我封神",
    hint: "这道菜，已经成了你的个人招牌。",
    description: "解锁条件：同一道菜做 10 次。",
    symbol: "arrow.counterclockwise"
),
.init(
    id: "hidden_social_favorite_050",
    category: "收藏与社交类",
    title: "菜谱收藏家",
    hint: "好菜谱值得留在自己的书架。",
    description: "解锁条件：收藏 50 个菜谱。",
    symbol: "heart.fill"
),
.init(
    id: "hidden_social_favorite_100",
    category: "收藏与社交类",
    title: "秘籍收集者",
    hint: "你的收藏夹，正在变成一本厨房秘籍。",
    description: "解锁条件：收藏 100 个菜谱。",
    symbol: "heart.fill"
),
.init(
    id: "hidden_social_share_010",
    category: "收藏与社交类",
    title: "美食传播官",
    hint: "把好味道分享出去，也是一种投喂。",
    description: "解锁条件：分享菜谱 10 次。",
    symbol: "heart.fill"
),
.init(
    id: "hidden_social_share_100",
    category: "收藏与社交类",
    title: "美味传教士",
    hint: "一百次分享，让更多人走进厨房。",
    description: "解锁条件：分享菜谱 100 次。",
    symbol: "heart.fill"
),
.init(
    id: "hidden_social_like_0010",
    category: "收藏与社交类",
    title: "被认可的厨师",
    hint: "有人认真看见了你的成品。",
    description: "解锁条件：被别人点赞 10 次。",
    symbol: "heart.fill"
),
.init(
    id: "hidden_social_like_0100",
    category: "收藏与社交类",
    title: "人气主厨",
    hint: "你的菜，正在被越来越多人记住。",
    description: "解锁条件：被别人点赞 100 次。",
    symbol: "heart.fill"
),
.init(
    id: "hidden_social_like_1000",
    category: "收藏与社交类",
    title: "人间饭王",
    hint: "一千次认可，足以坐稳饭桌中心。",
    description: "解锁条件：被别人点赞 1000 次。",
    symbol: "heart.fill"
),
.init(
    id: "hidden_random_001",
    category: "随机互动类",
    title: "命运开锅",
    hint: "把今晚的菜单交给一点运气。",
    description: "解锁条件：用骰子随机出菜 1 次。",
    symbol: "die.face.5.fill"
),
.init(
    id: "hidden_random_010",
    category: "随机互动类",
    title: "天选掌勺人",
    hint: "十次随机之后，命运也熟悉了你的口味。",
    description: "解锁条件：用骰子随机出菜 10 次。",
    symbol: "die.face.5.fill"
),
.init(
    id: "hidden_random_streak_003",
    category: "随机互动类",
    title: "欧皇厨师",
    hint: "有时，骰子也会偏爱同一种味道。",
    description: "解锁条件：骰子连续 3 次摇到同类菜。",
    symbol: "die.face.5.fill"
),
.init(
    id: "hidden_random_reroll_010",
    category: "随机互动类",
    title: "选择困难大师",
    hint: "答案已经出现，但你决定再想一想。",
    description: "解锁条件：骰子摇到不想吃又换 10 次。",
    symbol: "die.face.5.fill"
),
.init(
    id: "hidden_random_complete_100",
    category: "随机互动类",
    title: "命运料理大师",
    hint: "一百次接受随机，也是一种坚定。",
    description: "解锁条件：完成 100 道随机推荐菜。",
    symbol: "die.face.5.fill"
),
.init(
    id: "hidden_recommend_first",
    category: "推荐类",
    title: "今日吃什么探索者",
    hint: "第一次，把“今天吃什么”交给美味助手。",
    description: "解锁条件：第一次让 App 推荐今日食谱。",
    symbol: "sparkles"
),
.init(
    id: "hidden_recommend_streak_007",
    category: "推荐类",
    title: "听劝料理人",
    hint: "连续七天，推荐都被你认真端上桌。",
    description: "解锁条件：连续 7 天接受每日推荐。",
    symbol: "sparkles"
),
.init(
    id: "hidden_explore_new_001",
    category: "探索类",
    title: "新味觉冒险家",
    hint: "陌生的味道，值得一次大胆下锅。",
    description: "解锁条件：做完一道从没吃过的菜。",
    symbol: "safari.fill"
),
.init(
    id: "hidden_explore_cuisine_010",
    category: "探索类",
    title: "百味旅行家",
    hint: "不出厨房，也能走过十种风味。",
    description: "解锁条件：完成 10 个不同菜系。",
    symbol: "safari.fill"
),
.init(
    id: "hidden_explore_all_cuisine_010",
    category: "探索类",
    title: "全菜系制霸者",
    hint: "每一种菜系，都留下了你的火候。",
    description: "解锁条件：所有菜系各完成 10 道。",
    symbol: "safari.fill"
),
.init(
    id: "hidden_explore_all_categories",
    category: "探索类",
    title: "厨房全能王",
    hint: "厨房里的每一种任务，你都做过。",
    description: "解锁条件：所有分类都完成过。",
    symbol: "safari.fill"
),
.init(
    id: "hidden_cuisine_sichuan_010",
    category: "菜系类",
    title: "川味掌门",
    hint: "麻辣鲜香，已经有了自己的章法。",
    description: "解锁条件：完成川菜 10 道。",
    symbol: "globe.asia.australia.fill"
),
.init(
    id: "hidden_cuisine_cantonese_010",
    category: "菜系类",
    title: "粤味行家",
    hint: "清鲜与火候，你开始懂得取舍。",
    description: "解锁条件：完成粤菜 10 道。",
    symbol: "globe.asia.australia.fill"
),
.init(
    id: "hidden_cuisine_hunan_010",
    category: "菜系类",
    title: "湘辣高手",
    hint: "香辣浓烈，也能被你做得有层次。",
    description: "解锁条件：完成湘菜 10 道。",
    symbol: "globe.asia.australia.fill"
),
.init(
    id: "hidden_cuisine_northeast_010",
    category: "菜系类",
    title: "铁锅炖大师",
    hint: "大锅、慢炖和热气，是你的主场。",
    description: "解锁条件：完成东北菜 10 道。",
    symbol: "globe.asia.australia.fill"
),
.init(
    id: "hidden_record_during_020",
    category: "记录类",
    title: "美食摄影师",
    hint: "镜头开始记住每一次下锅。",
    description: "解锁条件：做饭同时记录照片 20 次。",
    symbol: "camera.fill"
),
.init(
    id: "hidden_record_finished_050",
    category: "记录类",
    title: "朋友圈投喂官",
    hint: "五十张成品图，足够让朋友经常饿。",
    description: "解锁条件：上传成品图 50 次。",
    symbol: "camera.fill"
),
.init(
    id: "hidden_record_finished_365",
    category: "记录类",
    title: "美食记录官",
    hint: "三百六十五张照片，组成了一整年的烟火。",
    description: "解锁条件：上传 365 张成品图。",
    symbol: "camera.fill"
),
.init(
    id: "hidden_life_no_delivery_007",
    category: "生活类",
    title: "外卖戒断者",
    hint: "一周没有外卖袋，只有厨房的热气。",
    description: "解锁条件：连续 7 天不点外卖。",
    symbol: "house.fill"
),
.init(
    id: "hidden_life_no_delivery_030",
    category: "生活类",
    title: "自炊王者",
    hint: "一个月的三餐，都由自己认真照顾。",
    description: "解锁条件：连续 30 天不点外卖。",
    symbol: "house.fill"
),
.init(
    id: "hidden_feed_001",
    category: "投喂类",
    title: "投喂新人",
    hint: "第一次把亲手做的饭端给别人。",
    description: "解锁条件：第一次做饭给别人吃。",
    symbol: "person.2.fill"
),
.init(
    id: "hidden_feed_010",
    category: "投喂类",
    title: "家庭投喂官",
    hint: "十次投喂，饭桌开始习惯你的存在。",
    description: "解锁条件：给别人做饭 10 次。",
    symbol: "person.2.fill"
),
.init(
    id: "hidden_feed_050",
    category: "投喂类",
    title: "饭桌核心人物",
    hint: "五十次开饭，你已经成了饭桌中心。",
    description: "解锁条件：给别人做饭 50 次。",
    symbol: "person.2.fill"
),
.init(
    id: "hidden_festival_first",
    category: "节日类",
    title: "节日掌勺人",
    hint: "节日的仪式感，从厨房开始。",
    description: "解锁条件：第一次做节日菜。",
    symbol: "party.popper.fill"
),
.init(
    id: "hidden_festival_spring_festival",
    category: "节日类",
    title: "年夜饭守护者",
    hint: "团圆夜的热菜，由你守住。",
    description: "解锁条件：春节做菜。",
    symbol: "party.popper.fill"
),
.init(
    id: "hidden_festival_dragon_boat",
    category: "节日类",
    title: "粽香料理人",
    hint: "粽叶与蒸汽，都是端午的味道。",
    description: "解锁条件：端午做菜。",
    symbol: "party.popper.fill"
),
.init(
    id: "hidden_festival_mid_autumn",
    category: "节日类",
    title: "月光掌勺人",
    hint: "月亮升起时，厨房也亮着。",
    description: "解锁条件：中秋做菜。",
    symbol: "party.popper.fill"
),
.init(
    id: "hidden_festival_christmas",
    category: "节日类",
    title: "圣诞厨房官",
    hint: "冬夜的节日香气，从烤箱和锅里来。",
    description: "解锁条件：圣诞做菜。",
    symbol: "party.popper.fill"
),
.init(
    id: "hidden_festival_birthday",
    category: "节日类",
    title: "生日主厨",
    hint: "今天的主厨，也值得被认真庆祝。",
    description: "解锁条件：生日当天做菜。",
    symbol: "party.popper.fill"
),
.init(
    id: "hidden_rare_four_seasons",
    category: "稀有隐藏类",
    title: "四季掌勺人",
    hint: "十二个月，都有一道菜留下痕迹。",
    description: "解锁条件：一年内每个月都做菜。",
    symbol: "crown.fill"
),
.init(
    id: "hidden_rare_five_flavors",
    category: "稀有隐藏类",
    title: "五味掌控者",
    hint: "酸甜苦辣咸，五味已经集齐。",
    description: "解锁条件：做过酸甜苦辣咸五类菜。",
    symbol: "crown.fill"
),
.init(
    id: "hidden_rare_app_365",
    category: "稀有隐藏类",
    title: "老灶台守护者",
    hint: "陪伴一年，灶台也成了老朋友。",
    description: "解锁条件：使用 App 满 365 天。",
    symbol: "crown.fill"
),
.init(
    id: "hidden_number_0520",
    category: "特殊数字类",
    title: "爱的投喂官",
    hint: "五百二十道菜，是很长的一句“好好吃饭”。",
    description: "解锁条件：完成 520 道菜。",
    symbol: "number.circle.fill"
),
.init(
    id: "hidden_number_0666",
    category: "特殊数字类",
    title: "厨房欧皇",
    hint: "这个数字，连锅铲都觉得顺。",
    description: "解锁条件：完成 666 道菜。",
    symbol: "number.circle.fill"
),
.init(
    id: "hidden_number_0888",
    category: "特殊数字类",
    title: "发财掌勺人",
    hint: "八方来味，好运也跟着开锅。",
    description: "解锁条件：完成 888 道菜。",
    symbol: "number.circle.fill"
),
.init(
    id: "hidden_number_0999",
    category: "特殊数字类",
    title: "长长久久食神",
    hint: "九百九十九道菜，把烟火做得长久。",
    description: "解锁条件：完成 999 道菜。",
    symbol: "number.circle.fill"
),
.init(
    id: "hidden_number_1000",
    category: "特殊数字类",
    title: "万味归宗",
    hint: "第一千道菜，是一次重要的归途。",
    description: "解锁条件：完成 1000 道菜。",
    symbol: "number.circle.fill"
),
.init(
    id: "hidden_number_1314",
    category: "特殊数字类",
    title: "一生一世投喂官",
    hint: "一千三百一十四次，把照顾写进三餐。",
    description: "解锁条件：完成 1314 道菜。",
    symbol: "number.circle.fill"
),
.init(
    id: "hidden_number_2026",
    category: "特殊数字类",
    title: "年度食神",
    hint: "第二千零二十六道菜，值得一枚年份纪念章。",
    description: "解锁条件：完成 2026 道菜。",
    symbol: "number.circle.fill"
),
.init(
    id: "hidden_mystic_first_001",
    category: "玄学互动类",
    title: "天机开锅",
    hint: "让一点玄学替今晚做决定。",
    description: "解锁条件：第一次通过玄学厨房选出菜谱。",
    symbol: "moon.stars.fill"
)
    ]
}

// MARK: - Runtime state

private struct GrowthStoreState: Codable {
    var recipeCompletionCount: Int = 0
    var cookingStreakDays: Int = 0
    var diceRollCount: Int = 0
    var mysticCastCount: Int = 0
    var partyAssignmentCount: Int = 0
    var unlockedHiddenTitleIDs: [String] = []
    var displayHiddenTitleID: String?
    var lastCompletionDayKey: String?
}

@MainActor
final class GrowthStore: ObservableObject {
    @Published private(set) var recipeCompletionCount = 0
    @Published private(set) var cookingStreakDays = 0
    @Published private(set) var diceRollCount = 0
    @Published private(set) var partyAssignmentCount = 0
    @Published private(set) var mysticCastCount = 0
    @Published private(set) var unlockedHiddenTitleIDs: Set<String> = []
    @Published var displayHiddenTitleID: String?
    @Published private(set) var activeUnlock: TitleUnlockPresentation?

    private var unlockQueue: [TitleUnlockPresentation] = []
    private var lastCompletionDayKey: String?
    private let storage: UserDefaults
    private let storageKey = "meiwei.growthStore.v1"

    init(storage: UserDefaults = .standard) {
        self.storage = storage
        loadState()
        unlockSatisfiedHiddenTitles(showPresentation: false)
    }

    var currentMainTitle: MainTitleDefinition {
        let titles = TitleCatalog.main
        return titles.last(where: { recipeCompletionCount >= $0.requiredRecipeCount }) ?? titles[0]
    }

    var nextMainTitle: MainTitleDefinition? {
        TitleCatalog.main.first(where: { recipeCompletionCount < $0.requiredRecipeCount })
    }

    var mainProgress: Double {
        guard let nextMainTitle else { return 1 }
        let lower = TitleCatalog.main.last(where: { recipeCompletionCount >= $0.requiredRecipeCount })?.requiredRecipeCount ?? 0
        let upper = nextMainTitle.requiredRecipeCount
        guard upper > lower else { return 1 }
        return min(1, max(0, Double(recipeCompletionCount - lower) / Double(upper - lower)))
    }

    var displayedHiddenTitle: HiddenTitleDefinition? {
        guard let displayHiddenTitleID else { return nil }
        return TitleCatalog.hidden.first(where: { $0.id == displayHiddenTitleID })
    }

    func visibleMainTitles(radius: Int = 3) -> [MainTitleDefinition] {
        guard let index = TitleCatalog.main.firstIndex(of: currentMainTitle) else { return [] }
        let start = max(0, index - 1)
        let end = min(TitleCatalog.main.count, index + radius + 1)
        return Array(TitleCatalog.main[start..<end])
    }

    func recordRecipeCompletion() {
        let previousTitle = currentMainTitle
        recipeCompletionCount += 1
        recordCookingDay()
        let newTitle = currentMainTitle

        if previousTitle.id != newTitle.id {
            let nextText = nextMainTitle.map {
                "再完成 \($0.requiredRecipeCount - recipeCompletionCount) 道菜，即可解锁：\($0.quality.rawValue) · \($0.title)"
            }
            enqueue(
                .init(
                    kind: .main(newTitle.quality),
                    kicker: "称号升级",
                    title: "\(newTitle.quality.rawValue) · \(newTitle.title)",
                    message: "恭喜你完成第 \(recipeCompletionCount) 道菜，晋升为新的主线称号。",
                    nextMessage: nextText
                )
            )
        } else {
            enqueue(
                .init(
                    kind: .completion,
                    kicker: "已记录这一餐",
                    title: "料理完成",
                    message: "第 \(recipeCompletionCount) 道菜已计入成长。",
                    nextMessage: nextMainTitle.map { "距离 \($0.title) 还差 \($0.requiredRecipeCount - recipeCompletionCount) 道菜。" }
                )
            )
        }

        unlockSatisfiedHiddenTitles()
        saveState()
    }

    func recordDiceRoll() {
        diceRollCount += 1
        unlockSatisfiedHiddenTitles()
        saveState()
    }

    func recordMysticCast() {
        mysticCastCount += 1
        unlockSatisfiedHiddenTitles()
        saveState()
    }

    func recordPartyAssignment() {
        partyAssignmentCount += 1
        unlockSatisfiedHiddenTitles()
        saveState()
    }

    func unlockHiddenTitle(id: String) {
        unlockHiddenTitle(id: id, showPresentation: true)
    }

    private func unlockHiddenTitle(id: String, showPresentation: Bool) {
        guard !unlockedHiddenTitleIDs.contains(id),
              let definition = TitleCatalog.hidden.first(where: { $0.id == id }) else { return }

        unlockedHiddenTitleIDs.insert(id)
        if displayHiddenTitleID == nil {
            displayHiddenTitleID = id
        }

        guard showPresentation else {
            saveState()
            return
        }

        enqueue(
            .init(
                kind: .hidden,
                kicker: "隐藏称号解锁",
                title: definition.title,
                message: definition.description,
                nextMessage: "已加入称号殿堂，可随时设为展示称号。"
            )
        )
        saveState()
    }

    func equipHiddenTitle(id: String) {
        guard unlockedHiddenTitleIDs.contains(id) else { return }
        displayHiddenTitleID = id
        saveState()
    }

    func dismissActiveUnlock() {
        activeUnlock = nil
        showNextUnlockIfNeeded()
    }

    private func enqueue(_ presentation: TitleUnlockPresentation) {
        unlockQueue.append(presentation)
        showNextUnlockIfNeeded()
    }

    private func showNextUnlockIfNeeded() {
        guard activeUnlock == nil, !unlockQueue.isEmpty else { return }
        activeUnlock = unlockQueue.removeFirst()
    }

    private func unlockSatisfiedHiddenTitles(showPresentation: Bool = true) {
        guard let catalog = SharedDataStore.shared.titleRules else { return }

        var snapshot = AchievementSnapshot()
        snapshot.set(recipeCompletionCount, metric: "recipeCompletionCount")
        snapshot.set(cookingStreakDays, metric: "cookingStreakDays")
        snapshot.set(diceRollCount, metric: "diceRollCount")
        snapshot.set(mysticCastCount, metric: "mysticCastCount")
        snapshot.set(partyAssignmentCount, metric: "partyAssignmentCount")

        let matches = AchievementRuleEngine.newlySatisfied(
            catalog: catalog,
            snapshot: snapshot,
            excluding: unlockedHiddenTitleIDs
        )
        for record in matches {
            unlockHiddenTitle(id: record.id, showPresentation: showPresentation)
        }
    }

    private func recordCookingDay(date: Date = .now) {
        let today = Self.dayKey(for: date)
        guard lastCompletionDayKey != today else { return }

        let yesterday = Self.dayKey(for: Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date)
        cookingStreakDays = lastCompletionDayKey == yesterday ? cookingStreakDays + 1 : 1
        lastCompletionDayKey = today
    }

    private func loadState() {
        guard let data = storage.data(forKey: storageKey),
              let state = try? JSONDecoder().decode(GrowthStoreState.self, from: data) else { return }

        recipeCompletionCount = state.recipeCompletionCount
        cookingStreakDays = state.cookingStreakDays
        diceRollCount = state.diceRollCount
        mysticCastCount = state.mysticCastCount
        partyAssignmentCount = state.partyAssignmentCount
        unlockedHiddenTitleIDs = Set(state.unlockedHiddenTitleIDs)
        displayHiddenTitleID = state.displayHiddenTitleID
        lastCompletionDayKey = state.lastCompletionDayKey
    }

    private func saveState() {
        let state = GrowthStoreState(
            recipeCompletionCount: recipeCompletionCount,
            cookingStreakDays: cookingStreakDays,
            diceRollCount: diceRollCount,
            mysticCastCount: mysticCastCount,
            partyAssignmentCount: partyAssignmentCount,
            unlockedHiddenTitleIDs: Array(unlockedHiddenTitleIDs).sorted(),
            displayHiddenTitleID: displayHiddenTitleID,
            lastCompletionDayKey: lastCompletionDayKey
        )

        guard let data = try? JSONEncoder().encode(state) else { return }
        storage.set(data, forKey: storageKey)
    }

    private static func dayKey(for date: Date) -> String {
        let start = Calendar.current.startOfDay(for: date)
        let components = Calendar.current.dateComponents([.year, .month, .day], from: start)
        return "\(components.year ?? 0)-\(components.month ?? 0)-\(components.day ?? 0)"
    }
}
