# 🍳 YiFan FengShen (One Meal to Godhood)

> 🚀 **Vibe Coding**  
> Through the Kiro editor, the full process development from requirements analysis, architecture design to code implementation is realized.
> English | [中文](./README.md)

An AI-powered intelligent recipe generation platform supporting Chinese Eight Great Cuisines + International Cuisine, providing nutritional analysis, wine pairing, recipe image generation, and comprehensive cooking guidance.

[![Live Demo](https://img.shields.io/badge/🌐_Live_Demo-Jiu_Meiwei_Assistant-yellow?style=for-the-badge)](https://eat.hnchpower.cn/)
[![Vercel](https://img.shields.io/badge/🚀_Vercel-eat.hnchpower.cn-black?style=for-the-badge&logo=vercel)](https://eat.hnchpower.cn/)
[![GitHub](https://img.shields.io/badge/GitHub-wangmiao033/eat.hnchpower.cn-black?style=for-the-badge&logo=github)](https://github.com/wangmiao033/eat.hnchpower.cn)

## 🚀 Core Features

-   **Smart Recipe Generation** - Generate professional recipes based on ingredients and cuisine preferences
-   **Nutritional Analysis** - Detailed nutritional breakdown and health scoring
-   **AI Food Images** - One-click generation of beautiful dish images
-   **Wine Pairing** - Professional sommelier recommendations
-   **Sauce Designer** - Customized seasoning formulas
-   **Favorites Management** - Save and manage favorite recipes
-   **Culinary Fortune** - Fun food fortune telling

## 🛠️ Tech Stack

-   **Frontend Framework:** Vue 3.4 + Composition API + TypeScript 5.3+
-   **Styling:** Tailwind CSS 3.4+
-   **Build Tool:** Vite 5.0+
-   **AI Services:** 302.AI
-   **Deployment:** Vercel + Netlify

## 🚀 Quick Start

### Requirements

-   Node.js 18+

### Local Development

```bash
# Clone the project
git clone https://github.com/wangmiao033/eat.hnchpower.cn.git
cd eat.hnchpower.cn

# Install dependencies
npm install

# Configure environment variables
cp .env.example .env
# Edit .env file and add your AI API keys

# Start development server
npm run dev
```

### Build & Deploy

```bash
# Type check + build
npm run build

# Netlify build
npm run build:netlify

# Preview build
npm run preview
```

## 🚀 One-Click Deploy

### Deploy to Vercel

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/wangmiao033/eat.hnchpower.cn&env=VITE_TEXT_GENERATION_BASE_URL,VITE_TEXT_GENERATION_API_KEY,VITE_TEXT_GENERATION_MODEL,VITE_IMAGE_GENERATION_BASE_URL,VITE_IMAGE_GENERATION_API_KEY,VITE_IMAGE_GENERATION_MODEL&envDescription=AI%20API%20Configuration&envLink=https://github.com/wangmiao033/eat.hnchpower.cn%23environment-variables)

### Deploy to Netlify

[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/wangmiao033/eat.hnchpower.cn)

> 📖 For detailed deployment guide, see: [DEPLOYMENT.md](./DEPLOYMENT.md)

### Environment Variables

#### You can switch any request address and model that complies with the OpenAI standard

> **🚀 Recommended Provider**: This project recommends using [302.AI](https://share.302.AI/DymMSI) AI API services - stable, reliable, supports multiple mainstream large models, and cost-effective!

```env
# Text Generation API (lingyiwanwu.AI)
VITE_TEXT_GENERATION_BASE_URL=https://api.302ai.cn/v1/
VITE_TEXT_GENERATION_API_KEY=************
VITE_TEXT_GENERATION_MODEL=doubao-1.5-pro-32k
VITE_TEXT_GENERATION_TEMPERATURE=0.7
VITE_TEXT_GENERATION_TIMEOUT=300000

# Image Generation API (Zhipu AI)
VITE_IMAGE_GENERATION_BASE_URL=https://open.bigmodel.cn/api/paas/v4/images/generations
VITE_IMAGE_GENERATION_API_KEY=******************
VITE_IMAGE_GENERATION_MODEL=cogview-3-flash
```

## 📁 Project Structure

```
src/
├── components/          # Reusable components
│   ├── ConfirmModal.vue      # Confirmation dialog
│   ├── CookingLoader.vue     # Cooking animation loader
│   ├── FavoriteButton.vue    # Favorite button
│   ├── GlobalNavigation.vue  # Global navigation
│   ├── RecipeCard.vue        # Recipe card
│   ├── NutritionAnalysis.vue # Nutrition analysis
│   └── ...
├── config/              # Configuration files
│   ├── ai.ts                 # AI model configuration
│   ├── cuisines.ts           # Cuisine configuration
│   ├── ingredients.ts        # Ingredients configuration
│   └── ...
├── services/            # Service layer
│   ├── aiService.ts          # AI API service
│   ├── favoriteService.ts    # Favorites service
│   ├── imageService.ts       # Image service
│   └── ...
├── views/               # Page components
│   ├── Home.vue              # Home page
│   ├── Favorites.vue         # Favorites page
│   ├── SauceDesign.vue       # Sauce designer
│   └── ...
├── types/               # TypeScript type definitions
├── utils/               # Utility functions
└── router/              # Router configuration
```

## 🎯 Development Guide

### Adding New Cuisines

1. Add cuisine configuration in `src/config/cuisines.ts`
2. Write professional AI prompts for cuisine masters
3. Add corresponding icons and descriptions

### Extending Functionality

1. Create new page components in `src/views/`
2. Add route configuration in `src/router/`
3. Add navigation entry in navigation component

### AI Service Integration

-   Text Generation: `src/services/aiService.ts`
-   Image Generation: `src/services/imageService.ts`
-   Support for multiple AI service providers

## 📈 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=wangmiao033/eat.hnchpower.cn&type=Date)](https://www.star-history.com/#wangmiao033/eat.hnchpower.cn&Date)

## 🙏 Acknowledgments

-   [Vue.js](https://vuejs.org/) - Progressive JavaScript framework
-   [Tailwind CSS](https://tailwindcss.com/) - Utility-first CSS framework
-   [302.AI](https://share.302.AI/DymMSI) - **Official Partner** 🚀 Providing stable and reliable AI API services for this project
-   [01.AI](https://www.lingyiwanwu.com/) - Recipe generation API
-   [Zhipu AI](https://open.bigmodel.cn/) - Image generation API
