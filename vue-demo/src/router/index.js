import { createRouter, createWebHistory } from 'vue-router'
import App from '../App.vue'
import AppT from '../AppT.vue'
const routes = [
    // { path: "/", redirect: "/index" },
    {
        path: '/',
        name: 'App',
        component: App
    },
    {
        path: '/AppT',
        name: 'AppT',
        component: AppT
    }
]

const router = createRouter({
    //history模式：createWebHistory , hash模式：createWebHashHistory
    history: createWebHistory(),
    routes
})

export default router

