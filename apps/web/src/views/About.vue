<template>
    <div class="min-h-screen bg-yellow-400 px-2 md:px-4 py-6">
        <!-- 全局导航 -->
        <GlobalNavigation />

        <div class="max-w-7xl mx-auto space-y-6">
            <!-- API服务商推荐 -->
            <div class="relative" v-show="false">
                <div class="bg-gradient-to-r from-blue-500 to-cyan-500 text-white px-4 py-2 rounded-t-lg border-2 border-[#0A0910] border-b-0 inline-block mb-0">
                    <span class="font-bold text-lg">🚀 API服务商</span>
                </div>
                <div class="bg-white border-2 border-[#0A0910] rounded-lg rounded-tl-none p-6">
                    <div class="mt-4">
                        <div class="flex items-center gap-2 mb-6">
                            <span class="text-2xl">⚡</span>
                            <div>
                                <p class="text-gray-700 text-sm font-medium">本项目AI服务提供商</p>
                                <p class="text-gray-500 text-xs">为您推荐优质的AI API服务</p>
                            </div>
                        </div>

                        <!-- 302.AI 推荐卡片 -->
                        <div
                            class="bg-gradient-to-br from-blue-50 to-purple-50 border-3 border-blue-300 rounded-xl p-4 md:p-6 mb-6 shadow-lg hover:shadow-xl transition-all duration-300 transform"
                        >
                            <!-- 手机端：垂直布局，桌面端：水平布局 -->
                            <div class="flex flex-col md:flex-row md:items-start gap-4 md:gap-6">
                                <!-- Logo 区域 -->
                                <div class="flex-shrink-0 flex justify-center md:justify-start">
                                    <div class="w-16 h-16 from-blue-500 to-purple-600 rounded-xl flex items-center justify-center">
                                        <img src="/logo.svg" alt="302.AI Logo" class="w-12 h-12" />
                                    </div>
                                </div>
                                <!-- 内容区域 -->
                                <div class="flex-1 text-center md:text-left">
                                    <div class="flex flex-col md:flex-row items-center md:items-center gap-2 md:gap-3 mb-3">
                                        <h3 class="text-xl font-bold text-gray-800">302.AI</h3>
                                        <span class="bg-gradient-to-r from-orange-400 to-red-500 text-white text-xs px-3 py-1 rounded-full font-medium animate-pulse"
                                            >官方合作伙伴</span
                                        >
                                    </div>
                                    <p class="text-gray-700 text-sm mb-4 leading-relaxed">
                                        <strong>302.AI</strong>是一个按用量付费的企业级AI资源平台，提供市场上最新、最全面的AI模型和API，以及多种开箱即用的在线AI应用
                                    </p>

                                    <div class="grid grid-cols-2 md:grid-cols-4 gap-2 md:gap-3 mb-4">
                                        <div class="bg-white rounded-lg p-2 md:p-3 border border-blue-200">
                                            <div class="text-center">
                                                <div class="text-blue-500 text-base md:text-lg mb-1">🤖</div>
                                                <div class="text-xs font-medium text-gray-700">多模型支持</div>
                                            </div>
                                        </div>
                                        <div class="bg-white rounded-lg p-2 md:p-3 border border-green-200">
                                            <div class="text-center">
                                                <div class="text-green-500 text-base md:text-lg mb-1">💰</div>
                                                <div class="text-xs font-medium text-gray-700">价格优惠</div>
                                            </div>
                                        </div>
                                        <div class="bg-white rounded-lg p-2 md:p-3 border border-purple-200">
                                            <div class="text-center">
                                                <div class="text-purple-500 text-base md:text-lg mb-1">⚡</div>
                                                <div class="text-xs font-medium text-gray-700">响应快速</div>
                                            </div>
                                        </div>
                                        <div class="bg-white rounded-lg p-2 md:p-3 border border-orange-200">
                                            <div class="text-center">
                                                <div class="text-orange-500 text-base md:text-lg mb-1">🛡️</div>
                                                <div class="text-xs font-medium text-gray-700">服务稳定</div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="flex flex-col md:flex-row flex-wrap items-center md:items-center gap-3">
                                        <a
                                            href="https://share.302.AI/DymMSI"
                                            target="_blank"
                                            class="inline-flex items-center gap-2 bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 text-white text-sm px-6 py-3 rounded-lg transition-all duration-300 transform hover:scale-105 shadow-lg"
                                        >
                                            <span class="font-medium">访问 302.AI</span>
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path
                                                    stroke-linecap="round"
                                                    stroke-linejoin="round"
                                                    stroke-width="2"
                                                    d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                                                ></path>
                                            </svg>
                                        </a>
                                        <div class="text-xs text-gray-500 text-center md:text-left">
                                            <span class="inline-flex items-center gap-1">
                                                <div class="w-2 h-2 bg-green-400 rounded-full animate-pulse"></div>
                                                正在为本项目提供AI服务
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- <div class="bg-gradient-to-r from-gray-50 to-blue-50 border-2 border-gray-200 rounded-lg p-4">
                            <div class="flex items-center gap-3">
                                <div class="text-2xl">💡</div>
                                <div>
                                    <p class="text-sm font-medium text-gray-800">为什么选择 302.AI？</p>
                                    <p class="text-xs text-gray-600">本项目经过多家API服务商对比测试，302.AI 在稳定性、响应速度和成本控制方面表现优异，是我们的首选合作伙伴。</p>
                                </div>
                            </div>
                        </div> -->
                    </div>
                </div>
            </div>
            <!-- 关于项目 -->
            <div class="relative mt-6">
                <div class="bg-indigo-500 text-white px-4 py-2 rounded-t-lg border-2 border-[#0A0910] border-b-0 inline-block mb-0">
                    <span class="font-bold text-lg">👨‍💻 关于项目</span>
                </div>
                <div class="bg-white border-2 border-[#0A0910] rounded-lg rounded-tl-none p-4 md:p-6">
                    <div class="mt-4">
                        <div class="grid grid-cols-1 gap-6 items-center">
                            <div>
                                <div class="flex items-center gap-4 mb-4">
                                    <div class="w-16 h-16 bg-gradient-to-br from-indigo-400 to-purple-500 rounded-full flex items-center justify-center border-2 border-[#0A0910]">
                                        <span class="text-white text-2xl font-bold">味</span>
                                    </div>
                                    <div>
                                        <h3 class="text-xl font-bold text-dark-800">就美味助手</h3>
                                        <p class="text-gray-600 text-sm">AI 菜谱与做饭助手</p>
                                    </div>
                                </div>
                                <p class="text-gray-700 mb-4 text-sm leading-relaxed">
                                    基于开源菜谱项目整理而来，保留食材生成菜谱、随机推荐、酱料设计、收藏和图库等功能，并统一为“就美味助手”的应用体验。
                                </p>
                                <div class="space-y-3">
                                    <div class="flex items-center gap-3">
                                        <div class="w-8 h-8 bg-gray-800 rounded-lg flex items-center justify-center">
                                            <svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 24 24">
                                                <path
                                                    d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
                                                />
                                            </svg>
                                        </div>
                                        <div>
                                            <span class="text-sm font-medium text-gray-700">开源地址</span>
                                            <a href="https://github.com/wangmiao033/eat.hnchpower.cn" target="_blank" class="block text-blue-600 hover:text-blue-700 underline text-sm">
                                                github.com/wangmiao033/eat.hnchpower.cn
                                            </a>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-3">
                                        <div class="w-8 h-8 bg-gradient-to-br from-purple-500 to-pink-500 rounded-lg flex items-center justify-center">
                                            <span class="text-white text-sm font-bold">K</span>
                                        </div>
                                        <div>
                                            <span class="text-sm font-medium text-gray-700">技术栈</span>
                                            <p class="text-gray-600 text-sm">Vue 3、Vite、Tailwind CSS、微信小程序</p>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-3">
                                        <div class="w-8 h-8 bg-gradient-to-br from-purple-500 to-pink-500 rounded-lg flex items-center justify-center">
                                            <span class="text-white text-sm font-bold">AI</span>
                                        </div>
                                        <div>
                                            <span class="text-sm font-medium text-gray-700">当前仓库</span>
                                            <a
                                                href="https://github.com/wangmiao033/eat.hnchpower.cn"
                                                target="_blank"
                                                class="block text-blue-600 hover:text-blue-700 underline text-sm transition-colors"
                                            >
                                                github.com/wangmiao033/eat.hnchpower.cn
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 项目简介 -->
            <div class="relative">
                <div class="bg-blue-500 text-white px-4 py-2 rounded-t-lg border-2 border-[#0A0910] border-b-0 inline-block mb-0">
                    <span class="font-bold text-lg">🎯 项目简介</span>
                </div>
                <div class="bg-white border-2 border-[#0A0910] rounded-lg rounded-tl-none p-6">
                    <div class="mt-4">
                        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 items-center mb-8">
                            <div>
                                <h2 class="text-xl font-bold text-dark-800 mb-4">就美味助手 - AI菜谱与做饭助手</h2>
                                <p class="text-gray-700 text-sm mb-4 leading-relaxed">
                                    就美味助手面向日常家庭厨房：输入手边食材，选择菜系或口味要求，就能生成清楚可执行的菜谱。它也支持随机推荐、整桌菜单、酱料配方和菜品图库。
                                </p>
                                <div class="space-y-2">
                                    <div class="flex items-center gap-2">
                                        <span class="text-green-500">✓</span>
                                        <span class="text-sm">智能食材搭配推荐</span>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <span class="text-green-500">✓</span>
                                        <span class="text-sm">多菜系风格建议</span>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <span class="text-green-500">✓</span>
                                        <span class="text-sm">个性化烹饪方案</span>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <span class="text-green-500">✓</span>
                                        <span class="text-sm">详细步骤指导</span>
                                    </div>
                                </div>
                            </div>
                            <div class="text-center">
                                <div class="bg-gradient-to-br from-yellow-400 to-orange-500 rounded-lg p-8 border-2 border-[#0A0910]">
                                    <div class="text-6xl mb-4">🍳</div>
                                    <h3 class="text-xl font-bold text-white mb-2">就美味助手</h3>
                                    <p class="text-white text-sm">把手边食材变成一顿顺口好饭</p>
                                </div>
                            </div>
                        </div>

                        <!-- 平台特色 -->
                        <div>
                            <div class="flex items-center gap-2 mb-4">
                                <span class="text-2xl">✨</span>
                                <h3 class="text-xl font-bold text-dark-800">平台特色</h3>
                            </div>
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                <div class="text-center p-4 bg-gradient-to-br from-purple-50 to-pink-50 border-2 border-purple-200 rounded-lg">
                                    <div class="text-3xl mb-2">🤖</div>
                                    <h4 class="font-bold text-dark-800 mb-2 text-sm">AI智能推荐</h4>
                                    <p class="text-xs text-gray-600">基于食材智能匹配最适合的菜谱和烹饪方法</p>
                                </div>
                                <div class="text-center p-4 bg-gradient-to-br from-blue-50 to-cyan-50 border-2 border-blue-200 rounded-lg">
                                    <div class="text-3xl mb-2">👨‍🍳</div>
                                    <h4 class="font-bold text-dark-800 mb-2 text-sm">清晰步骤</h4>
                                    <p class="text-xs text-gray-600">把食材处理、火候、调味和摆盘拆成可执行步骤</p>
                                </div>
                                <div class="text-center p-4 bg-gradient-to-br from-green-50 to-emerald-50 border-2 border-green-200 rounded-lg">
                                    <div class="text-3xl mb-2">🎯</div>
                                    <h4 class="font-bold text-dark-800 mb-2 text-sm">个性化定制</h4>
                                    <p class="text-xs text-gray-600">根据个人口味偏好和饮食需求定制专属菜谱</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 菜系大全 -->
            <div class="relative">
                <div class="bg-gradient-to-r from-red-500 to-green-500 text-white px-4 py-2 rounded-t-lg border-2 border-[#0A0910] border-b-0 inline-block mb-0">
                    <span class="font-bold text-lg">👨‍🍳 主厨风格</span>
                </div>
                <div class="bg-white border-2 border-[#0A0910] rounded-lg rounded-tl-none p-6">
                    <div class="mt-4">
                        <!-- 中华八大菜系 -->
                        <div class="mb-8">
                            <div class="flex items-center gap-2 mb-4">
                                <span class="text-2xl">🇨🇳</span>
                                <h3 class="text-xl font-bold text-dark-800">中华八大菜系</h3>
                            </div>
                            <p class="text-gray-700 mb-4 text-sm">中华料理博大精深，八大菜系各具特色，代表了中国烹饪艺术的最高水准。</p>
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3">
                                <div
                                    v-for="cuisine in chineseCuisines"
                                    :key="cuisine.id"
                                    class="bg-gradient-to-br from-red-50 to-orange-50 border-2 border-red-200 rounded-lg p-3 hover:shadow-lg transition-all duration-200 transform hover:scale-105"
                                >
                                    <div class="text-center mb-2">
                                        <div class="text-2xl mb-1">{{ cuisine.avatar }}</div>
                                        <h4 class="font-bold text-dark-800 text-sm">{{ cuisine.name }}</h4>
                                    </div>
                                    <div class="space-y-1">
                                        <div class="text-xs text-gray-600"><span class="font-medium">特色：</span>{{ cuisine.specialty }}</div>
                                        <div class="text-xs text-gray-600"><span class="font-medium">代表菜：</span>{{ cuisine.dishes }}</div>
                                        <div class="text-xs text-gray-600"><span class="font-medium">口味：</span>{{ cuisine.flavor }}</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 国际菜系 -->
                        <div>
                            <div class="flex items-center gap-2 mb-4">
                                <span class="text-2xl">🌍</span>
                                <h3 class="text-xl font-bold text-dark-800">国际菜系</h3>
                            </div>
                            <p class="text-gray-700 mb-4 text-sm">融汇世界各地的经典料理，为您带来国际化的美食体验。</p>
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                                <div
                                    v-for="cuisine in internationalCuisines"
                                    :key="cuisine.id"
                                    class="bg-gradient-to-br from-green-50 to-blue-50 border-2 border-green-200 rounded-lg p-3 hover:shadow-lg transition-all duration-200 transform hover:scale-105"
                                >
                                    <div class="text-center mb-2">
                                        <div class="text-2xl mb-1">{{ cuisine.avatar }}</div>
                                        <h4 class="font-bold text-dark-800 text-sm">{{ cuisine.name }}</h4>
                                    </div>
                                    <div class="space-y-1">
                                        <div class="text-xs text-gray-600"><span class="font-medium">特色：</span>{{ cuisine.specialty }}</div>
                                        <div class="text-xs text-gray-600"><span class="font-medium">代表菜：</span>{{ cuisine.dishes }}</div>
                                        <div class="text-xs text-gray-600"><span class="font-medium">风格：</span>{{ cuisine.style }}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- 底部 -->
        <GlobalFooter />
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import GlobalNavigation from '@/components/GlobalNavigation.vue'
import GlobalFooter from '@/components/GlobalFooter.vue'

