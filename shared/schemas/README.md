# Shared Data Schemas

当前先用文档约束字段，后续可补 JSON Schema。

## Recipe

- `id`: 稳定菜谱 ID
- `name`: 菜名
- `cuisine`: 菜系或风格
- `category`: 分类
- `time`: 分钟
- `difficulty`: `easy | medium | hard`
- `tags`: 标签
- `moodTags`: 心情标签
- `luckyIngredients`: 玄学厨房可用幸运食材
- `ingredients`: `{ name, amount }[]`
- `steps`: 三步或多步做法

## Title

来自 `shared/data/titles.json`：

- `mainTitles`: 主线称号，按完成菜谱数量升级
- `hiddenTitles`: 隐藏称号，按行为规则解锁
- `qualityPalette`: 品质颜色和说明

## Mystic

- `modes`: 六种玄学玩法
- `moods`: 心情开锅配置
- `tarotCards`: 塔罗菜牌
- `flavorSticks`: 五味灵签

## Party Games

- `roles`: 主厨、洗碗、帮厨、采购
- `defaultPlayers`: 默认参与者
- `diceFaceRecipeSlots`: D6 每面对应候选菜谱
