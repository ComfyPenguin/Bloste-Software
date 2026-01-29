CREATE IF NOT EXISTS DATABASE BD_Odoo;

USE DATABASE BD_Odoo;

CREATE IF NOT EXISTS TABLE usuaris (
    id SERIAL PRIMARY KEY,
    nombre_usuari VARCHAR(50) NOT NULL,
    apellidos_usuari VARCHAR(150) NOT NULL,
    email_usuari VARCHAR(100) NOT NULL UNIQUE,
    passord_hash VARCHAR(300) NOT NULL,
    data_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE IF NOT EXISTS TABLE rols (
    id SERIAL PRIMARY KEY,
    tipo ENUM ('Administrador', 'Usuario', 'SuperAdministrador') NOT NULL,
);

CREATE IF NOT EXISTS TABLE usuari_rol (
    id SERIAL PRIMARY KEY,
    usuari_id INTEGER NOT NULL REFERENCES usuaris(id) ON DELETE CASCADE,
    rol_id INTEGER NOT NULL REFERENCES rols(id) ON DELETE CASCADE,
    UNIQUE (usuari_id, rol_id)
);

CREATE IF NOT EXISTS TABLE planes_suscripcion (
    id              SERIAL PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    descripcion     TEXT,
    precio_mensual  NUMERIC(10,2) NOT NULL,
    activo          BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE IF NOT EXISTS TABLE suscripciones (
    id                  SERIAL PRIMARY KEY,
    usuario_id          INTEGER NOT NULL REFERENCES usuaris(id) ON DELETE CASCADE,
    plan_id             INTEGER NOT NULL REFERENCES planes_suscripcion(id),
    fecha_contratacion  TIMESTAMP NOT NULL DEFAULT NOW(),
    fecha_cancelacion   TIMESTAMP,
    estado              VARCHAR(20) NOT NULL DEFAULT 'activa' -- 'activa', 'cancelada', etc.
);