// 中华八大菜系数据
const chineseCuisines = ref([
    {
        id: 'sichuan',
        name: '川菜大师',
        avatar: '🌶️',
        specialty: '麻辣鲜香，口味浓重',
        dishes: '麻婆豆腐、宫保鸡丁、水煮鱼',
        flavor: '麻辣、鲜香、回甜'
    },
    {
        id: 'cantonese',
        name: '粤菜大师',
        avatar: '🦐',
        specialty: '清淡鲜美，注重原味',
        dishes: '白切鸡、蒸蛋羹、广式点心',
        flavor: '清淡、鲜美、嫩滑'
    },
    {
        id: 'shandong',
        name: '鲁菜大师',
        avatar: '🐟',
        specialty: '咸鲜为主，突出本味',
        dishes: '糖醋鲤鱼、九转大肠、葱爆海参',
        flavor: '咸鲜、醇厚、清香'
    },
    {
        id: 'jiangsu',
        name: '苏菜大师',
        avatar: '🦆',
        specialty: '清淡微甜，精工细作',
        dishes: '松鼠桂鱼、蟹粉狮子头、盐水鸭',
        flavor: '清淡、微甜、鲜美'
    },
    {
        id: 'zhejiang',
        name: '浙菜大师',
        avatar: '🐠',
        specialty: '清香嫩滑，鲜美爽口',
        dishes: '西湖醋鱼、龙井虾仁、东坡肉',
        flavor: '清香、嫩滑、鲜美'
    },
    {
        id: 'fujian',
        name: '闽菜大师',
        avatar: '🦀',
        specialty: '鲜香清淡，重汤轻油',
        dishes: '佛跳墙、荔枝肉、沙茶面',
        flavor: '鲜香、清淡、醇厚'
    },
    {
        id: 'hunan',
        name: '湘菜大师',
        avatar: '🌶️',
        specialty: '香辣鲜浓，口味厚重',
        dishes: '剁椒鱼头、麻辣子鸡、口味虾',
        flavor: '香辣、鲜浓、酸辣'
    },
    {
        id: 'anhui',
        name: '徽菜大师',
        avatar: '🐷',
        specialty: '重油重色，朴实醇厚',
        dishes: '红烧肉、毛豆腐、臭鳜鱼',
        flavor: '醇厚、鲜美、微甜'
    }
])

