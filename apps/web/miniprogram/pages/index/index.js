const { preferenceOptions, pickDish } = require("../../utils/menu")

Page({
  data: {
    preferenceOptions: preferenceOptions.map((name) => ({
      name,
      active: false
    })),
    selectedTags: [],
    ingredientInput: "",
    currentDish: null,
    lastShakeAt: 0
  },

  onShow() {
    this.startShakeListener()
  },

  onHide() {
    this.stopShakeListener()
    wx.stopAccelerometer()
  },

  onUnload() {
    this.stopShakeListener()
    wx.stopAccelerometer()
  },

  onIngredientInput(event) {
    this.setData({
      ingredientInput: event.detail.value
    })
  },

  toggleTag(event) {
    const tag = event.currentTarget.dataset.tag
    const selected = this.data.selectedTags.includes(tag)
      ? this.data.selectedTags.filter((item) => item !== tag)
      : [...this.data.selectedTags, tag]

    this.setData({
      selectedTags: selected,
      preferenceOptions: preferenceOptions.map((name) => ({
        name,
        active: selected.includes(name)
      }))
    })
  },

  pickTodayDish() {
    const dish = pickDish(this.data.selectedTags, this.data.ingredientInput)
    this.setData({
      currentDish: {
        ...dish,
        ingredientsText: dish.ingredients.join("、")
      }
    })

    wx.vibrateShort({ type: "light" })
  },

  saveCurrentDish() {
    if (!this.data.currentDish) {
      return
    }

    getApp().saveFavorite(this.data.currentDish)
    wx.showToast({
      title: "已收藏",
      icon: "success"
    })
  },

  startShakeListener() {
    if (this.shakeHandler) {
      return
    }

    this.shakeHandler = (res) => {
      const now = Date.now()
      const speed = Math.abs(res.x) + Math.abs(res.y) + Math.abs(res.z)

      if (speed > 4.2 && now - this.data.lastShakeAt > 1200) {
        this.setData({ lastShakeAt: now })
        this.pickTodayDish()
      }
    }

    wx.startAccelerometer({ interval: "game" })
    wx.onAccelerometerChange(this.shakeHandler)
  },

  stopShakeListener() {
    if (this.shakeHandler && wx.offAccelerometerChange) {
      wx.offAccelerometerChange(this.shakeHandler)
    }
    this.shakeHandler = null
  }
})
