Page({
  data: {
    favorites: []
  },

  onShow() {
    this.loadFavorites()
  },

  loadFavorites() {
    this.setData({
      favorites: getApp().getFavorites().map((item) => ({
        ...item,
        ingredientsText: item.ingredientsText || (item.ingredients || []).join("、")
      }))
    })
  },

  removeFavorite(event) {
    const id = event.currentTarget.dataset.id
    getApp().removeFavorite(id)
    this.loadFavorites()
    wx.showToast({
      title: "已删除",
      icon: "none"
    })
  }
})
