DROP TABLE IF EXISTS equivMateria CASCADE;
DROP TABLE IF EXISTS inscripcionETS CASCADE;
DROP TABLE IF EXISTS ETS CASCADE;
DROP TABLE IF EXISTS carrera_materia CASCADE;
DROP TABLE IF EXISTS alumno CASCADE;
DROP TABLE IF EXISTS usuarioAdmin CASCADE;
DROP TABLE IF EXISTS jefeAcademia CASCADE;
DROP TABLE IF EXISTS academia CASCADE;
DROP TABLE IF EXISTS carrera CASCADE;
DROP TABLE IF EXISTS planEstudios CASCADE;
DROP TABLE IF EXISTS materia CASCADE;
DROP TABLE IF EXISTS periodoETS CASCADE;
DROP TABLE IF EXISTS salon CASCADE;
DROP TABLE IF EXISTS edificio CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;

CREATE TABLE edificio (
    id_edificio VARCHAR(1) PRIMARY KEY, -- puede ser INT
    numero VARCHAR(1) NOT NULL 
);

CREATE TABLE salon (
    id_salon    VARCHAR(2) PRIMARY KEY, -- puede ser INT
    piso        VARCHAR(1)  NOT NULL,   -- puede ser INT
    codigo      VARCHAR(4),
    id_edificio VARCHAR(1)  NOT NULL,
    -- numeroSalon VARCHAR(2) NOT NULL, -- puede ser INT (no c pq numero si ya es el id)
    CONSTRAINT fk_edificio
        FOREIGN KEY (id_edificio)
        REFERENCES edificio(id_edificio)
        ON DELETE CASCADE
);

CREATE TABLE periodoETS (
    id_periodoETS VARCHAR(20) PRIMARY KEY,
    nombre        VARCHAR(50)  NOT NULL,
    tipo          VARCHAR(50)  NOT NULL,
    fechaInicio   DATE         NOT NULL,
    fechaFin      DATE         NOT NULL,
    estado        VARCHAR(20)  NOT NULL -- puede ser BOOLEAN o ENUM
);

CREATE TABLE materia (
    id_materia  VARCHAR(20) PRIMARY KEY,
    acronimo    VARCHAR(10)  NOT NULL,
    nombre      VARCHAR(100) NOT NULL
);

CREATE TABLE planEstudios (
    id_plan VARCHAR(20) PRIMARY KEY,
    anio    DATE         NOT NULL,
    nombre  VARCHAR(100) NOT NULL
);

CREATE TABLE carrera (
    id_carrera  VARCHAR(20) PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    acronimo    VARCHAR(10)  NOT NULL,
    activo      BOOLEAN      NOT NULL
);

CREATE TABLE usuario (
    id_usuario      VARCHAR(20) PRIMARY KEY,
    correo          VARCHAR(100) NOT NULL,
    activo          BOOLEAN      NOT NULL,
    passwordHash    VARCHAR(255) NOT NULL,
    nombre          VARCHAR(100) NOT NULL,
    apellidoPaterno VARCHAR(100) NOT NULL,
    apellidoMaterno VARCHAR(100) NOT NULL
);

