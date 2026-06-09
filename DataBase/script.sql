CREATE TABLE users_persona (
    id SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    primer_apellido VARCHAR(100) NOT NULL,
    segundo_apellido VARCHAR(100),
    ci VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero VARCHAR(50) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    telefono_fijo VARCHAR(50) DEFAULT '0' NOT NULL,
    celular VARCHAR(50) NOT NULL,
    complemento_ci VARCHAR(50),
    correo_electronico VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE users_usuario (
    id SERIAL PRIMARY KEY,
    password VARCHAR(128) NOT NULL,
    last_login TIMESTAMP WITH TIME ZONE,
    is_superuser BOOLEAN NOT NULL,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    is_active BOOLEAN NOT NULL,
    is_staff BOOLEAN NOT NULL,
    persona_id INTEGER UNIQUE REFERENCES users_persona(id) ON DELETE CASCADE
);

CREATE TABLE users_lugar (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion VARCHAR(500) NOT NULL,
    provincia VARCHAR(100) NOT NULL,
    municipio VARCHAR(100) NOT NULL,
    departamento VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(300) NOT NULL,
    latitud NUMERIC(50, 15) NOT NULL,
    longitud NUMERIC(50, 15) NOT NULL,
    url VARCHAR(300) NOT NULL
);

CREATE TABLE users_horario (
    id SERIAL PRIMARY KEY,
    dia VARCHAR(50) NOT NULL,
    apertura TIME NOT NULL,
    cierre TIME NOT NULL,
    lugar_id INTEGER REFERENCES users_lugar(id) ON DELETE CASCADE
);

CREATE TABLE users_comentario (
    id SERIAL PRIMARY KEY,
    comentario VARCHAR(500) NOT NULL,
    calificacion INTEGER NOT NULL,
    fecha DATE NOT NULL,
    lugar_id INTEGER REFERENCES users_lugar(id) ON DELETE CASCADE,
    persona_id INTEGER REFERENCES users_persona(id) ON DELETE CASCADE,
    recomentario_id INTEGER REFERENCES users_comentario(id) ON DELETE CASCADE
);

CREATE TABLE users_foto (
    id SERIAL PRIMARY KEY,
    url VARCHAR(300) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    comentario_id INTEGER REFERENCES users_comentario(id) ON DELETE CASCADE,
    lugar_id INTEGER REFERENCES users_lugar(id) ON DELETE CASCADE
);

CREATE TABLE users_funcionalidad (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE users_rol (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE users_rol_privilegios (
    id SERIAL PRIMARY KEY,
    rol_id INTEGER REFERENCES users_rol(id) ON DELETE CASCADE,
    funcionalidad_id INTEGER REFERENCES users_funcionalidad(id) ON DELETE CASCADE,
    UNIQUE (rol_id, funcionalidad_id)
);

CREATE TABLE users_cuenta (
    id SERIAL PRIMARY KEY,
    persona_id INTEGER REFERENCES users_persona(id) ON DELETE CASCADE,
    rol_id INTEGER REFERENCES users_rol(id) ON DELETE CASCADE
);

CREATE TABLE users_favorito (
    id SERIAL PRIMARY KEY,
    lugar_id INTEGER REFERENCES users_lugar(id) ON DELETE CASCADE,
    persona_id INTEGER REFERENCES users_persona(id) ON DELETE CASCADE
);