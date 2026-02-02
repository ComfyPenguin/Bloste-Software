# custom_auth_jwt

Módulo de **Odoo** que expone una **API REST** para autenticación basada en **JWT**, pensada para ser consumida por **frontends externos** (Vue, Flutter, web, móvil, etc.), sin depender del login tradicional de Odoo.

## Funcionalidades

El módulo proporciona los siguientes endpoints:

* **Registro de usuarios**
  Crea cuentas de tipo **Portal** desde un frontend externo.

* **Autenticación**
  Genera un **JWT** válido a partir de credenciales (`login + password`).

* **Validación de sesión**
  Obtiene los datos del usuario autenticado mediante JWT.

## Endpoints disponibles

| Método | Endpoint             | Descripción                           |
| ------ | -------------------- | ------------------------------------- |
| POST   | `/api/auth/register` | Crear cuenta de usuario (portal)      |
| POST   | `/api/auth/token`    | Generar token JWT                     |
| GET    | `/api/users/me`      | Obtener datos del usuario autenticado |

Todos los endpoints aceptan y devuelven **JSON**.

## Configuración requerida

En el archivo de configuración de Odoo (`odoo.conf`) se deben definir:

```ini
jwt_secret = super_secreta_y_segura
jwt_expiration = 3600
```

* `jwt_secret`: clave usada para firmar los tokens
* `jwt_expiration`: tiempo de validez del token (en segundos)

---

## Instalación de dependencias externas

> **Advertencia**
> No ejecutar `docker-compose down`, ya que elimina el contenedor y las librerías instaladas.
> En caso de hacerlo, las dependencias deberán instalarse nuevamente.

```bash
# Acceder al contenedor de Odoo
docker exec -it odoo_nova_media bash

# Ir a la ruta del módulo
cd /mnt/extra-addons/activos/propios/custom_auth_jwt/

# Instalar dependencias externas
pip3 install -r requirements.txt

# Salir del contenedor
exit
```

---

## Notas de diseño

* No se usa `type='json'` para evitar el formato JSON-RPC de Odoo.
* La API sigue un estilo **REST simple**.

## Problema con libreria en Odoo 16 base

Se necesita cryptography para las claves tipo algoritmo RS
<https://github.com/odoo/odoo/blob/16.0/requirements.txt#L5>

Odoo ya tiene intalado, si se llegará a instalar una, esta romperia otros que lo necesitarán.
