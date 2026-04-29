
CREATE TABLE lugares (
                id_lugares INTEGER NOT NULL,
                nombre VARCHAR(200) NOT NULL,
                descripcion VARCHAR(500) NOT NULL,
                provincia VARCHAR(100) NOT NULL,
                municipio VARCHAR(100) NOT NULL,
                departamento VARCHAR(100) NOT NULL,
                ubicacion VARCHAR(300) NOT NULL,
                latitud NUMERIC(50) NOT NULL,
                longitud NUMERIC(50) NOT NULL,
                url VARCHAR(300) NOT NULL,
                CONSTRAINT lugares_pk PRIMARY KEY (id_lugares)
);


CREATE TABLE horarios (
                id_horarios INTEGER NOT NULL,
                id_lugares INTEGER NOT NULL,
                dia VARCHAR(50) NOT NULL,
                apertura TIME NOT NULL,
                cierre TIME NOT NULL,
                CONSTRAINT horarios_pk PRIMARY KEY (id_horarios)
);


CREATE SEQUENCE comentarios_id_comentario_seq_2;

CREATE TABLE comentarios (
                id_comentario INTEGER NOT NULL DEFAULT nextval('comentarios_id_comentario_seq_2'),
                comentario VARCHAR(500) NOT NULL,
                calificacion INTEGER NOT NULL,
                fecha DATE NOT NULL,
                id_personas INTEGER NOT NULL,
                id_lugares INTEGER NOT NULL,
                id_recomentario INTEGER NOT NULL,
                CONSTRAINT comentarios_pk PRIMARY KEY (id_comentario)
);


ALTER SEQUENCE comentarios_id_comentario_seq_2 OWNED BY comentarios.id_comentario;

CREATE TABLE fotos (
                id_fotos INTEGER NOT NULL,
                url VARCHAR(300) NOT NULL,
                descripcion VARCHAR(100) NOT NULL,
                id_lugares INTEGER NOT NULL,
                id_comentario INTEGER NOT NULL,
                CONSTRAINT fotos_pk PRIMARY KEY (id_fotos)
);


CREATE SEQUENCE funcionalidades_id_funcionalidad_seq;

CREATE TABLE funcionalidades (
                id_funcionalidad VARCHAR NOT NULL DEFAULT nextval('funcionalidades_id_funcionalidad_seq'),
                nombre VARCHAR NOT NULL,
                CONSTRAINT funcionalidad_pk PRIMARY KEY (id_funcionalidad)
);


ALTER SEQUENCE funcionalidades_id_funcionalidad_seq OWNED BY funcionalidades.id_funcionalidad;

CREATE TABLE roles (
                id_roles INTEGER NOT NULL,
                nombre VARCHAR(100) NOT NULL,
                CONSTRAINT rol_pk PRIMARY KEY (id_roles)
);


CREATE UNIQUE INDEX roles_idx
 ON roles
 ( id_roles );

CREATE TABLE privilegios (
                id_roles INTEGER NOT NULL,
                id_funcionalidad VARCHAR NOT NULL,
                CONSTRAINT privilegios_pk PRIMARY KEY (id_roles, id_funcionalidad)
);


CREATE SEQUENCE personas_id_personas_seq;

CREATE TABLE personas (
                id_personas INTEGER NOT NULL DEFAULT nextval('personas_id_personas_seq'),
                nombres VARCHAR(100) NOT NULL,
                primer_apellido VARCHAR(100) NOT NULL,
                ci VARCHAR(50) NOT NULL,
                fecha_nacimiento DATE NOT NULL,
                genero VARCHAR(50) NOT NULL,
                direccion VARCHAR(200) NOT NULL,
                telefono_fijo INTEGER NOT NULL,
                celular INTEGER NOT NULL,
                segundo_apellido VARCHAR(100) NOT NULL,
                complemento_ci VARCHAR NOT NULL,
                correo_electronico VARCHAR(100) NOT NULL,
                CONSTRAINT personas_pk PRIMARY KEY (id_personas)
);


ALTER SEQUENCE personas_id_personas_seq OWNED BY personas.id_personas;

CREATE TABLE usuarios (
                id_personas INTEGER NOT NULL,
                usuario VARCHAR(50) NOT NULL,
                id_comentario INTEGER NOT NULL,
                password VARCHAR(200) NOT NULL,
                CONSTRAINT usuarios_pk PRIMARY KEY (id_personas)
);


CREATE UNIQUE INDEX usuarios_idx
 ON usuarios
 ( usuario );

CREATE TABLE favoritos (
                id_personas INTEGER NOT NULL,
                id_lugares INTEGER NOT NULL,
                CONSTRAINT favoritos_pk PRIMARY KEY (id_personas, id_lugares)
);


CREATE TABLE cuentas (
                id_personas INTEGER NOT NULL,
                id_roles INTEGER NOT NULL,
                CONSTRAINT cuentas_pk PRIMARY KEY (id_personas, id_roles)
);


ALTER TABLE horarios ADD CONSTRAINT lugares_horarios_fk
FOREIGN KEY (id_lugares)
REFERENCES lugares (id_lugares)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE comentarios ADD CONSTRAINT lugares_comentarios_fk
FOREIGN KEY (id_lugares)
REFERENCES lugares (id_lugares)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE fotos ADD CONSTRAINT lugares_fotos_fk
FOREIGN KEY (id_lugares)
REFERENCES lugares (id_lugares)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE favoritos ADD CONSTRAINT lugares_favoritos_fk
FOREIGN KEY (id_lugares)
REFERENCES lugares (id_lugares)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE usuarios ADD CONSTRAINT comentarios_usuarios_fk
FOREIGN KEY (id_comentario)
REFERENCES comentarios (id_comentario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE fotos ADD CONSTRAINT comentarios_fotos_fk
FOREIGN KEY (id_comentario)
REFERENCES comentarios (id_comentario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE comentarios ADD CONSTRAINT comentarios_comentarios_fk
FOREIGN KEY (id_recomentario)
REFERENCES comentarios (id_comentario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE privilegios ADD CONSTRAINT funcionalidades_privilegios_fk
FOREIGN KEY (id_funcionalidad)
REFERENCES funcionalidades (id_funcionalidad)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cuentas ADD CONSTRAINT roles_cuentas_fk
FOREIGN KEY (id_roles)
REFERENCES roles (id_roles)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE privilegios ADD CONSTRAINT roles_privilegios_fk
FOREIGN KEY (id_roles)
REFERENCES roles (id_roles)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE usuarios ADD CONSTRAINT personas_usuarios_fk
FOREIGN KEY (id_personas)
REFERENCES personas (id_personas)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cuentas ADD CONSTRAINT usuarios_cuentas_fk
FOREIGN KEY (id_personas)
REFERENCES usuarios (id_personas)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE favoritos ADD CONSTRAINT usuarios_favoritos_fk
FOREIGN KEY (id_personas)
REFERENCES usuarios (id_personas)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
