#!/bin/bash
set -e

# Directorio temporal para generar las claves (no montado como volumen)
TEMP_KEYS_DIR="/tmp/odoo-keys"
# Directorio destino (montado como volumen)
KEYS_DIR="/etc/odoo/keys"
PRIVATE_KEY="$KEYS_DIR/private.pem"
PUBLIC_KEY="$KEYS_DIR/public.pem"

# Verificar si las claves ya existen y tienen contenido
if [ -f "$PRIVATE_KEY" ] && [ -s "$PRIVATE_KEY" ] && [ -f "$PUBLIC_KEY" ] && [ -s "$PUBLIC_KEY" ]; then
    echo "Las claves JWT ya existen, saltando generaciÃ³n..."
else
    echo "Generando claves JWT RSA 4096..."
    
    # Crear directorio temporal
    mkdir -p "$TEMP_KEYS_DIR"
    
    # 1. Generar clave privada RSA 4096 en directorio temporal
    openssl genrsa -out "$TEMP_KEYS_DIR/private.pem" 4096
    echo "âœ“ Clave privada generada en directorio temporal"
    
    # 2. Generar clave pÃºblica desde la privada
    openssl rsa -in "$TEMP_KEYS_DIR/private.pem" -pubout -out "$TEMP_KEYS_DIR/public.pem"
    echo "âœ“ Clave pÃºblica generada en directorio temporal"
    
    # 3. Copiar claves al directorio final (volumen montado)
    cp "$TEMP_KEYS_DIR/private.pem" "$PRIVATE_KEY"
    cp "$TEMP_KEYS_DIR/public.pem" "$PUBLIC_KEY"
    echo "âœ“ Claves copiadas a $KEYS_DIR"
    
    # Establecer permisos apropiados
    chmod 600 "$PRIVATE_KEY"
    chmod 644 "$PUBLIC_KEY"
    
    # Limpiar directorio temporal
    rm -rf "$TEMP_KEYS_DIR"
    
    echo "âœ“ Claves JWT generadas exitosamente"
fi
