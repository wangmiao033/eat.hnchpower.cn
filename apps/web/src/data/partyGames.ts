export type PartyRoleId = 'chef' | 'washer' | 'helper' | 'shopper'

export interface PartyRole {
    id: PartyRoleId
    label: string
    icon: string
    description: string
}

export interface PartyPlayer {
    id: string
    name: string
}

export const partyRoles: PartyRole[] = [
    { id: 'chef', label: '主厨', icon: '🍳', description: '负责下锅和最终调味。' },
    { id: 'washer', label: '洗碗', icon: '💧', description: '负责餐后清洗和收台。' },
    { id: 'helper', label: '帮厨', icon: '🔪', description: '负责切配、递调料和计时。' },
    { id: 'shopper', label: '采购', icon: '🧺', description: '负责补齐缺少食材和饮品。' }
]

export const defaultPlayers: PartyPlayer[] = [
    { id: 'p1', name: '我' },
    { id: 'p2', name: '搭子' },
    { id: 'p3', name: '朋友' },
    { id: 'p4', name: '家人' }
]

export const diceFaceRecipeSlots = [
    { face: 1, label: '稳妥快手', recipeIds: ['tomato-egg', 'shrimp-broccoli'] },
    { face: 2, label: '清爽轻食', recipeIds: ['shrimp-broccoli', 'winter-melon-soup'] },
    { face: 3, label: '家常下饭', recipeIds: ['braised-eggplant', 'mushroom-chicken'] },
    { face: 4, label: '香辣破局', recipeIds: ['mapo-tofu', 'thai-basil-pork'] },
    { face: 5, label: '一人完整', recipeIds: ['teriyaki-chicken-rice', 'sour-spicy-potato'] },
    { face: 6, label: '饭局硬菜', recipeIds: ['potato-beef', 'mushroom-chicken'] }
]
