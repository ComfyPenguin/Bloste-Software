import { ref, onMounted, watch } from 'vue'

const isDark = ref(false)
const THEME_KEY = 'vueuse-color-scheme'

// Function to apply the theme to the HTML element
function applyTheme(dark: boolean) {
  if (dark) {
    document.documentElement.classList.add('dark')
  } else {
    document.documentElement.classList.remove('dark')
  }
}

export function useTheme() {
  onMounted(() => {
    // Read theme from localStorage on mount
    const storedTheme = localStorage.getItem(THEME_KEY)
    if (storedTheme === 'dark') {
      isDark.value = true
    } else if (storedTheme === 'light') {
      isDark.value = false
    } else {
      // If no stored theme, check prefers-color-scheme
      isDark.value = window.matchMedia('(prefers-color-scheme: dark)').matches
    }
    applyTheme(isDark.value)
  })

  // Watch for changes in isDark and apply theme
  watch(isDark, (newVal) => {
    applyTheme(newVal)
    localStorage.setItem(THEME_KEY, newVal ? 'dark' : 'light')
  })

  // Function to toggle the theme
  function toggleTheme() {
    isDark.value = !isDark.value
  }

  return {
    isDark,
    toggleTheme,
  }
}
