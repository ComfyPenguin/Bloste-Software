<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { authApi } from '@/api/auth.api'
import { useToast } from 'vue-toastification'
import { useAuth } from '@/composables/useAuth'
import { handleError } from '@/middlewares/errorHandler'

const toast = useToast()
const email = ref('')
const password = ref('')
const router = useRouter()
const { checkAdminStatus } = useAuth()

// Función para manejar el inicio de sesión
const login = async () => {
  try {
    const response = await authApi.login({ login: email.value, password: password.value })

    if (response.access_token) {
      localStorage.setItem('authToken', response.access_token)
      console.log('Access token almacenado:', response.access_token)
      if (response.refresh_token) {
        localStorage.setItem('refreshToken', response.refresh_token)
      }

      // Verificar si es admin
      const isAdmin = await checkAdminStatus(response.access_token)

      if (isAdmin) {
        toast.success('Inicio de sesión exitoso, bienvenido!')
        router.push('/') // Redireccionar a la página principal después del login
      } else {
        localStorage.removeItem('authToken')
        localStorage.removeItem('refreshToken')
        toast.error('Solo administradores pueden acceder a esta aplicación')
        email.value = ''
        password.value = ''
      }
    } else {
      toast.error('Login fallido: Token no recibido')
    }
  } catch (error: unknown) {
    toast.error(handleError(error, 'Error al iniciar sesión'))
  }
}
</script>

<template>
  <div class="login-container">
    <form @submit.prevent="login" class="login-form">
      <h2>Iniciar sesión</h2>
      <div class="form-group">
        <label for="email">Email:</label>
        <input type="text" id="email" v-model="email" required />
      </div>
      <div class="form-group">
        <label for="password">Contraseña:</label>
        <input type="password" id="password" v-model="password" required />
      </div>
      <button type="submit">Iniciar sesión</button>
      <div class="register-link">
        <p>¿No tienes cuenta? <router-link to="/signin">Regístrate aquí</router-link></p>
      </div>
    </form>
  </div>
</template>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 80vh; /* Changed from min-height */
  overflow: auto; /* Added for controlled scrolling */
  background-color: var(--color-background);
  padding: 1rem;
}

.login-form {
  background: var(--color-background-soft);
  padding: 40px;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
  text-align: center;
  border: 1px solid var(--color-border);
}

h2 {
  margin-bottom: 24px;
  color: var(--color-heading);
}

.form-group {
  margin-bottom: 20px;
  text-align: left;
}

label {
  display: block;
  margin-bottom: 8px;
  color: var(--color-text);
  font-weight: bold;
}

input[type='text'],
input[type='email'],
input[type='password'] {
  width: 100%;
  padding: 10px;
  border: 1px solid var(--color-border);
  border-radius: 4px;
  box-sizing: border-box;
  font-size: 1rem;
  background-color: var(--color-background-mute);
  color: var(--color-text);
}

input[type='text']:focus,
input[type='email']:focus,
input[type='password']:focus {
  outline: none;
  border-color: var(--color-primary);
}

button {
  width: 100%;
  padding: 12px;
  background-color: var(--color-primary);
  color: var(--color-background);
  border: none;
  border-radius: 4px;
  font-size: 1.1rem;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

button:hover {
  filter: brightness(1.1);
}

.register-link {
  margin-top: 20px;
  text-align: center;
}

.register-link p {
  color: var(--color-text);
  font-size: 0.95rem;
}

.register-link a {
  color: var(--color-primary);
  text-decoration: none;
  font-weight: bold;
}

.register-link a:hover {
  text-decoration: underline;
}

/* Media query for mobile devices */
@media (max-width: 768px) {
  .login-container {
    align-items: flex-start;
    padding-top: 1rem; /* Changed from 5vh */
  }

  .login-form {
    padding: 20px;
    border: 1px solid var(--color-border); /* Keep the border on mobile */
    box-shadow: none;
  }
}

/* Media query for when keyboard is open */
@media (max-height: 500px) {
  .login-container {
    padding-top: 1rem;
  }

  h2 {
    margin-bottom: 1rem;
  }

  .form-group {
    margin-bottom: 0.5rem;
  }
}
</style>
