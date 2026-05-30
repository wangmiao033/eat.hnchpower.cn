App({
  globalData: {
    favoritesKey: "todayEatFavorites",
    settingsKey: "todayEatSettings"
  },

  getFavorites() {
    return wx.getStorageSync(this.globalData.favoritesKey) || []
  },

  saveFavorite(dish) {
    const favorites = this.getFavorites()
    const exists = favorites.some((item) => item.id === dish.id)

    if (!exists) {
      wx.setStorageSync(this.globalData.favoritesKey, [
        {
          ...dish,
          savedAt: Date.now()
        },
        ...favorites
      ])
    }
  },

  removeFavorite(id) {
    const favorites = this.getFavorites().filter((item) => item.id !== id)
    wx.setStorageSync(this.globalData.favoritesKey, favorites)
  }
})
