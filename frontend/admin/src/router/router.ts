import { createRouter, createWebHistory } from 'vue-router'
import UploadView from '../views/UploadView.vue'
import EditView from '../views/EditView.vue'
import LoginView from '../views/LoginView.vue'
import SigninView from '../views/SigninView.vue'
import { useAuth } from '../composables/useAuth'
import { useToast } from 'vue-toastification'

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
      meta: { requiresGuest: true },
    },
    {
      path: '/signin',
      name: 'signin',
      component: SigninView,
      meta: { requiresGuest: true },
    },
  ],
})

// Guard de rutas para verificar si el usuario es admin
router.beforeEach(async (to, from, next) => {
  const { requiresAdmin, requiresGuest } = to.meta
  const { isAuthenticated } = useAuth()
  const isAdmin = await isAuthenticated()
  const toast = useToast()

  // Si la ruta requiere ser invitado y el usuario es admin, redirigir al home
  if (requiresGuest && isAdmin) {
    next('/')
    return
  }

  // Si la ruta requiere ser admin, verificar el estado de autenticación
  if (requiresAdmin) {
    if (isAdmin) {
      next()
    } else {
      next('/login')
      toast.error('Solo los administradores tienen acceso a esa dirección')
    }
  } else {
    next()
  }
})

export default router
