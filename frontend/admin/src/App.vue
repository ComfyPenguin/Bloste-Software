<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { RouterLink, RouterView, useRouter, useRoute } from 'vue-router'
import { useTheme } from './composables/useTheme'
import { authApi } from './api/auth.api'
import { handleError } from './middlewares/errorHandler'

// Importar los assets
import lightModeIcon from './assets/light_mode.svg'
import darkModeIcon from './assets/dark_mode.svg'
import logoLight from './assets/full_logo_black.png'
import logoDark from './assets/full_logo_white.png'

const { isDark, toggleTheme } = useTheme()
const router = useRouter()
const route = useRoute()
const userName = ref('Usuario')
const isMobileMenuOpen = ref(false)
const isLoggedIn = ref(false)

function toggleMobileMenu() {
  isMobileMenuOpen.value = !isMobileMenuOpen.value
}

// Función para refrescar el estado de autenticación y obtener la información del usuario
const refreshAuthState = async () => {
  const token = localStorage.getItem('authToken')
  console.log('Token from localStorage:', token)
  if (token) {
    isLoggedIn.value = true
    try {
      const userInfo = await authApi.getUserInfo(token)
      console.log('User info received:', userInfo)
      if (userInfo.name) {
        userName.value = userInfo.name
        console.log('Username set to:', userInfo.name)
      }
    } catch (error) {
      handleError(error, 'Error al obtener la información del usuario')
    }
  } else {
    isLoggedIn.value = false
    console.log('No token found in localStorage')
  }
}

// Refrescar el estado de autenticación al montar el componente
onMounted(async () => {
  await refreshAuthState()
})

// Refrescar el estado de autenticación cada vez que cambie la ruta
watch(
  () => route.fullPath,
  async () => {
    await refreshAuthState()
  },
)

// Función para cerrar sesión
const logout = () => {
  localStorage.removeItem('authToken')
  userName.value = 'Usuario'
  isLoggedIn.value = false
  router.push('/login')
}
</script>

<template>
  <header>
    <div class="wrapper">
      <div class="logo">
        <img :src="isDark ? logoDark : logoLight" alt="Bloste Software Logo" class="app-logo" />
      </div>

      <!-- Menú para escritorio -->
      <div class="desktop-menu">
        <nav class="main-nav" :class="{ 'nav-hidden': !isLoggedIn }">
          <RouterLink to="/">Editar Video</RouterLink>
          <RouterLink to="/upload">Subir Video</RouterLink>
        </nav>

        <div class="right-section">
          <button @click="toggleTheme" class="theme-toggle">
            <img
              :src="isDark ? lightModeIcon : darkModeIcon"
              alt="Toggle Theme"
              class="theme-icon"
            />
          </button>
          <span v-if="isLoggedIn" class="user-name">{{ userName }}</span>
          <button v-if="isLoggedIn" @click="logout" class="logout-button">Logout</button>
        </div>
      </div>

      <!-- Botón de hamburguesa para móvil -->
      <button @click="toggleMobileMenu" class="hamburger-button">
        <span class="hamburger-bar"></span>
        <span class="hamburger-bar"></span>
        <span class="hamburger-bar"></span>
      </button>
    </div>

    <!-- Menú desplegable para móvil -->
    <div v-if="isMobileMenuOpen" class="mobile-menu">
      <nav v-if="isLoggedIn" class="main-nav-mobile">
        <RouterLink to="/" @click="toggleMobileMenu">Editar Video</RouterLink>
        <RouterLink to="/upload" @click="toggleMobileMenu">Subir Video</RouterLink>
      </nav>

      <div class="right-section-mobile">
        <button @click="toggleTheme" class="theme-toggle">
          <img :src="isDark ? lightModeIcon : darkModeIcon" alt="Toggle Theme" class="theme-icon" />
        </button>
        <span v-if="isLoggedIn" class="user-name">{{ userName }}</span>
        <button v-if="isLoggedIn" @click="logout" class="logout-button">Logout</button>
      </div>
    </div>
  </header>

  <RouterView />
</template>

<style scoped>
header {
  line-height: 1.5;
  padding: 1rem;
  background-color: var(--color-background-soft);
  border-bottom: 1px solid var(--color-border);
  position: sticky; /* Changed from relative */
  top: 0; /* Ensures it sticks to the top */
  z-index: 100; /* Ensures it's above other content */
}

.wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1200px;
  margin: 0 auto;
}

.logo .app-logo {
  height: 30px;
  width: auto;
}

.desktop-menu {
  display: flex;
  align-items: center;
  gap: 2rem;
  flex-grow: 1; /* Ocupa el espacio disponible */
  justify-content: space-between;
  margin-left: 2rem;
}

.main-nav {
  display: flex;
  gap: 1rem;
}

.main-nav a {
  padding: 0.5rem 1rem;
  color: var(--color-text);
  text-decoration: none;
  border-bottom: 2px solid transparent;
}

.main-nav a:hover,
.main-nav a.router-link-exact-active {
  color: var(--color-primary);
  border-bottom-color: var(--color-primary);
}

.nav-hidden {
  visibility: hidden;
  pointer-events: none;
}

.right-section {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.theme-toggle {
  padding: 0.5rem;
  border: 1px solid var(--color-border);
  background-color: transparent;
  cursor: pointer;
  border-radius: 50%; /* Círculo */
  display: flex;
  justify-content: center;
  align-items: center;
}

.theme-icon {
  height: 20px;
  width: 20px;
  filter: var(--svg-filter);
}

.user-name {
  font-weight: bold;
  color: var(--color-text);
}

.logout-button {
  padding: 0.5rem 1rem;
  background-color: var(--color-primary);
  color: var(--color-background);
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
}

.logout-button:hover {
  filter: brightness(1.1);
}

/* Estilos para móvil */
.hamburger-button {
  display: none;
  flex-direction: column;
  gap: 4px;
  background: transparent;
  border: none;
  cursor: pointer;
}

.hamburger-bar {
  width: 25px;
  height: 3px;
  background-color: var(--color-text);
  border-radius: 2px;
}

.mobile-menu {
  display: none;
}

@media (max-width: 768px) {
  .desktop-menu {
    display: none;
  }

  .hamburger-button {
    display: flex;
  }

  .mobile-menu {
    display: block;
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background-color: var(--color-background-soft);
    border-bottom: 1px solid var(--color-border);
    padding: 1rem;
    z-index: 1000;
  }

  .main-nav-mobile {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    margin-bottom: 1rem;
  }

  .main-nav-mobile a {
    color: var(--color-text);
    text-decoration: none;
    padding: 0.5rem;
    border-radius: 4px;
  }

  .main-nav-mobile a:hover {
    background-color: var(--color-background-mute);
  }

  .right-section-mobile {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-top: 1px solid var(--color-border);
    padding-top: 1rem;
  }
}
</style>
