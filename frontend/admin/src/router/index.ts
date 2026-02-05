import { createRouter, createWebHistory } from 'vue-router'
import UploadView from '../views/UploadView.vue'
import EditView from '../views/EditView.vue'
import LoginView from '../views/LoginView.vue'
import SigninView from '../views/SigninView.vue'
import { useAuth } from '../composables/useAuth'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'edit',
      component: EditView,
      meta: { requiresAdmin: true },
    },
    {
      path: '/upload',
      name: 'upload',
      component: UploadView,
      meta: { requiresAdmin: true },
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView,
    },
    {
      path: '/signin',
      name: 'signin',
      component: SigninView,
    },
  ],
})

// Guard de rutas para verificar si el usuario es admin
router.beforeEach(async (to, from, next) => {
  const { requiresAdmin } = to.meta

  if (requiresAdmin) {
    const { isAuthenticated } = useAuth()
    const isAdmin = await isAuthenticated()

    if (isAdmin) {
      next()
    } else {
      alert('Solo administradores pueden acceder a esta página')
      next('/login')
    }
  } else {
    next()
  }
})

export default router
