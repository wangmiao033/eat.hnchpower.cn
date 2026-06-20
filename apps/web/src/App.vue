<template>
    <div id="app" class="min-h-screen">
        <router-view />
        <GlobalNoticeModal />
    </div>
</template>

<script setup>
// App组件
import GlobalNoticeModal from './components/GlobalNoticeModal.vue'
</script>
