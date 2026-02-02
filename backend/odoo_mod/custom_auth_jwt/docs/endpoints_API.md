# Endpoints API – custom_auth_jwt

Todos los endpoints expuestos por este módulo siguen un **estilo REST** y **NO usan JSON-RPC**.

> **Importante**
> No usar el formato JSON-RPC estándar de Odoo (`jsonrpc`, `method`, `params`), ya que estos endpoints están pensados para **frontends externos**.

## Formato NO soportado (JSON-RPC de Odoo)

No usar este formato:

```bash
curl --location 'http://localhost:8069/api/auth/token' \
--header 'Content-Type: application/json' \
--data-raw '{
  "jsonrpc": "2.0",
  "method": "call",
  "params": {
    "login": "a@a.a",
    "password": "1234"
  },
  "id": 1
}'
```

Motivo:

* Acopla el frontend a Odoo

---

## Formato correcto (REST + JSON)

### Autenticación – `/api/auth/token`

Genera un **JWT** a partir de credenciales válidas.

**Método:** `POST`
**Content-Type:** `application/json`

```bash
curl --location 'http://localhost:8069/api/auth/token' \
--header 'Content-Type: application/json' \
--data-raw '{
  "login": "c1@a.a",
  "password": "1234"
}'
```

**Respuesta (200):**

```json
{
    "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyIiwibG9naW4iOiJhQGEuYSIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTc2OTUwMjYxMSwiZXhwIjoxNzY5NTA2MjExLCJ0eXBlIjoiYWNjZXNzIn0.ZDrQW--DuGcQoKViJAWOYpg1tDBOhH3_OL98Rno9GcKTe80casnKrEELS_EwABrwTu9Qu4grBOsRlsN9KqzQm0OjvnElxstUYvtKz4ckm7SHdUeh-cTHHSQI2Gn6cYvm4mFA4bZA7p8jQojFYtlqOrNE22eFyz_zffEuUB7QWqx5FnBhd721wA1sSHv_QextQXnmmXV_vZ3mlIuh80NZwfs8-rIfNSZq6i2OVGiybwqqNB_0i5I4WeGC-tOlWFFZAG9Sz4mON_KdR39rZ3AQh4NJSp3puyXfzmeJjia6vJjw6h0r2NBcSHwrzfYEwUkQveFXtl8iLT5wf80xwnbJ-A",
    "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyIiwibG9naW4iOiJhQGEuYSIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTc2OTUwMjYxMSwiZXhwIjoxNzcwMTA3NDExLCJ0eXBlIjoicmVmcmVzaCJ9.qmTg14G2obbMZLBB3eh2F6uzMwJshIfFoaUYJdgSgmqcDWwQv4sXP034dugpyYAnJBJMdeQEPItw9gb7lQQb6kTEczCVwwg7rxYFsAUWjQTs5NMtOzeD2Oxr_bKzYT5MRJRLaN5Pm81ToQ4ZJsZPvMebG_VkP_F6_srYrhqJXuCETKhvi1oVgdp14lPQygcb6sxuXNQ4x0MJ9XjE3vS0fTIXri4oDLphxqd7QDs3pugVh1cfhOxGo_0Gqdt-_UnIOrAv4r5hx7YL315MC9QWGwaqk_Gwd1HH8t6ADRDqkDMIwhI-ld8UhDjFMKddykU0bmEcqzRS7FNWQMKF8wdtUg",
    "token_type": "Bearer",
    "expires_in": 3600
}
```

Desencriptado

```json
{
  "sub": "6",
  "login": "c1@a.a",
  "role": "user",
  "iat": 1769079119,
  "exp": 1769082719
}
```

---

### Usuario autenticado – `/api/users/me`

Devuelve los datos del usuario asociado al JWT enviado.

**Método:** `GET`
**Requiere autenticación:** Sí (Bearer Token)

```bash
curl -X GET "http://localhost:8069/api/users/me" \
  -H "Authorization: Bearer <jwt_access_token>" \
  -H "Accept: application/json"
```

**Respuesta (200) Obligado `jwt_access_token`:**

```json
{
  "id": 2,
  "name": "Cuenta Demo",
  "email": "cuenta1@a.a",
  "partner_id": 5
}
```

**Respuesta (401):**

```json
{
  "error": "Unauthorized",
  "details": "Token inválido o expirado."
}
```

---

### Uso en Postman

Se puede configurar de **dos formas equivalentes**:

**Opción 1 – Authorization**:

* Authorization → Type: `Bearer Token`
* Token: `<jwt_token>`

**Opción 2 – Headers**:

* Key: `Authorization`
* Value: `Bearer <jwt_token>`

---

### Registro de usuario – `/api/auth/register`

Crea una nueva cuenta de usuario **tipo Portal**.

