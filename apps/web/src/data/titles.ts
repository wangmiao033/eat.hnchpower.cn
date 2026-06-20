export type TitleQualityKey = 'common' | 'fine' | 'rare' | 'epic' | 'legendary' | 'mythic' | 'supreme'

export interface TitleRule {
    metric: string
    operator: '>=' | '<=' | '==' | '!=' | 'includes'
    value: number | string | boolean
    note?: string
}

export interface MainTitle {
    id: string
    type: 'main'
    requiredRecipeCount: number
    quality: string
    qualityKey: TitleQualityKey
    title: string
    sortOrder: number
}

export interface HiddenTitle {
    id: string
    type: 'hidden'
    category: string
    title: string
    condition: string
    hint: string
    rule?: TitleRule
}

export interface QualityDefinition {
    name: string
    primary: string
    surface: string
    secondary?: string
}

export const qualityPalette = {
    "common": {
        "name": "普通",
        "primary": "#D8D8D4",
        "surface": "#F4F4F1"
    },
    "fine": {
        "name": "精良",
        "primary": "#72A9FF",
        "surface": "#EAF2FF"
    },
    "rare": {
        "name": "稀有",
        "primary": "#B987FF",
        "surface": "#F2EAFE"
    },
    "epic": {
        "name": "史诗",
        "primary": "#F3A35D",
        "surface": "#FFF0E2"
    },
    "legendary": {
        "name": "传说",
        "primary": "#FF6D55",
        "secondary": "#E4B45B",
        "surface": "#FFF0E9"
    },
    "mythic": {
        "name": "神话",
        "primary": "#F5D66D",
        "secondary": "#89B8FF",
        "surface": "#FFF8D7"
    },
    "supreme": {
        "name": "至尊",
        "primary": "#F3C86B",
        "secondary": "#171714",
        "surface": "#171714"
    }
} as Record<TitleQualityKey, QualityDefinition>

