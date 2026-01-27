import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/UploadView.vue'
// import EditView from '../views/EditView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
    },
    // {
    //   path: '/edit',
    //   name: 'edit',
    //   component: EditView,
    // },
  ],
})

export default router
