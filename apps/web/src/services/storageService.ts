export interface CompletionEvent {
    recipeId: string
    completedAt: string
    source: 'today' | 'dice' | 'mystic' | 'library' | 'ai'
}

export interface MeiweiUserState {
    completedRecipeIds: string[]
    completionEvents: CompletionEvent[]
    favoriteRecipeIds: string[]
    cookedRecipeIds: string[]
    menuRecipeIds: string[]
    unlockedTitleIds: string[]
    displayHiddenTitleId: string | null
    diceRollCount: number
    diceRejectCount: number
    mysticKitchenCount: number
    partyRoleAssignmentCount: number
    cookingStreakDays: number
    lastCompletionDate: string | null
    lastDiceRecipeCategories: string[]
}

const STORAGE_KEY = 'meiwei-assistant-state'

export const defaultUserState: MeiweiUserState = {
    completedRecipeIds: [],
    completionEvents: [],
    favoriteRecipeIds: [],
    cookedRecipeIds: [],
    menuRecipeIds: [],
    unlockedTitleIds: ['main_001'],
    displayHiddenTitleId: null,
    diceRollCount: 0,
    diceRejectCount: 0,
    mysticKitchenCount: 0,
    partyRoleAssignmentCount: 0,
    cookingStreakDays: 0,
    lastCompletionDate: null,
    lastDiceRecipeCategories: []
}

const unique = <T>(items: T[]) => Array.from(new Set(items))

export const storageService = {
    getState(): MeiweiUserState {
        if (typeof localStorage === 'undefined') return { ...defaultUserState }

        try {
            const saved = localStorage.getItem(STORAGE_KEY)
            if (!saved) return { ...defaultUserState }
            return { ...defaultUserState, ...JSON.parse(saved) }
        } catch (error) {
            console.warn('读取美味助手本地状态失败:', error)
            return { ...defaultUserState }
        }
    },

    saveState(state: MeiweiUserState) {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(state))
    },

    updateState(mutator: (state: MeiweiUserState) => MeiweiUserState | void) {
        const draft = this.getState()
        const result = mutator(draft)
        const next = result || draft
        this.saveState(next)
        return next
    },

    toggleFavorite(recipeId: string) {
        return this.updateState(state => {
            state.favoriteRecipeIds = state.favoriteRecipeIds.includes(recipeId)
                ? state.favoriteRecipeIds.filter(id => id !== recipeId)
                : unique([...state.favoriteRecipeIds, recipeId])
        })
    },

    addToMenu(recipeId: string) {
        return this.updateState(state => {
            state.menuRecipeIds = unique([...state.menuRecipeIds, recipeId])
        })
    },

    markCooked(recipeId: string, source: CompletionEvent['source']) {
        const today = new Date().toISOString().slice(0, 10)

        return this.updateState(state => {
            state.cookedRecipeIds = unique([...state.cookedRecipeIds, recipeId])
            state.completedRecipeIds = unique([...state.completedRecipeIds, recipeId])
            state.completionEvents.push({
                recipeId,
                source,
                completedAt: new Date().toISOString()
            })

            if (state.lastCompletionDate !== today) {
                const yesterday = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString().slice(0, 10)
                state.cookingStreakDays = state.lastCompletionDate === yesterday ? state.cookingStreakDays + 1 : 1
                state.lastCompletionDate = today
            }
        })
    },

    recordDiceRoll(category: string) {
        return this.updateState(state => {
            state.diceRollCount += 1
            state.lastDiceRecipeCategories = [...state.lastDiceRecipeCategories.slice(-2), category]
        })
    },

    recordDiceReject() {
        return this.updateState(state => {
            state.diceRejectCount += 1
        })
    },

    recordMysticCast() {
        return this.updateState(state => {
            state.mysticKitchenCount += 1
        })
    },

    recordPartyAssignment() {
        return this.updateState(state => {
            state.partyRoleAssignmentCount += 1
        })
    },

    unlockTitles(titleIds: string[]) {
        return this.updateState(state => {
            state.unlockedTitleIds = unique([...state.unlockedTitleIds, ...titleIds])
        })
    },

    setDisplayHiddenTitle(titleId: string | null) {
        return this.updateState(state => {
            state.displayHiddenTitleId = titleId
        })
    }
}