export const mainTitles = [
    {
        "id": "main_001",
        "type": "main",
        "requiredRecipeCount": 1,
        "quality": "普通",
        "qualityKey": "common",
        "title": "小厨师",
        "sortOrder": 1
    },
    {
        "id": "main_002",
        "type": "main",
        "requiredRecipeCount": 2,
        "quality": "普通",
        "qualityKey": "common",
        "title": "厨房新手",
        "sortOrder": 2
    },
    {
        "id": "main_003",
        "type": "main",
        "requiredRecipeCount": 3,
        "quality": "普通",
        "qualityKey": "common",
        "title": "锅铲学徒",
        "sortOrder": 3
    },
    {
        "id": "main_004",
        "type": "main",
        "requiredRecipeCount": 5,
        "quality": "普通",
        "qualityKey": "common",
        "title": "烟火小将",
        "sortOrder": 4
    },
    {
        "id": "main_005",
        "type": "main",
        "requiredRecipeCount": 8,
        "quality": "精良",
        "qualityKey": "fine",
        "title": "香气捕手",
        "sortOrder": 5
    },
    {
        "id": "main_006",
        "type": "main",
        "requiredRecipeCount": 10,
        "quality": "精良",
        "qualityKey": "fine",
        "title": "家常料理师",
        "sortOrder": 6
    },
    {
        "id": "main_007",
        "type": "main",
        "requiredRecipeCount": 15,
        "quality": "精良",
        "qualityKey": "fine",
        "title": "调味达人",
        "sortOrder": 7
    },
    {
        "id": "main_008",
        "type": "main",
        "requiredRecipeCount": 20,
        "quality": "精良",
        "qualityKey": "fine",
        "title": "风味探索家",
        "sortOrder": 8
    },
    {
        "id": "main_009",
        "type": "main",
        "requiredRecipeCount": 30,
        "quality": "稀有",
        "qualityKey": "rare",
        "title": "黄金锅铲手",
        "sortOrder": 9
    },
    {
        "id": "main_010",
        "type": "main",
        "requiredRecipeCount": 40,
        "quality": "稀有",
        "qualityKey": "rare",
        "title": "厨房掌勺人",
        "sortOrder": 10
    },
    {
        "id": "main_011",
        "type": "main",
        "requiredRecipeCount": 50,
        "quality": "稀有",
        "qualityKey": "rare",
        "title": "百味料理师",
        "sortOrder": 11
    },
    {
        "id": "main_012",
        "type": "main",
        "requiredRecipeCount": 60,
        "quality": "稀有",
        "qualityKey": "rare",
        "title": "私房大厨",
        "sortOrder": 12
    },
    {
        "id": "main_013",
        "type": "main",
        "requiredRecipeCount": 80,
        "quality": "史诗",
        "qualityKey": "epic",
        "title": "味觉魔法师",
        "sortOrder": 13
    },
    {
        "id": "main_014",
        "type": "main",
        "requiredRecipeCount": 100,
        "quality": "史诗",
        "qualityKey": "epic",
        "title": "星级主厨",
        "sortOrder": 14
    },
    {
        "id": "main_015",
        "type": "main",
        "requiredRecipeCount": 120,
        "quality": "史诗",
        "qualityKey": "epic",
        "title": "美食鉴赏家",
        "sortOrder": 15
    },
    {
        "id": "main_016",
        "type": "main",
        "requiredRecipeCount": 150,
        "quality": "史诗",
        "qualityKey": "epic",
        "title": "传说厨神",
        "sortOrder": 16
    },
    {
        "id": "main_017",
        "type": "main",
        "requiredRecipeCount": 200,
        "quality": "传说",
        "qualityKey": "legendary",
        "title": "食神降临",
        "sortOrder": 17
    },
    {
        "id": "main_018",
        "type": "main",
        "requiredRecipeCount": 300,
        "quality": "传说",
        "qualityKey": "legendary",
        "title": "万味宗师",
        "sortOrder": 18
    },
    {
        "id": "main_019",
        "type": "main",
        "requiredRecipeCount": 500,
        "quality": "传说",
        "qualityKey": "legendary",
        "title": "御膳总管",
        "sortOrder": 19
    },
    {
        "id": "main_020",
        "type": "main",
        "requiredRecipeCount": 800,
        "quality": "传说",
        "qualityKey": "legendary",
        "title": "宫廷御厨",
        "sortOrder": 20
    },
    {
        "id": "main_021",
        "type": "main",
        "requiredRecipeCount": 1000,
        "quality": "神话",
        "qualityKey": "mythic",
        "title": "天下第一厨",
        "sortOrder": 21
    },
    {
        "id": "main_022",
        "type": "main",
        "requiredRecipeCount": 1500,
        "quality": "神话",
        "qualityKey": "mythic",
        "title": "炉火至尊",
        "sortOrder": 22
    },
    {
        "id": "main_023",
        "type": "main",
        "requiredRecipeCount": 2000,
        "quality": "神话",
        "qualityKey": "mythic",
        "title": "人间烟火之王",
        "sortOrder": 23
    },
    {
        "id": "main_024",
        "type": "main",
        "requiredRecipeCount": 3000,
        "quality": "神话",
        "qualityKey": "mythic",
        "title": "饕餮圣者",
        "sortOrder": 24
    },
    {
        "id": "main_025",
        "type": "main",
        "requiredRecipeCount": 5000,
        "quality": "至尊",
        "qualityKey": "supreme",
        "title": "至尊食神",
        "sortOrder": 25
    }
] as MainTitle[]

