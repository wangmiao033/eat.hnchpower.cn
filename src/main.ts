import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import App from './App.vue'
import Home from './views/Home.vue'
import About from './views/About.vue'
import TodayEat from './views/TodayEat.vue'
import TableDesign from './views/TableDesign.vue'
import Favorites from './views/Favorites.vue'
import Gallery from './views/Gallery.vue'
import HowToCook from './views/HowToCook.vue'
import SauceDesign from './views/SauceDesign.vue'
import FortuneCooking from './views/FortuneCooking.vue'
import SettingsDemo from './views/SettingsDemo.vue'
import { autoRefreshEnvSettings } from './utils/envWatcher'
import { APP_NAME } from './config/app'
import './style.css'

const routes = [
    { path: '/', component: Home, meta: { title: APP_NAME } },
    { path: '/about', component: About, meta: { title: `关于${APP_NAME}` } },
    { path: '/today-eat', component: TodayEat, meta: { title: '美食盲盒' } },
    { path: '/table-design', component: TableDesign, meta: { title: '一桌好菜' } },
    { path: '/favorites', component: Favorites, meta: { title: '我的收藏' } },
    { path: '/gallery', component: Gallery, meta: { title: '美味图库' } },
    { path: '/how-to-cook', component: HowToCook, meta: { title: '菜谱指南' } },
    { path: '/sauce-design', component: SauceDesign, meta: { title: '酱料助手' } },
    { path: '/fortune-cooking', component: FortuneCooking, meta: { title: '玄学厨房' } },
    { path: '/settings-demo', component: SettingsDemo, meta: { title: '设置测试' } }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

router.afterEach(to => {
    const pageTitle = typeof to.meta.title === 'string' ? to.meta.title : APP_NAME
    document.title = pageTitle === APP_NAME ? APP_NAME : `${pageTitle} - ${APP_NAME}`
})

// 初始化应用
const app = createApp(App).use(router)

// 在应用挂载前检查环境变量变化并自动刷新
autoRefreshEnvSettings()

// 挂载应用
app.mount('#app')
