export class Formatter {
  // Helper para formatear duración en segundos a HH:MM:SS o MM:SS
  static durationTime(seconds: number): string {
    if (isNaN(seconds)) return '00:00'
    const h = Math.floor(seconds / 3600)
    const m = Math.floor((seconds % 3600) / 60)
    const s = Math.floor(seconds % 60)
    const parts = [m.toString().padStart(2, '0'), s.toString().padStart(2, '0')]
    if (h > 0) {
      parts.unshift(h.toString().padStart(2, '0'))
    }
    return parts.join(':')
  }

  // Helper para formatear bytes a una cadena legible
  static bytes(bytes: number, decimals = 2): string {
    if (bytes === 0) return '0 Bytes'
    const k = 1024
    const dm = decimals < 0 ? 0 : decimals
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB']
    const i = Math.floor(Math.log(bytes) / Math.log(k))
    return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i]
  }

  // Helper para mostrar tiempo transcurrido en formato legible desde la subida
  static timeAgo(dateString: string): string {
    const date = new Date(dateString)
    const now = new Date()
    const seconds = Math.floor((now.getTime() - date.getTime()) / 1000)

    if (seconds < 5) {
      return 'justo ahora'
    }

    let interval = seconds / 31536000 // years
    if (interval > 1) {
      const years = Math.floor(interval)
      return `hace ${years} ${years === 1 ? 'año' : 'años'}`
    }
    interval = seconds / 2592000 // months
    if (interval > 1) {
      const months = Math.floor(interval)
      return `hace ${months} ${months === 1 ? 'mes' : 'meses'}`
    }
    interval = seconds / 86400 // days
    if (interval > 1) {
      const days = Math.floor(interval)
      return `hace ${days} ${days === 1 ? 'día' : 'días'}`
    }
    interval = seconds / 3600 // hours
    if (interval > 1) {
      const hours = Math.floor(interval)
      return `hace ${hours} ${hours === 1 ? 'hora' : 'horas'}`
    }
    interval = seconds / 60 // minutes
    if (interval > 1) {
      const minutes = Math.floor(interval)
      return `hace ${minutes} ${minutes === 1 ? 'minuto' : 'minutos'}`
    }
    const secs = Math.floor(seconds)
    return `hace ${secs} ${secs === 1 ? 'segundo' : 'segundos'}`
  }
}
