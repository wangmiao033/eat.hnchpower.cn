const dishPool = [
  {
    id: "tomato-egg",
    name: "番茄炒蛋",
    time: "12分钟",
    difficulty: "简单",
    tags: ["快手", "下饭", "清淡"],
    ingredients: ["番茄", "鸡蛋", "葱"],
    steps: ["番茄切块，鸡蛋打散加少许盐。", "热锅下油炒蛋，凝固后盛出。", "炒番茄出汁后倒回鸡蛋，调盐和少许糖。"]
  },
  {
    id: "pepper-pork",
    name: "青椒肉丝",
    time: "18分钟",
    difficulty: "中等",
    tags: ["下饭", "快手", "家常"],
    ingredients: ["青椒", "猪肉", "生抽"],
    steps: ["肉丝用生抽、淀粉和油抓匀。", "青椒切丝，大火先滑炒肉丝。", "回锅青椒，快速翻炒到断生。"]
  },
  {
    id: "mapo-tofu",
    name: "麻婆豆腐",
    time: "20分钟",
    difficulty: "中等",
    tags: ["辣", "下饭", "热菜"],
    ingredients: ["豆腐", "肉末", "豆瓣酱"],
    steps: ["豆腐切块焯水，去豆腥并定型。", "炒香肉末、豆瓣酱和蒜末。", "加水烧开后下豆腐，勾薄芡收汁。"]
  },
  {
    id: "mushroom-chicken",
    name: "香菇滑鸡",
    time: "25分钟",
    difficulty: "中等",
    tags: ["清淡", "高蛋白", "蒸菜"],
    ingredients: ["鸡腿肉", "香菇", "姜"],
    steps: ["鸡腿肉切块，用盐、生抽、淀粉腌10分钟。", "香菇切片和姜丝铺在鸡肉上。", "水开后蒸15分钟，出锅撒葱。"]
  },
  {
    id: "cold-noodle",
    name: "麻酱拌面",
    time: "15分钟",
    difficulty: "简单",
    tags: ["快手", "一人食", "主食"],
    ingredients: ["面条", "黄瓜", "芝麻酱"],
    steps: ["面条煮熟过凉水，黄瓜切丝。", "芝麻酱用温水、生抽、醋和蒜末调开。", "面条拌入酱汁和配菜即可。"]
  },
  {
    id: "shrimp-broccoli",
    name: "虾仁西兰花",
    time: "16分钟",
    difficulty: "简单",
    tags: ["减脂", "高蛋白", "清淡"],
    ingredients: ["虾仁", "西兰花", "蒜"],
    steps: ["西兰花焯水，虾仁加料酒和盐腌5分钟。", "蒜末爆香后下虾仁炒变色。", "倒入西兰花，加盐和黑胡椒翻匀。"]
  },
  {
    id: "potato-beef",
    name: "土豆炖牛肉",
    time: "55分钟",
    difficulty: "中等",
    tags: ["硬菜", "下饭", "热菜"],
    ingredients: ["牛肉", "土豆", "胡萝卜"],
    steps: ["牛肉焯水，土豆和胡萝卜切块。", "炒香葱姜和牛肉，加生抽、老抽和热水。", "炖40分钟后下土豆，再炖到软糯。"]
  },
  {
    id: "cabbage-vermicelli",
    name: "白菜粉丝煲",
    time: "22分钟",
    difficulty: "简单",
    tags: ["清淡", "热菜", "省心"],
    ingredients: ["白菜", "粉丝", "豆腐"],
    steps: ["粉丝泡软，白菜切大片。", "锅中加汤或清水，放白菜和豆腐煮开。", "下粉丝煮软，调盐、白胡椒和香油。"]
  }
]

const preferenceOptions = ["快手", "下饭", "清淡", "辣", "减脂", "一人食", "高蛋白", "硬菜"]

function normalizeIngredients(input) {
  return input
    .split(/[，,、\s]+/)
    .map((item) => item.trim())
    .filter(Boolean)
}

function scoreDish(dish, selectedTags, ingredients) {
  const tagScore = selectedTags.reduce((score, tag) => score + (dish.tags.includes(tag) ? 3 : 0), 0)
  const ingredientScore = ingredients.reduce((score, ingredient) => {
    return score + (dish.ingredients.some((item) => item.includes(ingredient) || ingredient.includes(item)) ? 4 : 0)
  }, 0)
  return tagScore + ingredientScore + Math.random()
}

function pickDish(selectedTags = [], ingredientInput = "") {
  const ingredients = normalizeIngredients(ingredientInput)
  const ranked = dishPool
    .map((dish) => ({
      ...dish,
      score: scoreDish(dish, selectedTags, ingredients)
    }))
    .sort((a, b) => b.score - a.score)

  const candidates = ranked.filter((dish) => dish.score > 0)
  const source = candidates.length > 0 ? candidates.slice(0, 4) : ranked
  const selected = source[Math.floor(Math.random() * source.length)]

  return {
    ...selected,
    pickedAt: Date.now()
  }
}

module.exports = {
  dishPool,
  preferenceOptions,
  pickDish
}
