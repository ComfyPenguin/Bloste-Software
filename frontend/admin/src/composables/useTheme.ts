import { ref, onMounted, watch } from 'vue'

const isDark = ref(false)
const THEME_KEY = 'vueuse-color-scheme'

// Funcion para aplicar el tema oscuro o claro
function applyTheme(dark: boolean) {
  if (dark) {
    document.documentElement.classList.add('dark')
  } else {
    document.documentElement.classList.remove('dark')
  }
}

export function useTheme() {
  onMounted(() => {
    // Leer el tema almacenado en localStorage o usar la preferencia del sistema
    const storedTheme = localStorage.getItem(THEME_KEY)
    if (storedTheme === 'dark') {
      isDark.value = true
    } else if (storedTheme === 'light') {
      isDark.value = false
    } else {
      // Si no hay tema almacenado, usar la preferencia del sistema
      isDark.value = window.matchMedia('(prefers-color-scheme: dark)').matches
    }
    applyTheme(isDark.value)
  })

  // Observar cambios en isDark y aplicar el tema
  watch(isDark, (newVal) => {
    applyTheme(newVal)
    localStorage.setItem(THEME_KEY, newVal ? 'dark' : 'light')
  })

  // Funcion para alternar el tema
  function toggleTheme() {
    isDark.value = !isDark.value
  }

  return {
    isDark,
    toggleTheme,
  }
}
