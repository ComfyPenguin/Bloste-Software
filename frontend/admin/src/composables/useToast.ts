import { useToast as useVueToast } from 'vue-toastification'

export const useToast = () => {
  const toast = useVueToast()

  const success = (message: string) => {
    toast.success(message)
  }

  const error = (message: string) => {
    toast.error(message)
  }

  const info = (message: string) => {
    toast.info(message)
  }

  const warning = (message: string) => {
    toast.warning(message)
  }

  return {
    success,
    error,
    info,
    warning
  }
}