CREATE TABLE usuarioAdmin (
    id_admin    VARCHAR(20) PRIMARY KEY,
    id_usuario  VARCHAR(20) NOT NULL UNIQUE,
    CONSTRAINT fk_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

CREATE TABLE jefeAcademia (
    id_jefeAcademia VARCHAR(20) PRIMARY KEY,
    id_usuario      VARCHAR(20) NOT NULL UNIQUE,
    CONSTRAINT fk_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

CREATE TABLE academia (
    id_academia     VARCHAR(20) PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    acronimo        VARCHAR(10)  NOT NULL,
    id_jefeAcademia VARCHAR(20),
    CONSTRAINT fk_jefeAcademia
        FOREIGN KEY (id_jefeAcademia)
        REFERENCES jefeAcademia(id_jefeAcademia)
        ON DELETE SET NULL
);

CREATE TABLE alumno (
    id_alumno   VARCHAR(20) PRIMARY KEY,
    boleta      VARCHAR(20) NOT NULL,
    id_carrera  VARCHAR(20) NOT NULL,
    id_plan     VARCHAR(20) NOT NULL,
    id_usuario  VARCHAR(20) NOT NULL UNIQUE,
    CONSTRAINT fk_carrera
        FOREIGN KEY (id_carrera)
        REFERENCES carrera(id_carrera)
        ON DELETE CASCADE,
    CONSTRAINT fk_plan
        FOREIGN KEY (id_plan)
        REFERENCES planEstudios(id_plan)
        ON DELETE CASCADE,
    CONSTRAINT fk_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

CREATE TABLE carrera_materia (
    id_carrera_materia VARCHAR(20) PRIMARY KEY,
    semestre           INT         NOT NULL,
    tipoMateria        VARCHAR(50) NOT NULL,
    id_materia         VARCHAR(20) NOT NULL,
    id_academia        VARCHAR(20) NOT NULL,
    id_plan            VARCHAR(20) NOT NULL,
    id_carrera         VARCHAR(20) NOT NULL,
    CONSTRAINT fk_materia
        FOREIGN KEY (id_materia)
        REFERENCES materia(id_materia)
        ON DELETE CASCADE,
    CONSTRAINT fk_academia
        FOREIGN KEY (id_academia)
        REFERENCES academia(id_academia)
        ON DELETE CASCADE,
    CONSTRAINT fk_plan
        FOREIGN KEY (id_plan)
        REFERENCES planEstudios(id_plan)
        ON DELETE CASCADE,
    CONSTRAINT fk_carrera
        FOREIGN KEY (id_carrera)
        REFERENCES carrera(id_carrera)
        ON DELETE CASCADE
);

CREATE TABLE equivMateria (
    id_equivalencia VARCHAR(50) PRIMARY KEY,
    id_origen       VARCHAR(20) NOT NULL,
    id_destino      VARCHAR(20) NOT NULL,
    CONSTRAINT fk_origen
        FOREIGN KEY (id_origen)
        REFERENCES carrera_materia(id_carrera_materia)
        ON DELETE CASCADE,
    CONSTRAINT fk_destino
        FOREIGN KEY (id_destino)
        REFERENCES carrera_materia(id_carrera_materia)
        ON DELETE CASCADE
);

CREATE TABLE ETS (
    id_ets              VARCHAR(20) PRIMARY KEY,
    fechaHoraInicio     TIMESTAMP   NOT NULL,
    fechaHoraFin        TIMESTAMP   NOT NULL,
    estado              VARCHAR(20) NOT NULL, -- puede ser BOOLEAN o ENUM
    turno               VARCHAR(20),          -- atributo derivado (punteado)
    id_periodoETS       VARCHAR(20) NOT NULL,
    id_salon            VARCHAR(2)  NOT NULL,
    id_carrera_materia  VARCHAR(20) NOT NULL,
    id_jefeAcademia     VARCHAR(20) NOT NULL,
    CONSTRAINT fk_periodoETS
        FOREIGN KEY (id_periodoETS)
        REFERENCES periodoETS(id_periodoETS)
        ON DELETE CASCADE,
    CONSTRAINT fk_salon
        FOREIGN KEY (id_salon)
        REFERENCES salon(id_salon)
        ON DELETE CASCADE,
    CONSTRAINT fk_carrera_materia
        FOREIGN KEY (id_carrera_materia)
        REFERENCES carrera_materia(id_carrera_materia)
        ON DELETE CASCADE,
    CONSTRAINT fk_jefeAcademia
        FOREIGN KEY (id_jefeAcademia)
        REFERENCES jefeAcademia(id_jefeAcademia)
        ON DELETE CASCADE
);

CREATE TABLE inscripcionETS (
    id_inscripcionETS VARCHAR(20) PRIMARY KEY,
    id_ets            VARCHAR(20) NOT NULL,
    id_alumno         VARCHAR(20) NOT NULL,
    resultado         VARCHAR(20),           -- que es resultado?
    calificacion      FLOAT,
    fechaInscripcion  DATE        NOT NULL,
    estado            VARCHAR(20) NOT NULL,  -- puede ser BOOLEAN o ENUM
    CONSTRAINT fk_ets
        FOREIGN KEY (id_ets)
        REFERENCES ETS(id_ets)
        ON DELETE CASCADE,
    CONSTRAINT fk_alumno
        FOREIGN KEY (id_alumno)
        REFERENCES alumno(id_alumno)
        ON DELETE CASCADE
);