// 国际菜系数据
const internationalCuisines = ref([
    {
        id: 'japanese',
        name: '日式料理大师',
        avatar: '🍣',
        specialty: '新鲜食材，精致摆盘',
        dishes: '寿司、拉面、天妇罗',
        style: '清淡、精致、原味'
    },
    {
        id: 'korean',
        name: '韩式料理大师',
        avatar: '🥢',
        specialty: '发酵调味，营养均衡',
        dishes: '泡菜、烤肉、石锅拌饭',
        style: '酸辣、发酵、健康'
    },
    {
        id: 'thai',
        name: '泰式料理大师',
        avatar: '🌶️',
        specialty: '酸甜辣香，层次丰富',
        dishes: '冬阴功汤、绿咖喱、芒果糯米饭',
        style: '酸甜、香辣、清爽'
    },
    {
        id: 'italian',
        name: '意式料理大师',
        avatar: '🍝',
        specialty: '简单食材，经典搭配',
        dishes: '意大利面、披萨、提拉米苏',
        style: '简约、经典、浓郁'
    },
    {
        id: 'french',
        name: '法式料理大师',
        avatar: '🥖',
        specialty: '精致工艺，浪漫情调',
        dishes: '法式焗蜗牛、鹅肝、马卡龙',
        style: '精致、浪漫、优雅'
    },
    {
        id: 'american',
        name: '美式料理大师',
        avatar: '🍔',
        specialty: '分量丰富，口味浓郁',
        dishes: '汉堡、炸鸡、牛排',
        style: '丰富、浓郁、豪放'
    }
])
</script>

<style scoped>
@keyframes fade-in-up {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.animate-fade-in-up {
    animation: fade-in-up 0.6s ease-out forwards;
}
</style>
