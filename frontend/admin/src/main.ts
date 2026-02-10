import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'
import router from './router/router'
import Toast from 'vue-toastification'
import 'vue-toastification/dist/index.css'

const app = createApp(App)

// Configuración del router
app.use(router)

// Configuración del plugin de notificaciones Toastification
app.use(Toast, {
  position: 'top-right',
  timeout: 5000,
  closeOnClick: true,
  pauseOnFocusLoss: false,
  pauseOnHover: true,
  draggable: false,
  draggablePercent: 0.6,
  showCloseButtonOnHover: false,
  hideProgressBar: true,
  closeButton: false,
  icon: true,
  rtl: false,
  transition: 'Vue-Toastification__fade',
  maxToasts: 10,
  newestOnTop: true,
  filterToasts: (toasts: any[]) => {
    // Keep track of existing types
    const types: Record<string, boolean> = {}
    return toasts.reduce((aggToasts, toast) => {
      // Check if type was not seen before
      if (!types[toast.type]) {
        aggToasts.push(toast)
        types[toast.type] = true
      }
      return aggToasts
    }, [])
  },
})

app.mount('#app')
