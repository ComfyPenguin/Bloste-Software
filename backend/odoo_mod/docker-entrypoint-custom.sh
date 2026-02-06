#!/bin/bash
set -e

PUBLIC_KEY_FILE="/etc/odoo/keys/public.pem"

# Generar claves si no existen
/usr/local/bin/generate-jwt-keys.sh

# Verificar que la clave pÃºblica tenga contenido
if [ ! -s "$PUBLIC_KEY_FILE" ]; then
    echo "âš  Error: La clave pÃºblica estÃ¡ vacÃ­a. No se exportarÃ¡."
    exec "$@"
    exit 0
fi

# Exportar clave pÃºblica a mÃºltiples carpetas del proyecto
echo "Exportando clave pÃºblica a las carpetas keys..."

# Lista de destinos (excluye Odoo_mod/keys porque el volumen ya mapea /etc/odoo/keys)
DESTINATIONS=(
    "/workspace/backend/media_server/src/keys/public.pem"
    "/workspace/backend/catalogo/src/main/resources/keys/public.pem"
    "/workspace/frontend/admin/src/keys/public.pem"
    "/workspace/frontend/blosteflix2/keys/public.pem"
)

# Crear directorios si no existen y copiar la clave pÃºblica
for DEST in "${DESTINATIONS[@]}"; do
    DEST_DIR=$(dirname "$DEST")
    mkdir -p "$DEST_DIR"
    # Eliminar el archivo destino si existe y estÃ¡ vacÃ­o
    if [ -f "$DEST" ] && [ ! -s "$DEST" ]; then
        rm -f "$DEST"
    fi
    # Copiar la clave
    cp "$PUBLIC_KEY_FILE" "$DEST"
    # Verificar que se copiÃ³ correctamente
    if [ -s "$DEST" ]; then
        echo "âœ“ Clave pÃºblica copiada a: $DEST"
    else
        echo "âœ— Error al copiar a: $DEST"
    fi
done

echo "âœ“ La clave en Odoo_mod/keys/public.pem ya estÃ¡ disponible (volumen montado)"
echo "âœ“ Proceso de exportaciÃ³n completado"

# Ejecutar el comando original de Odoo
exec "$@"


