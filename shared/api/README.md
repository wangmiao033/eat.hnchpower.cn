# API Contract Draft

第一版本地运行，后续接后端时建议保持以下接口边界。

## Daily Recommendation

`GET /api/recommendations/daily?date=YYYY-MM-DD`

返回稳定 `recipeId`，同一天同用户结果一致。

## Recipe Generation

`POST /api/recipes/generate`

请求：

```json
{
  "ingredients": ["番茄", "鸡蛋"],
  "preferences": ["快手", "下饭"],
  "scene": "工作日晚餐"
}
```

## Event Tracking

`POST /api/events`

事件名建议：

- `recipe_completed`
- `dice_rolled`
- `dice_recipe_rejected`
- `mystic_cast_result`
- `kitchen_roles_assigned`
- `title_unlocked`

事件必须带 `eventId`，服务端按 `eventId` 幂等处理。