**Método:** `POST`
**Content-Type:** `application/json`

```bash
curl --location 'http://localhost:8069/api/auth/register' \
--header 'Content-Type: application/json' \
--data-raw '{
  "name": "cuenta3",
  "login": "c3@a.a",
  "password": "1234"
}'
```

**Respuesta (201):**

```json
{
    "token": "<jwt_token>",
    "token_type": "Bearer",
    "expires_in": 3600
}
```

---

### Registro de usuario – `/api/auth/refresh`

Crea una nueva cuenta de usuario **tipo Portal**.

**Método:** `POST`
**Content-Type:** `application/json`

```bash
curl --location 'http://localhost:8069/api/auth/refresh' \
--header 'Content-Type: application/json' \
--data-raw '{
  "refresh_token": "<TOKEN_REFRESH>"
}'
```

**Respuesta (201):**

```json
{
    "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyIiwibG9naW4iOiJhQGEuYSIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTc2OTU2Mjc1NywiZXhwIjoxNzY5NTY2MzU3LCJ0eXBlIjoiYWNjZXNzIn0.MZ3IFkW-TgVRkoJbwWIYPQOGYn8zHQanI2ON44iGltTt9kYVy0LWXEOn8IMfxRp4OHvkhZ0YOPFnMtosgex_0mLGVgsAdmbF8jTAh4Cz2nwpYq6tkO2xmzBC2n0ccJCGcm_cFnST2GgI-AXx_aRgyX7vLLiHsBm_1VSzuxm4jd7vAwYIOCh7CP3IBueNo9aWQYKLWXobM4ahym8K9CTOa3MSKBeXH3H5halgDup9XJhE98RZ_Ahv2oB4fF5QUsltBV3HqqzxyrVeIkSr0n2aJzULWSrX1YVdKRRrmq5mG9v_KBZatdV_RUDfjl7gHV9oFnsWcvNnSitxlAG_FOtGfg",
    "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyIiwibG9naW4iOiJhQGEuYSIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTc2OTU2MTkxNSwiZXhwIjoxNzcwMTY2NzE1LCJ0eXBlIjoicmVmcmVzaCJ9.GVnBXopEjFyfPHZ8VFLxTESl8BdU_COjiEDlSwK05kCuRb9Z0oPY9hW5CK_1T8x_OanMp-uRLl4G-EJ_3E_oFH6b3Gq2kt96zJLnPWFhDC_IASMF8oUOfsJZ3MAgVr_faEArKUMM3A_vX9h9GQKz4hhcXlo6jljnRiwWckMXNSbhxTKlSKIWAPN0ValGUK9bD0lPYfh0rOuuHDY_3S9D20yd6fg-fEvq4cYAm2ON30oRks7uleQAHpl_ku0d0wgNeFXuz8Qtey51v5Rt-Q3gt2C3eA9SM9y-ZYxA08oO_GOSFQxnqOy8up_8AVXVo-pwUJ4kUfr6pq51cNUkFdQBgA",
    "token_type": "Bearer",
    "expires_in": 3600
}
```

**Respuesta (401):**

```json
{
  "error": "Invalid or expired refresh token"
}
```

---

## Base de datos PostgreSQL

buscar la tabla `auth_refresh_token`

```postgresql
SELECT * FROM public.auth_refresh_token
ORDER BY id ASC 
```

```bash
"id","user_id","create_uid","write_uid","token_hash","is_revoked","expiration_date","issued_at","create_date","write_date"
2,2,1,1,"c8cba9566e510bc789399eef7012c84770d0373c5c21f8a5fc09c51cde581f87",False,"2026-02-03 02:19:15.220108","2026-01-27 02:19:15.220108","2026-01-27 02:19:15.220675","2026-01-27 02:19:15.220675"
13,2,1,1,"2adc624737916f24766005f34199c90218257f60982e841e606f1d30c57555f9",False,"2026-02-04 00:58:29.597253","2026-01-28 00:58:29.597253","2026-01-28 00:58:29.589885","2026-01-28 00:58:29.589885"
14,2,1,1,"5db2b489a4abd927779605ae90bc678ce3fd5caca93deb74c3fd186cc3294d44",False,"2026-02-04 00:58:35.634362","2026-01-28 00:58:35.634362","2026-01-28 00:58:35.63486","2026-01-28 00:58:35.63486"

```

## Consideraciones importantes

* El registro **no inicia sesión automáticamente**
* El frontend debe:

  1. Registrar usuario
  2. Autenticar con `/api/auth/token`
  3. Guardar el JWT

* El control de sesión es **100% responsabilidad del frontend**
* No se crean cookies ni sesiones de Odoo
* Es posible que se crea `cookies` pero es parte de Odoo interno. Para los demás, es 'ruido'.