export const hiddenTitles = [
    {
        "id": "hidden_streak_003",
        "type": "hidden",
        "category": "坚持类",
        "title": "烟火初燃",
        "condition": "连续做饭 3 天",
        "hint": "灶火连续亮了三天。",
        "rule": {
            "metric": "cookingStreakDays",
            "operator": ">=",
            "value": 3
        }
    },
    {
        "id": "hidden_streak_007",
        "type": "hidden",
        "category": "坚持类",
        "title": "坚持掌勺人",
        "condition": "连续做饭 7 天",
        "hint": "一周的晚餐，都有你的烟火气。",
        "rule": {
            "metric": "cookingStreakDays",
            "operator": ">=",
            "value": 7
        }
    },
    {
        "id": "hidden_streak_015",
        "type": "hidden",
        "category": "坚持类",
        "title": "厨房修行者",
        "condition": "连续做饭 15 天",
        "hint": "半个月的重复，正在变成熟练。",
        "rule": {
            "metric": "cookingStreakDays",
            "operator": ">=",
            "value": 15
        }
    },
    {
        "id": "hidden_streak_030",
        "type": "hidden",
        "category": "坚持类",
        "title": "铁锅战神",
        "condition": "连续做饭 30 天",
        "hint": "整整一个月，锅铲没有冷下来。",
        "rule": {
            "metric": "cookingStreakDays",
            "operator": ">=",
            "value": 30
        }
    },
    {
        "id": "hidden_streak_100",
        "type": "hidden",
        "category": "坚持类",
        "title": "人间烟火守护者",
        "condition": "连续做饭 100 天",
        "hint": "一百天的烟火，需要真正的坚持。",
        "rule": {
            "metric": "cookingStreakDays",
            "operator": ">=",
            "value": 100
        }
    },
    {
        "id": "hidden_streak_365",
        "type": "hidden",
        "category": "坚持类",
        "title": "烟火仙人",
        "condition": "连续做饭 365 天",
        "hint": "四季轮转，灶台始终有人守着。",
        "rule": {
            "metric": "cookingStreakDays",
            "operator": ">=",
            "value": 365
        }
    },
    {
        "id": "hidden_time_late_001",
        "type": "hidden",
        "category": "时间类",
        "title": "深夜食堂新人",
        "condition": "第一次深夜 22:00 后做菜",
        "hint": "夜深了，厨房还亮着灯……",
        "rule": {
            "metric": "lateNightRecipeCount",
            "operator": ">=",
            "value": 1,
            "filters": {
                "localHourGte": 22
            }
        }
    },
    {
        "id": "hidden_time_late_010",
        "type": "hidden",
        "category": "时间类",
        "title": "深夜食堂老板",
        "condition": "深夜做菜 10 次",
        "hint": "夜色渐深，你的食堂却越来越熟练。",
        "rule": {
            "metric": "lateNightRecipeCount",
            "operator": ">=",
            "value": 10,
            "filters": {
                "localHourGte": 22
            }
        }
    },
    {
        "id": "hidden_time_late_100",
        "type": "hidden",
        "category": "时间类",
        "title": "深夜食神",
        "condition": "深夜做菜 100 次",
        "hint": "一百个深夜，都是你的营业时间。",
        "rule": {
            "metric": "lateNightRecipeCount",
            "operator": ">=",
            "value": 100,
            "filters": {
                "localHourGte": 22
            }
        }
    },
    {
        "id": "hidden_time_early_005",
        "type": "hidden",
        "category": "时间类",
        "title": "清晨料理师",
        "condition": "早上 7:00 前做菜 5 次",
        "hint": "太阳还没起床，厨房已经有了香气。",
        "rule": {
            "metric": "earlyMorningRecipeCount",
            "operator": ">=",
            "value": 5,
            "filters": {
                "localHourLt": 7
            }
        }
    },
    {
        "id": "hidden_time_weekend_020",
        "type": "hidden",
        "category": "时间类",
        "title": "周末厨房王",
        "condition": "周末做菜 20 次",
        "hint": "周末不只休息，也适合认真开火。",
        "rule": {
            "metric": "weekendRecipeCount",
            "operator": ">=",
            "value": 20,
            "filters": {
                "weekdayIn": [
                    6,
                    7
                ]
            }
        }
    },
    {
        "id": "hidden_burst_day_003",
        "type": "hidden",
        "category": "爆发类",
        "title": "今日爆炒王",
        "condition": "一天完成 3 道菜",
        "hint": "今天的灶台，比平时忙得多。",
        "rule": {
            "metric": "recipesCompletedInWindow",
            "operator": ">=",
            "value": 3,
            "window": "calendarDay"
        }
    },
    {
        "id": "hidden_burst_day_005",
        "type": "hidden",
        "category": "爆发类",
        "title": "厨房超负荷",
        "condition": "一天完成 5 道菜",
        "hint": "火力全开，厨房已进入高负荷模式。",
        "rule": {
            "metric": "recipesCompletedInWindow",
            "operator": ">=",
            "value": 5,
            "window": "calendarDay"
        }
    },
    {
        "id": "hidden_burst_week_010",
        "type": "hidden",
        "category": "爆发类",
        "title": "爆肝料理人",
        "condition": "一周完成 10 道菜",
        "hint": "这一周，你几乎把厨房当成了主场。",
        "rule": {
            "metric": "recipesCompletedInWindow",
            "operator": ">=",
            "value": 10,
            "window": "calendarWeek"
        }
    },
    {
        "id": "hidden_dish_vegetable_010",
        "type": "hidden",
        "category": "菜品类",
        "title": "绿色料理师",
        "condition": "完成 10 道素菜",
        "hint": "绿色正在成为你的拿手风味。",
        "rule": {
            "metric": "recipeTagCompletionCount",
            "operator": ">=",
            "value": 10,
            "filters": {
                "tag": "vegetable"
            }
        }
    },
    {
        "id": "hidden_dish_vegetable_030",
        "type": "hidden",
        "category": "菜品类",
        "title": "蔬菜守护神",
        "condition": "完成 30 道素菜",
        "hint": "一片菜叶，也能被你做出层次。",
        "rule": {
            "metric": "recipeTagCompletionCount",
            "operator": ">=",
            "value": 30,
            "filters": {
                "tag": "vegetable"
            }
        }
    },
    {
        "id": "hidden_dish_meat_010",
        "type": "hidden",
        "category": "菜品类",
        "title": "肉食掌门人",
        "condition": "完成 10 道肉菜",
        "hint": "对肉香的理解，开始有了门派。",
        "rule": {
            "metric": "recipeTagCompletionCount",
            "operator": ">=",
            "value": 10,
            "filters": {
                "tag": "meat"
            }
        }
    },
    {
        "id": "hidden_dish_meat_030",
        "type": "hidden",
        "category": "菜品类",
        "title": "烤肉霸主",
        "condition": "完成 30 道肉菜",
        "hint": "火候与肉香，已经被你牢牢掌握。",
        "rule": {
            "metric": "recipeTagCompletionCount",
            "operator": ">=",
            "value": 30,
            "filters": {
                "tag": "meat"
            }
        }
    },
    {
        "id": "hidden_dish_spicy_010",
        "type": "hidden",
        "category": "菜品类",
        "title": "辣椒挑战者",
        "condition": "完成 10 道辣菜",
        "hint": "舌尖开始接受更热烈的挑战。",
        "rule": {
            "metric": "recipeTagCompletionCount",
            "operator": ">=",
            "value": 10,
            "filters": {
                "tag": "spicy"
            }
        }
    },
    {
        "id": "hidden_dish_spicy_030",
        "type": "hidden",
        "category": "菜品类",
        "title": "辣王降临",
        "condition": "完成 30 道辣菜",
        "hint": "辣度不再是阻碍，而是你的武器。",
        "rule": {
            "metric": "recipeTagCompletionCount",
            "operator": ">=",
            "value": 30,
            "filters": {
                "tag": "spicy"
            }
        }
    },
    {
        "id": "hidden_dish_dessert_010",
        "type": "hidden",
        "category": "菜品类",
        "title": "甜蜜小厨",
        "condition": "完成 10 道甜品",
        "hint": "一点糖，让厨房变得柔软。",
        "rule": {
            "metric": "recipeTagCompletionCount",
            "operator": ">=",
            "value": 10,
            "filters": {
                "tag": "dessert"
            }
        }
    },
    {
        "id": "hidden_dish_dessert_030",
        "type": "hidden",
        "category": "菜品类",
        "title": "甜品魔导师",
        "condition": "完成 30 道甜品",
        "hint": "甜度、温度与口感都听你的指挥。",
        "rule": {
            "metric": "recipeTagCompletionCount",
            "operator": ">=",
            "value": 30,
            "filters": {
                "tag": "dessert"
            }
        }
    },
    {
        "id": "hidden_dish_soup_010",
        "type": "hidden",
        "category": "菜品类",
        "title": "一碗暖心人",
        "condition": "完成 10 道汤类",
        "hint": "一碗热汤，足以照顾一顿饭。",
        "rule": {
            "metric": "recipeTagCompletionCount",
            "operator": ">=",
            "value": 10,
            "filters": {
                "tag": "soup"
            }
        }
    },
    {
        "id": "hidden_dish_soup_030",
        "type": "hidden",
        "category": "菜品类",
        "title": "汤王在世",
        "condition": "完成 30 道汤类",
        "hint": "慢火熬出的温度，已经成为你的专长。",
        "rule": {
            "metric": "recipeTagCompletionCount",
            "operator": ">=",
            "value": 30,
            "filters": {
                "tag": "soup"
            }
        }
    },
    {
        "id": "hidden_skill_retry_001",
        "type": "hidden",
        "category": "失败与熟练类",
        "title": "不服输的厨师",
        "condition": "第一次做失败后重新完成",
        "hint": "一次失手，不代表今晚没有好饭。",
        "rule": {
            "metric": "failedThenCompletedSameRecipeCount",
            "operator": ">=",
            "value": 1
        }
    },
    {
        "id": "hidden_skill_fail_010",
        "type": "hidden",
        "category": "失败与熟练类",
        "title": "炸锅也不退",
        "condition": "失败 10 次后仍继续完成",
        "hint": "锅会糊，心态不能糊。",
        "rule": {
            "metric": "failureCountBeforeCompletion",
            "operator": ">=",
            "value": 10
        }
    },
    {
        "id": "hidden_skill_repeat_003",
        "type": "hidden",
        "category": "失败与熟练类",
        "title": "熟练掌勺人",
        "condition": "同一道菜做 3 次",
        "hint": "重复三次，手感开始形成。",
        "rule": {
            "metric": "sameRecipeCompletionMax",
            "operator": ">=",
            "value": 3
        }
    },
    {
        "id": "hidden_skill_repeat_010",
        "type": "hidden",
        "category": "失败与熟练类",
        "title": "这道菜我封神",
        "condition": "同一道菜做 10 次",
        "hint": "这道菜，已经成了你的个人招牌。",
        "rule": {
            "metric": "sameRecipeCompletionMax",
            "operator": ">=",
            "value": 10
        }
    },
    {
        "id": "hidden_social_favorite_050",
        "type": "hidden",
        "category": "收藏与社交类",
        "title": "菜谱收藏家",
        "condition": "收藏 50 个菜谱",
        "hint": "好菜谱值得留在自己的书架。",
        "rule": {
            "metric": "favoriteRecipeCount",
            "operator": ">=",
            "value": 50
        }
    },
    {
        "id": "hidden_social_favorite_100",
        "type": "hidden",
        "category": "收藏与社交类",
        "title": "秘籍收集者",
        "condition": "收藏 100 个菜谱",
        "hint": "你的收藏夹，正在变成一本厨房秘籍。",
        "rule": {
            "metric": "favoriteRecipeCount",
            "operator": ">=",
            "value": 100
        }
    },
    {
        "id": "hidden_social_share_010",
        "type": "hidden",
        "category": "收藏与社交类",
        "title": "美食传播官",
        "condition": "分享菜谱 10 次",
        "hint": "把好味道分享出去，也是一种投喂。",
        "rule": {
            "metric": "recipeShareCount",
            "operator": ">=",
            "value": 10
        }
    },
    {
        "id": "hidden_social_share_100",
        "type": "hidden",
        "category": "收藏与社交类",
        "title": "美味传教士",
        "condition": "分享菜谱 100 次",
        "hint": "一百次分享，让更多人走进厨房。",
        "rule": {
            "metric": "recipeShareCount",
            "operator": ">=",
            "value": 100
        }
    },
    {
        "id": "hidden_social_like_0010",
        "type": "hidden",
        "category": "收藏与社交类",
        "title": "被认可的厨师",
        "condition": "被别人点赞 10 次",
        "hint": "有人认真看见了你的成品。",
        "rule": {
            "metric": "likesReceivedCount",
            "operator": ">=",
            "value": 10
        }
    },
    {
        "id": "hidden_social_like_0100",
        "type": "hidden",
        "category": "收藏与社交类",
        "title": "人气主厨",
        "condition": "被别人点赞 100 次",
        "hint": "你的菜，正在被越来越多人记住。",
        "rule": {
            "metric": "likesReceivedCount",
            "operator": ">=",
            "value": 100
        }
    },
    {
        "id": "hidden_social_like_1000",
        "type": "hidden",
        "category": "收藏与社交类",
        "title": "人间饭王",
        "condition": "被别人点赞 1000 次",
        "hint": "一千次认可，足以坐稳饭桌中心。",
        "rule": {
            "metric": "likesReceivedCount",
            "operator": ">=",
            "value": 1000
        }
    },
    {
        "id": "hidden_random_001",
        "type": "hidden",
        "category": "随机互动类",
        "title": "命运开锅",
        "condition": "用骰子随机出菜 1 次",
        "hint": "把今晚的菜单交给一点运气。",
        "rule": {
            "metric": "diceRollCount",
            "operator": ">=",
            "value": 1
        }
    },
    {
        "id": "hidden_random_010",
        "type": "hidden",
        "category": "随机互动类",
        "title": "天选掌勺人",
        "condition": "用骰子随机出菜 10 次",
        "hint": "十次随机之后，命运也熟悉了你的口味。",
        "rule": {
            "metric": "diceRollCount",
            "operator": ">=",
            "value": 10
        }
    },
    {
        "id": "hidden_random_streak_003",
        "type": "hidden",
        "category": "随机互动类",
        "title": "欧皇厨师",
        "condition": "骰子连续 3 次摇到同类菜",
        "hint": "有时，骰子也会偏爱同一种味道。",
        "rule": {
            "metric": "sameRandomCategoryStreak",
            "operator": ">=",
            "value": 3
        }
    },
    {
        "id": "hidden_random_reroll_010",
        "type": "hidden",
        "category": "随机互动类",
        "title": "选择困难大师",
        "condition": "骰子摇到不想吃又换 10 次",
        "hint": "答案已经出现，但你决定再想一想。",
        "rule": {
            "metric": "randomRecipeRerollAfterRejectCount",
            "operator": ">=",
            "value": 10
        }
    },
    {
        "id": "hidden_random_complete_100",
        "type": "hidden",
        "category": "随机互动类",
        "title": "命运料理大师",
        "condition": "完成 100 道随机推荐菜",
        "hint": "一百次接受随机，也是一种坚定。",
        "rule": {
            "metric": "randomRecommendedRecipeCompletionCount",
            "operator": ">=",
            "value": 100
        }
    },
    {
        "id": "hidden_recommend_first",
        "type": "hidden",
        "category": "推荐类",
        "title": "今日吃什么探索者",
        "condition": "第一次让 App 推荐今日食谱",
        "hint": "第一次，把“今天吃什么”交给美味助手。",
        "rule": {
            "metric": "dailyRecommendationRequestCount",
            "operator": ">=",
            "value": 1
        }
    },
    {
        "id": "hidden_recommend_streak_007",
        "type": "hidden",
        "category": "推荐类",
        "title": "听劝料理人",
        "condition": "连续 7 天接受每日推荐",
        "hint": "连续七天，推荐都被你认真端上桌。",
        "rule": {
            "metric": "acceptedDailyRecommendationStreakDays",
            "operator": ">=",
            "value": 7
        }
    },
    {
        "id": "hidden_explore_new_001",
        "type": "hidden",
        "category": "探索类",
        "title": "新味觉冒险家",
        "condition": "做完一道从没吃过的菜",
        "hint": "陌生的味道，值得一次大胆下锅。",
        "rule": {
            "metric": "newToUserRecipeCompletionCount",
            "operator": ">=",
            "value": 1
        }
    },
    {
        "id": "hidden_explore_cuisine_010",
        "type": "hidden",
        "category": "探索类",
        "title": "百味旅行家",
        "condition": "完成 10 个不同菜系",
        "hint": "不出厨房，也能走过十种风味。",
        "rule": {
            "metric": "distinctCuisineCompletedCount",
            "operator": ">=",
            "value": 10
        }
    },
    {
        "id": "hidden_explore_all_cuisine_010",
        "type": "hidden",
        "category": "探索类",
        "title": "全菜系制霸者",
        "condition": "所有菜系各完成 10 道",
        "hint": "每一种菜系，都留下了你的火候。",
        "rule": {
            "metric": "minimumCompletionCountAcrossAllCuisines",
            "operator": ">=",
            "value": 10
        }
    },
    {
        "id": "hidden_explore_all_categories",
        "type": "hidden",
        "category": "探索类",
        "title": "厨房全能王",
        "condition": "所有分类都完成过",
        "hint": "厨房里的每一种任务，你都做过。",
        "rule": {
            "metric": "completedAllRecipeCategories",
            "operator": "==",
            "value": true
        }
    },
    {
        "id": "hidden_cuisine_sichuan_010",
        "type": "hidden",
        "category": "菜系类",
        "title": "川味掌门",
        "condition": "完成川菜 10 道",
        "hint": "麻辣鲜香，已经有了自己的章法。",
        "rule": {
            "metric": "cuisineCompletionCount",
            "operator": ">=",
            "value": 10,
            "filters": {
                "cuisine": "sichuan"
            }
        }
    },
    {
        "id": "hidden_cuisine_cantonese_010",
        "type": "hidden",
        "category": "菜系类",
        "title": "粤味行家",
        "condition": "完成粤菜 10 道",
        "hint": "清鲜与火候，你开始懂得取舍。",
        "rule": {
            "metric": "cuisineCompletionCount",
            "operator": ">=",
            "value": 10,
            "filters": {
                "cuisine": "cantonese"
            }
        }
    },
    {
        "id": "hidden_cuisine_hunan_010",
        "type": "hidden",
        "category": "菜系类",
        "title": "湘辣高手",
        "condition": "完成湘菜 10 道",
        "hint": "香辣浓烈，也能被你做得有层次。",
        "rule": {
            "metric": "cuisineCompletionCount",
            "operator": ">=",
            "value": 10,
            "filters": {
                "cuisine": "hunan"
            }
        }
    },
    {
        "id": "hidden_cuisine_northeast_010",
        "type": "hidden",
        "category": "菜系类",
        "title": "铁锅炖大师",
        "condition": "完成东北菜 10 道",
        "hint": "大锅、慢炖和热气，是你的主场。",
        "rule": {
            "metric": "cuisineCompletionCount",
            "operator": ">=",
            "value": 10,
            "filters": {
                "cuisine": "northeast"
            }
        }
    },
    {
        "id": "hidden_record_during_020",
        "type": "hidden",
        "category": "记录类",
        "title": "美食摄影师",
        "condition": "做饭同时记录照片 20 次",
        "hint": "镜头开始记住每一次下锅。",
        "rule": {
            "metric": "cookingProcessPhotoSessionCount",
            "operator": ">=",
            "value": 20
        }
    },
    {
        "id": "hidden_record_finished_050",
        "type": "hidden",
        "category": "记录类",
        "title": "朋友圈投喂官",
        "condition": "上传成品图 50 次",
        "hint": "五十张成品图，足够让朋友经常饿。",
        "rule": {
            "metric": "finishedDishPhotoUploadCount",
            "operator": ">=",
            "value": 50
        }
    },
    {
        "id": "hidden_record_finished_365",
        "type": "hidden",
        "category": "记录类",
        "title": "美食记录官",
        "condition": "上传 365 张成品图",
        "hint": "三百六十五张照片，组成了一整年的烟火。",
        "rule": {
            "metric": "finishedDishPhotoUploadCount",
            "operator": ">=",
            "value": 365
        }
    },
    {
        "id": "hidden_life_no_delivery_007",
        "type": "hidden",
        "category": "生活类",
        "title": "外卖戒断者",
        "condition": "连续 7 天不点外卖",
        "hint": "一周没有外卖袋，只有厨房的热气。",
        "rule": {
            "metric": "noDeliveryStreakDays",
            "operator": ">=",
            "value": 7,
            "verification": "selfReportedOrExternalIntegration"
        }
    },
    {
        "id": "hidden_life_no_delivery_030",
        "type": "hidden",
        "category": "生活类",
        "title": "自炊王者",
        "condition": "连续 30 天不点外卖",
        "hint": "一个月的三餐，都由自己认真照顾。",
        "rule": {
            "metric": "noDeliveryStreakDays",
            "operator": ">=",
            "value": 30,
            "verification": "selfReportedOrExternalIntegration"
        }
    },
    {
        "id": "hidden_feed_001",
        "type": "hidden",
        "category": "投喂类",
        "title": "投喂新人",
        "condition": "第一次做饭给别人吃",
        "hint": "第一次把亲手做的饭端给别人。",
        "rule": {
            "metric": "cookedForOthersCount",
            "operator": ">=",
            "value": 1
        }
    },
    {
        "id": "hidden_feed_010",
        "type": "hidden",
        "category": "投喂类",
        "title": "家庭投喂官",
        "condition": "给别人做饭 10 次",
        "hint": "十次投喂，饭桌开始习惯你的存在。",
        "rule": {
            "metric": "cookedForOthersCount",
            "operator": ">=",
            "value": 10
        }
    },
    {
        "id": "hidden_feed_050",
        "type": "hidden",
        "category": "投喂类",
        "title": "饭桌核心人物",
        "condition": "给别人做饭 50 次",
        "hint": "五十次开饭，你已经成了饭桌中心。",
        "rule": {
            "metric": "cookedForOthersCount",
            "operator": ">=",
            "value": 50
        }
    },
    {
        "id": "hidden_festival_first",
        "type": "hidden",
        "category": "节日类",
        "title": "节日掌勺人",
        "condition": "第一次做节日菜",
        "hint": "节日的仪式感，从厨房开始。",
        "rule": {
            "metric": "festivalRecipeCompletionCount",
            "operator": ">=",
            "value": 1
        }
    },
    {
        "id": "hidden_festival_spring_festival",
        "type": "hidden",
        "category": "节日类",
        "title": "年夜饭守护者",
        "condition": "春节做菜",
        "hint": "团圆夜的热菜，由你守住。",
        "rule": {
            "metric": "specificDateRecipeCompletionCount",
            "operator": ">=",
            "value": 1,
            "filters": {
                "occasion": "spring_festival"
            }
        }
    },
    {
        "id": "hidden_festival_dragon_boat",
        "type": "hidden",
        "category": "节日类",
        "title": "粽香料理人",
        "condition": "端午做菜",
        "hint": "粽叶与蒸汽，都是端午的味道。",
        "rule": {
            "metric": "specificDateRecipeCompletionCount",
            "operator": ">=",
            "value": 1,
            "filters": {
                "occasion": "dragon_boat"
            }
        }
    },
    {
        "id": "hidden_festival_mid_autumn",
        "type": "hidden",
        "category": "节日类",
        "title": "月光掌勺人",
        "condition": "中秋做菜",
        "hint": "月亮升起时，厨房也亮着。",
        "rule": {
            "metric": "specificDateRecipeCompletionCount",
            "operator": ">=",
            "value": 1,
            "filters": {
                "occasion": "mid_autumn"
            }
        }
    },
    {
        "id": "hidden_festival_christmas",
        "type": "hidden",
        "category": "节日类",
        "title": "圣诞厨房官",
        "condition": "圣诞做菜",
        "hint": "冬夜的节日香气，从烤箱和锅里来。",
        "rule": {
            "metric": "specificDateRecipeCompletionCount",
            "operator": ">=",
            "value": 1,
            "filters": {
                "occasion": "christmas"
            }
        }
    },
    {
        "id": "hidden_festival_birthday",
        "type": "hidden",
        "category": "节日类",
        "title": "生日主厨",
        "condition": "生日当天做菜",
        "hint": "今天的主厨，也值得被认真庆祝。",
        "rule": {
            "metric": "specificDateRecipeCompletionCount",
            "operator": ">=",
            "value": 1,
            "filters": {
                "occasion": "birthday"
            }
        }
    },
    {
        "id": "hidden_rare_four_seasons",
        "type": "hidden",
        "category": "稀有隐藏类",
        "title": "四季掌勺人",
        "condition": "一年内每个月都做菜",
        "hint": "十二个月，都有一道菜留下痕迹。",
        "rule": {
            "metric": "activeCookingMonthsInRollingYear",
            "operator": ">=",
            "value": 12
        }
    },
    {
        "id": "hidden_rare_five_flavors",
        "type": "hidden",
        "category": "稀有隐藏类",
        "title": "五味掌控者",
        "condition": "做过酸甜苦辣咸五类菜",
        "hint": "酸甜苦辣咸，五味已经集齐。",
        "rule": {
            "metric": "completedAllFlavorFamilies",
            "operator": "==",
            "value": true,
            "filters": {
                "flavors": [
                    "sour",
                    "sweet",
                    "bitter",
                    "spicy",
                    "salty"
                ]
            }
        }
    },
    {
        "id": "hidden_rare_app_365",
        "type": "hidden",
        "category": "稀有隐藏类",
        "title": "老灶台守护者",
        "condition": "使用 App 满 365 天",
        "hint": "陪伴一年，灶台也成了老朋友。",
        "rule": {
            "metric": "accountAgeDays",
            "operator": ">=",
            "value": 365
        }
    },
    {
        "id": "hidden_number_0520",
        "type": "hidden",
        "category": "特殊数字类",
        "title": "爱的投喂官",
        "condition": "完成 520 道菜",
        "hint": "五百二十道菜，是很长的一句“好好吃饭”。",
        "rule": {
            "metric": "recipeCompletionCount",
            "operator": "==",
            "value": 520
        }
    },
    {
        "id": "hidden_number_0666",
        "type": "hidden",
        "category": "特殊数字类",
        "title": "厨房欧皇",
        "condition": "完成 666 道菜",
        "hint": "这个数字，连锅铲都觉得顺。",
        "rule": {
            "metric": "recipeCompletionCount",
            "operator": "==",
            "value": 666
        }
    },
    {
        "id": "hidden_number_0888",
        "type": "hidden",
        "category": "特殊数字类",
        "title": "发财掌勺人",
        "condition": "完成 888 道菜",
        "hint": "八方来味，好运也跟着开锅。",
        "rule": {
            "metric": "recipeCompletionCount",
            "operator": "==",
            "value": 888
        }
    },
    {
        "id": "hidden_number_0999",
        "type": "hidden",
        "category": "特殊数字类",
        "title": "长长久久食神",
        "condition": "完成 999 道菜",
        "hint": "九百九十九道菜，把烟火做得长久。",
        "rule": {
            "metric": "recipeCompletionCount",
            "operator": "==",
            "value": 999
        }
    },
    {
        "id": "hidden_number_1000",
        "type": "hidden",
        "category": "特殊数字类",
        "title": "万味归宗",
        "condition": "完成 1000 道菜",
        "hint": "第一千道菜，是一次重要的归途。",
        "rule": {
            "metric": "recipeCompletionCount",
            "operator": "==",
            "value": 1000
        }
    },
    {
        "id": "hidden_number_1314",
        "type": "hidden",
        "category": "特殊数字类",
        "title": "一生一世投喂官",
        "condition": "完成 1314 道菜",
        "hint": "一千三百一十四次，把照顾写进三餐。",
        "rule": {
            "metric": "recipeCompletionCount",
            "operator": "==",
            "value": 1314
        }
    },
    {
        "id": "hidden_number_2026",
        "type": "hidden",
        "category": "特殊数字类",
        "title": "年度食神",
        "condition": "完成 2026 道菜",
        "hint": "第二千零二十六道菜，值得一枚年份纪念章。",
        "rule": {
            "metric": "recipeCompletionCount",
            "operator": "==",
            "value": 2026
        }
    },
    {
        "id": "hidden_mystic_first_001",
        "type": "hidden",
        "category": "玄学互动类",
        "title": "天机开锅",
        "condition": "第一次通过玄学厨房选出菜谱",
        "hint": "让一点玄学替今晚做决定。",
        "rule": {
            "metric": "mysticCastCount",
            "operator": ">=",
            "value": 1
        }
    }
] as HiddenTitle[]

export const titleCounts = {
    "main": 25,
    "hidden": 75
}
