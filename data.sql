DROP DATABASE IF EXISTS proyecto;
CREATE DATABASE proyecto;
USE proyecto;
CREATE TABLE espectaculos (
    nombreEsp VARCHAR(30) NOT NULL,
    tipoEsp VARCHAR(30) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(30) NOT NULL,
    participantes VARCHAR(30),
    penalizacion INT NOT NULL,
    tValidezReserva TIME NOT NULL,
    tAntelacionReserva TIME NOT NULL,
    tCancelacion TIME NOT NULL,
    PRIMARY KEY(nombreEsp, tipoEsp, fechaProduccion, productora)
    );
CREATE TABLE horarios (
    fechaYHora DATETIME NOT NULL,
    PRIMARY KEY(fechaYHora)
    );
CREATE TABLE recintos (
    direccion VARCHAR(50) NOT NULL,
    nombre VARCHAR(30),
    PRIMARY KEY(direccion)
    );
CREATE TABLE horariosRecintos (
    fechaYHora DATETIME NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    FOREIGN KEY(fechaYHora) references horarios(fechaYHora) ON DELETE CASCADE,
    FOREIGN KEY(direccion) references recintos(direccion) ON DELETE CASCADE,
    primary key(fechaYHora, direccion)
    );
CREATE TABLE eventos (
    nombreEsp VARCHAR(30) NOT NULL,
    tipoEsp VARCHAR(30) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(30) NOT NULL,
    fechaYHora DATETIME NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora) ON DELETE CASCADE,
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion) ON DELETE CASCADE,
    primary key (nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );
CREATE TABLE gradas (
    nombreGrada VARCHAR(30) NOT NULL,
    nombreEsp VARCHAR(30) NOT NULL,
    tipoEsp VARCHAR(30) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(30) NOT NULL,
    fechaYHora DATETIME NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora) ON DELETE CASCADE,
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion) ON DELETE CASCADE,
    PRIMARY KEY(nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );
CREATE TABLE localidades (
    asientoLocalidad INT NOT NULL,
    nombreGrada VARCHAR(30) NOT NULL,
    nombreEsp VARCHAR(30) NOT NULL,
    tipoEsp VARCHAR(30) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(30) NOT NULL,
    fechaYHora DATETIME NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    estado ENUM ('Libre', 'Reservado', 'Prereservado', 'Deteriorado') NOT NULL DEFAULT 'Libre',
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora) ON DELETE CASCADE,
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion) ON DELETE CASCADE,
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada) ON DELETE CASCADE,
    PRIMARY KEY(asientoLocalidad, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );
CREATE TABLE tarifas (
    tipoUsuario ENUM ('bebe', 'infantil', 'juvenil', 'adulto', 'jubilado') NOT NULL,
    precio INT NOT NULL,
    maxLocalidadesReserva INT NOT NULL,
    nombreGrada VARCHAR(30) NOT NULL,
    nombreEsp VARCHAR(30) NOT NULL,
    tipoEsp VARCHAR(30) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(30) NOT NULL,
    fechaYHora DATETIME NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora) ON DELETE CASCADE,
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion) ON DELETE CASCADE,
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada) ON DELETE CASCADE,
    PRIMARY KEY(tipoUsuario, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );
CREATE TABLE clientes (
    correoCliente VARCHAR(30),
    nombreCliente VARCHAR(30),
    tlfCliente INT(9),
    datosBanco VARCHAR(30),
    PRIMARY KEY(correoCliente)
    );
CREATE TABLE entradas (
    formaPago VARCHAR(20) DEFAULT NULL,
    horaReserva DATETIME NOT NULL,
    correoCliente VARCHAR(30),
    tipoUsuario ENUM ('bebe', 'infantil', 'juvenil', 'adulto', 'jubilado') NOT NULL,
    asientoLocalidad INT NOT NULL,
    nombreGrada VARCHAR(30) NOT NULL,
    nombreEsp VARCHAR(30) NOT NULL,
    tipoEsp VARCHAR(30) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(30) NOT NULL,
    fechaYHora DATETIME NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora) ON DELETE CASCADE,
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion) ON DELETE CASCADE,
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada) ON DELETE CASCADE,
    FOREIGN KEY(asientoLocalidad) references localidades(asientoLocalidad) ON DELETE CASCADE,
    FOREIGN KEY(tipoUsuario) references tarifas(tipoUsuario) ON DELETE CASCADE,
    FOREIGN KEY(correoCliente) references clientes(correoCliente) ON DELETE CASCADE,
    PRIMARY KEY(horaReserva, tipoUsuario, asientoLocalidad, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );
CREATE TABLE cancelaciones (
    formaPago VARCHAR(20) NOT NULL,
    horaReserva DATETIME NOT NULL,
    correoCliente VARCHAR(30),
    tipoUsuario ENUM ('bebe', 'infantil', 'juvenil', 'adulto', 'jubilado') NOT NULL,
    asientoLocalidad INT NOT NULL,
    nombreGrada VARCHAR(30) NOT NULL,
    nombreEsp VARCHAR(30) NOT NULL,
    tipoEsp VARCHAR(30) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(30) NOT NULL,
    fechaYHora DATETIME NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora) ON DELETE CASCADE,
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion) ON DELETE CASCADE,
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada) ON DELETE CASCADE,
    FOREIGN KEY(asientoLocalidad) references localidades(asientoLocalidad) ON DELETE CASCADE,
    FOREIGN KEY(tipoUsuario) references tarifas(tipoUsuario) ON DELETE CASCADE,
    FOREIGN KEY(correoCliente) references clientes(correoCliente) ON DELETE CASCADE,
    PRIMARY KEY(horaReserva, tipoUsuario, asientoLocalidad, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );

INSERT INTO clientes VALUES ('alba@gmail.com', 'Alba', '123456789', 'ES15753123');
INSERT INTO clientes VALUES ('omar@gmail.com', 'Omar', '147258369', 'ES15753123');
INSERT INTO clientes VALUES ('dario@gmail.com', 'Dario', '987654321', 'ES15753123');
INSERT INTO clientes VALUES ('martina@gmail.com', 'Martina', '258369147', 'ES15753123');
INSERT INTO clientes VALUES ('fernando@gmail.com', 'Fernando', '369147258', 'ES15753123');
INSERT INTO horarios VALUES ('2022-09-01 18:00:00');
INSERT INTO horarios VALUES ('2021-09-01 18:00:00');
INSERT INTO recintos VALUES ('Calle de las flores número 0 puerta C', 'Recinto 0');
INSERT INTO recintos VALUES ('Calle de las flores número 1 puerta C', 'Recinto 1');
INSERT INTO recintos VALUES ('Calle de las flores número 2 puerta C', 'Recinto 2');
INSERT INTO recintos VALUES ('Calle de las flores número 3 puerta C', 'Recinto 3');
INSERT INTO recintos VALUES ('Calle de las flores número 4 puerta C', 'Recinto 4');
INSERT INTO recintos VALUES ('Calle de las flores número 5 puerta C', 'Recinto 5');
INSERT INTO recintos VALUES ('Calle de las flores número 6 puerta C', 'Recinto 6');
INSERT INTO recintos VALUES ('Calle de las flores número 7 puerta C', 'Recinto 7');
INSERT INTO recintos VALUES ('Calle de las flores número 8 puerta C', 'Recinto 8');
INSERT INTO recintos VALUES ('Calle de las flores número 9 puerta C', 'Recinto 9');
INSERT INTO recintos VALUES ('Calle de las flores número 10 puerta C', 'Recinto 10');
INSERT INTO recintos VALUES ('Calle de las flores número 11 puerta C', 'Recinto 11');
INSERT INTO recintos VALUES ('Calle de las flores número 12 puerta C', 'Recinto 12');
INSERT INTO recintos VALUES ('Calle de las flores número 13 puerta C', 'Recinto 13');
INSERT INTO recintos VALUES ('Calle de las flores número 14 puerta C', 'Recinto 14');
INSERT INTO recintos VALUES ('Calle de las flores número 15 puerta C', 'Recinto 15');
INSERT INTO recintos VALUES ('Calle de las flores número 16 puerta C', 'Recinto 16');
INSERT INTO recintos VALUES ('Calle de las flores número 17 puerta C', 'Recinto 17');
INSERT INTO recintos VALUES ('Calle de las flores número 18 puerta C', 'Recinto 18');
INSERT INTO recintos VALUES ('Calle de las flores número 19 puerta C', 'Recinto 19');
INSERT INTO recintos VALUES ('Calle de las flores número 20 puerta C', 'Recinto 20');
INSERT INTO recintos VALUES ('Calle de las flores número 21 puerta C', 'Recinto 21');
INSERT INTO recintos VALUES ('Calle de las flores número 22 puerta C', 'Recinto 22');
INSERT INTO recintos VALUES ('Calle de las flores número 23 puerta C', 'Recinto 23');
INSERT INTO recintos VALUES ('Calle de las flores número 24 puerta C', 'Recinto 24');
INSERT INTO recintos VALUES ('Calle de las flores número 25 puerta C', 'Recinto 25');
INSERT INTO recintos VALUES ('Calle de las flores número 26 puerta C', 'Recinto 26');
INSERT INTO recintos VALUES ('Calle de las flores número 27 puerta C', 'Recinto 27');
INSERT INTO recintos VALUES ('Calle de las flores número 28 puerta C', 'Recinto 28');
INSERT INTO recintos VALUES ('Calle de las flores número 29 puerta C', 'Recinto 29');
INSERT INTO recintos VALUES ('Calle de las flores número 30 puerta C', 'Recinto 30');
INSERT INTO recintos VALUES ('Calle de las flores número 31 puerta C', 'Recinto 31');
INSERT INTO recintos VALUES ('Calle de las flores número 32 puerta C', 'Recinto 32');
INSERT INTO recintos VALUES ('Calle de las flores número 33 puerta C', 'Recinto 33');
INSERT INTO recintos VALUES ('Calle de las flores número 34 puerta C', 'Recinto 34');
INSERT INTO recintos VALUES ('Calle de las flores número 35 puerta C', 'Recinto 35');
INSERT INTO recintos VALUES ('Calle de las flores número 36 puerta C', 'Recinto 36');
INSERT INTO recintos VALUES ('Calle de las flores número 37 puerta C', 'Recinto 37');
INSERT INTO recintos VALUES ('Calle de las flores número 38 puerta C', 'Recinto 38');
INSERT INTO recintos VALUES ('Calle de las flores número 39 puerta C', 'Recinto 39');
INSERT INTO recintos VALUES ('Calle de las flores número 40 puerta C', 'Recinto 40');
INSERT INTO recintos VALUES ('Calle de las flores número 41 puerta C', 'Recinto 41');
INSERT INTO recintos VALUES ('Calle de las flores número 42 puerta C', 'Recinto 42');
INSERT INTO recintos VALUES ('Calle de las flores número 43 puerta C', 'Recinto 43');
INSERT INTO recintos VALUES ('Calle de las flores número 44 puerta C', 'Recinto 44');
INSERT INTO recintos VALUES ('Calle de las flores número 45 puerta C', 'Recinto 45');
INSERT INTO recintos VALUES ('Calle de las flores número 46 puerta C', 'Recinto 46');
INSERT INTO recintos VALUES ('Calle de las flores número 47 puerta C', 'Recinto 47');
INSERT INTO recintos VALUES ('Calle de las flores número 48 puerta C', 'Recinto 48');
INSERT INTO recintos VALUES ('Calle de las flores número 49 puerta C', 'Recinto 49');
INSERT INTO recintos VALUES ('Calle de las flores número 50 puerta C', 'Recinto 50');
INSERT INTO recintos VALUES ('Calle de las flores número 51 puerta C', 'Recinto 51');
INSERT INTO recintos VALUES ('Calle de las flores número 52 puerta C', 'Recinto 52');
INSERT INTO recintos VALUES ('Calle de las flores número 53 puerta C', 'Recinto 53');
INSERT INTO recintos VALUES ('Calle de las flores número 54 puerta C', 'Recinto 54');
INSERT INTO recintos VALUES ('Calle de las flores número 55 puerta C', 'Recinto 55');
INSERT INTO recintos VALUES ('Calle de las flores número 56 puerta C', 'Recinto 56');
INSERT INTO recintos VALUES ('Calle de las flores número 57 puerta C', 'Recinto 57');
INSERT INTO recintos VALUES ('Calle de las flores número 58 puerta C', 'Recinto 58');
INSERT INTO recintos VALUES ('Calle de las flores número 59 puerta C', 'Recinto 59');
INSERT INTO recintos VALUES ('Calle de las flores número 60 puerta C', 'Recinto 60');
INSERT INTO recintos VALUES ('Calle de las flores número 61 puerta C', 'Recinto 61');
INSERT INTO recintos VALUES ('Calle de las flores número 62 puerta C', 'Recinto 62');
INSERT INTO recintos VALUES ('Calle de las flores número 63 puerta C', 'Recinto 63');
INSERT INTO recintos VALUES ('Calle de las flores número 64 puerta C', 'Recinto 64');
INSERT INTO recintos VALUES ('Calle de las flores número 65 puerta C', 'Recinto 65');
INSERT INTO recintos VALUES ('Calle de las flores número 66 puerta C', 'Recinto 66');
INSERT INTO recintos VALUES ('Calle de las flores número 67 puerta C', 'Recinto 67');
INSERT INTO recintos VALUES ('Calle de las flores número 68 puerta C', 'Recinto 68');
INSERT INTO recintos VALUES ('Calle de las flores número 69 puerta C', 'Recinto 69');
INSERT INTO recintos VALUES ('Calle de las flores número 70 puerta C', 'Recinto 70');
INSERT INTO recintos VALUES ('Calle de las flores número 71 puerta C', 'Recinto 71');
INSERT INTO recintos VALUES ('Calle de las flores número 72 puerta C', 'Recinto 72');
INSERT INTO recintos VALUES ('Calle de las flores número 73 puerta C', 'Recinto 73');
INSERT INTO recintos VALUES ('Calle de las flores número 74 puerta C', 'Recinto 74');
INSERT INTO recintos VALUES ('Calle de las flores número 75 puerta C', 'Recinto 75');
INSERT INTO recintos VALUES ('Calle de las flores número 76 puerta C', 'Recinto 76');
INSERT INTO recintos VALUES ('Calle de las flores número 77 puerta C', 'Recinto 77');
INSERT INTO recintos VALUES ('Calle de las flores número 78 puerta C', 'Recinto 78');
INSERT INTO recintos VALUES ('Calle de las flores número 79 puerta C', 'Recinto 79');
INSERT INTO recintos VALUES ('Calle de las flores número 80 puerta C', 'Recinto 80');
INSERT INTO recintos VALUES ('Calle de las flores número 81 puerta C', 'Recinto 81');
INSERT INTO recintos VALUES ('Calle de las flores número 82 puerta C', 'Recinto 82');
INSERT INTO recintos VALUES ('Calle de las flores número 83 puerta C', 'Recinto 83');
INSERT INTO recintos VALUES ('Calle de las flores número 84 puerta C', 'Recinto 84');
INSERT INTO recintos VALUES ('Calle de las flores número 85 puerta C', 'Recinto 85');
INSERT INTO recintos VALUES ('Calle de las flores número 86 puerta C', 'Recinto 86');
INSERT INTO recintos VALUES ('Calle de las flores número 87 puerta C', 'Recinto 87');
INSERT INTO recintos VALUES ('Calle de las flores número 88 puerta C', 'Recinto 88');
INSERT INTO recintos VALUES ('Calle de las flores número 89 puerta C', 'Recinto 89');
INSERT INTO recintos VALUES ('Calle de las flores número 90 puerta C', 'Recinto 90');
INSERT INTO recintos VALUES ('Calle de las flores número 91 puerta C', 'Recinto 91');
INSERT INTO recintos VALUES ('Calle de las flores número 92 puerta C', 'Recinto 92');
INSERT INTO recintos VALUES ('Calle de las flores número 93 puerta C', 'Recinto 93');
INSERT INTO recintos VALUES ('Calle de las flores número 94 puerta C', 'Recinto 94');
INSERT INTO recintos VALUES ('Calle de las flores número 95 puerta C', 'Recinto 95');
INSERT INTO recintos VALUES ('Calle de las flores número 96 puerta C', 'Recinto 96');
INSERT INTO recintos VALUES ('Calle de las flores número 97 puerta C', 'Recinto 97');
INSERT INTO recintos VALUES ('Calle de las flores número 98 puerta C', 'Recinto 98');
INSERT INTO recintos VALUES ('Calle de las flores número 99 puerta C', 'Recinto 99');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 0 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 0 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 1 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 1 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 2 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 2 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 3 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 3 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 4 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 4 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 5 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 5 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 6 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 6 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 7 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 7 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 8 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 8 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 9 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 9 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 10 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 10 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 11 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 11 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 12 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 12 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 13 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 13 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 14 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 14 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 15 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 15 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 16 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 16 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 17 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 17 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 18 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 18 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 19 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 19 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 20 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 20 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 21 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 21 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 22 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 22 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 23 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 23 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 24 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 24 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 25 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 25 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 26 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 26 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 27 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 27 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 28 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 28 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 29 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 29 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 30 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 30 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 31 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 31 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 32 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 32 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 33 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 33 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 34 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 34 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 35 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 35 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 36 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 36 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 37 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 37 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 38 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 38 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 39 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 39 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 40 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 40 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 41 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 41 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 42 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 42 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 43 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 43 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 44 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 44 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 45 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 45 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 46 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 46 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 47 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 47 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 48 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 48 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 49 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 49 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 50 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 50 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 51 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 51 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 52 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 52 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 53 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 53 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 54 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 54 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 55 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 55 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 56 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 56 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 57 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 57 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 58 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 58 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 59 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 59 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 60 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 60 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 61 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 61 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 62 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 62 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 63 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 63 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 64 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 64 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 65 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 65 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 66 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 66 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 67 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 67 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 68 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 68 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 69 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 69 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 70 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 70 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 71 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 71 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 72 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 72 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 73 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 73 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 74 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 74 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 75 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 75 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 76 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 76 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 77 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 77 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 78 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 78 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 79 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 79 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 80 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 80 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 81 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 81 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 82 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 82 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 83 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 83 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 84 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 84 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 85 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 85 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 86 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 86 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 87 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 87 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 88 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 88 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 89 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 89 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 90 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 90 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 91 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 91 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 92 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 92 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 93 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 93 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 94 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 94 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 95 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 95 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 96 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 96 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 97 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 97 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 98 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 98 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', 'Calle de las flores número 99 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', 'Calle de las flores número 99 puerta C');
INSERT INTO espectaculos VALUES ('Rey Leon', 'pelicula', '1994-01-01', 'Disney', 'dibujos animados', 3, '00:01:00', '00:02:00', '00:04:00');
INSERT INTO recintos VALUES ('Cines Gran Via Vigo sala 1', 'Cine Gran Via');
INSERT INTO recintos VALUES ('Cines Gran Via Vigo sala 2', 'Cine Gran Via');
INSERT INTO recintos VALUES ('Auditorio Mar de Vigo', 'Auditorio Mar de Vigo');
INSERT INTO horarios VALUES ('2022-07-01 19:00:00');
INSERT INTO horarios VALUES ('2022-07-10 20:30:00');
INSERT INTO horariosRecintos VALUES ('2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');
INSERT INTO horariosRecintos VALUES ('2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO horariosRecintos VALUES ('2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO eventos VALUES ('Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');
INSERT INTO gradas VALUES ('grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');
INSERT INTO localidades VALUES (0,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (1,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (2,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (3,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (4,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (5,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (6,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (7,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (8,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (9,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (10,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (11,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (12,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (13,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (14,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (15,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (16,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (17,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (18,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (19,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (20,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (21,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (22,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (23,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (24,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (25,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (26,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (27,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (28,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO localidades VALUES (29,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1', 'Libre');
INSERT INTO tarifas VALUES ('bebe', 0, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');
INSERT INTO tarifas VALUES ('infantil', 5, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');
INSERT INTO tarifas VALUES ('juvenil', 8, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');
INSERT INTO tarifas VALUES ('adulto', 10, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');
INSERT INTO tarifas VALUES ('jubilado', 5, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');
INSERT INTO eventos VALUES ('Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO gradas VALUES ('grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO localidades VALUES (0,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (1,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (2,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (3,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (4,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (5,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (6,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (7,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (8,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (9,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (10,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (11,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (12,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (13,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (14,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (15,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (16,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (17,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (18,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (19,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (20,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (21,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (22,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (23,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (24,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (25,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (26,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (27,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (28,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO localidades VALUES (29,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2', 'Libre');
INSERT INTO tarifas VALUES ('bebe', 0, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO tarifas VALUES ('infantil', 5, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO tarifas VALUES ('juvenil', 8, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO tarifas VALUES ('adulto', 10, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO tarifas VALUES ('jubilado', 5, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO espectaculos VALUES ('Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', 'Pedro Gomez - Laura Perez', 5, '00:01:00', '00:02:00', '00:04:00');
INSERT INTO eventos VALUES ('Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO gradas VALUES ('grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO localidades VALUES (0,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (1,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (2,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (3,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (4,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (5,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (6,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (7,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (8,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (9,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (10,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (11,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (12,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (13,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (14,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (15,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (16,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (17,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (18,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (19,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (20,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (21,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (22,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (23,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (24,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (25,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (26,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (27,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (28,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (29,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (30,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (31,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (32,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (33,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (34,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (35,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (36,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (37,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (38,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (39,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (40,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (41,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (42,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (43,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (44,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (45,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (46,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (47,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (48,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (49,'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO tarifas VALUES ('adulto', 20, 5, 'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO tarifas VALUES ('jubilado', 12, 5, 'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO gradas VALUES ('grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO localidades VALUES (0,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (1,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (2,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (3,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (4,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (5,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (6,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (7,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (8,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (9,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (10,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (11,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (12,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (13,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (14,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (15,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (16,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (17,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (18,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (19,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (20,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (21,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (22,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (23,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (24,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (25,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (26,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (27,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (28,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (29,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (30,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (31,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (32,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (33,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (34,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (35,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (36,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (37,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (38,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (39,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (40,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (41,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (42,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (43,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (44,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (45,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (46,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (47,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (48,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO localidades VALUES (49,'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo', 'Libre');
INSERT INTO tarifas VALUES ('adulto', 18, 5, 'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO tarifas VALUES ('jubilado', 10, 5, 'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO espectaculos VALUES ('espectaculo 0', 'teatro', '1988-01-23', 'productora 0', 'lista participantes 0', 6, '00:11:00', '00:52:00', '00:18:00');
INSERT INTO eventos VALUES ('espectaculo 0', 'teatro', '1988-01-23', 'productora 0', '2022-09-01 18:00:00', 'Calle de las flores número 0 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 0', 'teatro', '1988-01-23', 'productora 0', '2022-09-01 18:00:00', 'Calle de las flores número 0 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 0', 'teatro', '1988-01-23', 'productora 0', '2022-09-01 18:00:00', 'Calle de las flores número 0 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 0', 'teatro', '1988-01-23', 'productora 0', '2022-09-01 18:00:00', 'Calle de las flores número 0 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 1', 'pelicula', '2005-11-11', 'productora 1', 'lista participantes 1', 3, '00:19:00', '00:56:00', '00:29:00');
INSERT INTO eventos VALUES ('espectaculo 1', 'pelicula', '2005-11-11', 'productora 1', '2022-09-01 18:00:00', 'Calle de las flores número 1 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 1', 'pelicula', '2005-11-11', 'productora 1', '2022-09-01 18:00:00', 'Calle de las flores número 1 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 1', 'pelicula', '2005-11-11', 'productora 1', '2022-09-01 18:00:00', 'Calle de las flores número 1 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 1', 'pelicula', '2005-11-11', 'productora 1', '2022-09-01 18:00:00', 'Calle de las flores número 1 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 2', 'teatro', '1988-04-10', 'productora 2', 'lista participantes 2', 8, '00:11:00', '00:32:00', '00:19:00');
INSERT INTO eventos VALUES ('espectaculo 2', 'teatro', '1988-04-10', 'productora 2', '2022-09-01 18:00:00', 'Calle de las flores número 2 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 2', 'teatro', '1988-04-10', 'productora 2', '2022-09-01 18:00:00', 'Calle de las flores número 2 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 2', 'teatro', '1988-04-10', 'productora 2', '2022-09-01 18:00:00', 'Calle de las flores número 2 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 2', 'teatro', '1988-04-10', 'productora 2', '2022-09-01 18:00:00', 'Calle de las flores número 2 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 3', 'entrevista', '1985-02-22', 'productora 3', 'lista participantes 3', 7, '00:19:00', '00:53:00', '00:19:00');
INSERT INTO eventos VALUES ('espectaculo 3', 'entrevista', '1985-02-22', 'productora 3', '2022-09-01 18:00:00', 'Calle de las flores número 3 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 3', 'entrevista', '1985-02-22', 'productora 3', '2022-09-01 18:00:00', 'Calle de las flores número 3 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 3', 'entrevista', '1985-02-22', 'productora 3', '2022-09-01 18:00:00', 'Calle de las flores número 3 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 3', 'entrevista', '1985-02-22', 'productora 3', '2022-09-01 18:00:00', 'Calle de las flores número 3 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 4', 'entrevista', '2007-05-18', 'productora 4', 'lista participantes 4', 7, '00:15:00', '00:39:00', '00:21:00');
INSERT INTO eventos VALUES ('espectaculo 4', 'entrevista', '2007-05-18', 'productora 4', '2022-09-01 18:00:00', 'Calle de las flores número 4 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 4', 'entrevista', '2007-05-18', 'productora 4', '2022-09-01 18:00:00', 'Calle de las flores número 4 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 4', 'entrevista', '2007-05-18', 'productora 4', '2022-09-01 18:00:00', 'Calle de las flores número 4 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 4', 'entrevista', '2007-05-18', 'productora 4', '2022-09-01 18:00:00', 'Calle de las flores número 4 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 5', 'deportivo', '2002-07-06', 'productora 5', 'lista participantes 5', 6, '00:12:00', '00:51:00', '00:24:00');
INSERT INTO eventos VALUES ('espectaculo 5', 'deportivo', '2002-07-06', 'productora 5', '2022-09-01 18:00:00', 'Calle de las flores número 5 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 5', 'deportivo', '2002-07-06', 'productora 5', '2022-09-01 18:00:00', 'Calle de las flores número 5 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 5', 'deportivo', '2002-07-06', 'productora 5', '2022-09-01 18:00:00', 'Calle de las flores número 5 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 5', 'deportivo', '2002-07-06', 'productora 5', '2022-09-01 18:00:00', 'Calle de las flores número 5 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 6', 'entrevista', '2014-08-09', 'productora 6', 'lista participantes 6', 8, '00:11:00', '00:33:00', '00:18:00');
INSERT INTO eventos VALUES ('espectaculo 6', 'entrevista', '2014-08-09', 'productora 6', '2022-09-01 18:00:00', 'Calle de las flores número 6 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 6', 'entrevista', '2014-08-09', 'productora 6', '2022-09-01 18:00:00', 'Calle de las flores número 6 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 6', 'entrevista', '2014-08-09', 'productora 6', '2022-09-01 18:00:00', 'Calle de las flores número 6 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 6', 'entrevista', '2014-08-09', 'productora 6', '2022-09-01 18:00:00', 'Calle de las flores número 6 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 7', 'teatro', '1994-01-13', 'productora 7', 'lista participantes 7', 8, '00:14:00', '00:27:00', '00:29:00');
INSERT INTO eventos VALUES ('espectaculo 7', 'teatro', '1994-01-13', 'productora 7', '2022-09-01 18:00:00', 'Calle de las flores número 7 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 7', 'teatro', '1994-01-13', 'productora 7', '2022-09-01 18:00:00', 'Calle de las flores número 7 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 7', 'teatro', '1994-01-13', 'productora 7', '2022-09-01 18:00:00', 'Calle de las flores número 7 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 7', 'teatro', '1994-01-13', 'productora 7', '2022-09-01 18:00:00', 'Calle de las flores número 7 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 8', 'deportivo', '2006-09-03', 'productora 8', 'lista participantes 8', 6, '00:10:00', '00:27:00', '00:17:00');
INSERT INTO eventos VALUES ('espectaculo 8', 'deportivo', '2006-09-03', 'productora 8', '2022-09-01 18:00:00', 'Calle de las flores número 8 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 8', 'deportivo', '2006-09-03', 'productora 8', '2022-09-01 18:00:00', 'Calle de las flores número 8 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 8', 'deportivo', '2006-09-03', 'productora 8', '2022-09-01 18:00:00', 'Calle de las flores número 8 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 8', 'deportivo', '2006-09-03', 'productora 8', '2022-09-01 18:00:00', 'Calle de las flores número 8 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 9', 'concierto', '2010-01-24', 'productora 9', 'lista participantes 9', 4, '00:13:00', '00:56:00', '00:25:00');
INSERT INTO eventos VALUES ('espectaculo 9', 'concierto', '2010-01-24', 'productora 9', '2022-09-01 18:00:00', 'Calle de las flores número 9 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 9', 'concierto', '2010-01-24', 'productora 9', '2022-09-01 18:00:00', 'Calle de las flores número 9 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 9', 'concierto', '2010-01-24', 'productora 9', '2022-09-01 18:00:00', 'Calle de las flores número 9 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 9', 'concierto', '2010-01-24', 'productora 9', '2022-09-01 18:00:00', 'Calle de las flores número 9 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 10', 'pelicula', '2017-08-05', 'productora 10', 'lista participantes 10', 7, '00:14:00', '00:15:00', '00:17:00');
INSERT INTO eventos VALUES ('espectaculo 10', 'pelicula', '2017-08-05', 'productora 10', '2022-09-01 18:00:00', 'Calle de las flores número 10 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 10', 'pelicula', '2017-08-05', 'productora 10', '2022-09-01 18:00:00', 'Calle de las flores número 10 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 10', 'pelicula', '2017-08-05', 'productora 10', '2022-09-01 18:00:00', 'Calle de las flores número 10 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 10', 'pelicula', '2017-08-05', 'productora 10', '2022-09-01 18:00:00', 'Calle de las flores número 10 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 11', 'concierto', '2020-07-10', 'productora 11', 'lista participantes 11', 6, '00:10:00', '00:39:00', '00:23:00');
INSERT INTO eventos VALUES ('espectaculo 11', 'concierto', '2020-07-10', 'productora 11', '2022-09-01 18:00:00', 'Calle de las flores número 11 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 11', 'concierto', '2020-07-10', 'productora 11', '2022-09-01 18:00:00', 'Calle de las flores número 11 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 11', 'concierto', '2020-07-10', 'productora 11', '2022-09-01 18:00:00', 'Calle de las flores número 11 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 11', 'concierto', '2020-07-10', 'productora 11', '2022-09-01 18:00:00', 'Calle de las flores número 11 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 12', 'entrevista', '1998-09-02', 'productora 12', 'lista participantes 12', 9, '00:11:00', '00:36:00', '00:24:00');
INSERT INTO eventos VALUES ('espectaculo 12', 'entrevista', '1998-09-02', 'productora 12', '2022-09-01 18:00:00', 'Calle de las flores número 12 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 12', 'entrevista', '1998-09-02', 'productora 12', '2022-09-01 18:00:00', 'Calle de las flores número 12 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 12', 'entrevista', '1998-09-02', 'productora 12', '2022-09-01 18:00:00', 'Calle de las flores número 12 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 12', 'entrevista', '1998-09-02', 'productora 12', '2022-09-01 18:00:00', 'Calle de las flores número 12 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 13', 'pelicula', '1995-04-19', 'productora 13', 'lista participantes 13', 3, '00:17:00', '00:16:00', '00:20:00');
INSERT INTO eventos VALUES ('espectaculo 13', 'pelicula', '1995-04-19', 'productora 13', '2022-09-01 18:00:00', 'Calle de las flores número 13 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 13', 'pelicula', '1995-04-19', 'productora 13', '2022-09-01 18:00:00', 'Calle de las flores número 13 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 13', 'pelicula', '1995-04-19', 'productora 13', '2022-09-01 18:00:00', 'Calle de las flores número 13 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 13', 'pelicula', '1995-04-19', 'productora 13', '2022-09-01 18:00:00', 'Calle de las flores número 13 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 14', 'pelicula', '1995-08-18', 'productora 14', 'lista participantes 14', 7, '00:12:00', '00:29:00', '00:15:00');
INSERT INTO eventos VALUES ('espectaculo 14', 'pelicula', '1995-08-18', 'productora 14', '2022-09-01 18:00:00', 'Calle de las flores número 14 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 14', 'pelicula', '1995-08-18', 'productora 14', '2022-09-01 18:00:00', 'Calle de las flores número 14 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 14', 'pelicula', '1995-08-18', 'productora 14', '2022-09-01 18:00:00', 'Calle de las flores número 14 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 14', 'pelicula', '1995-08-18', 'productora 14', '2022-09-01 18:00:00', 'Calle de las flores número 14 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 15', 'entrevista', '1992-05-08', 'productora 15', 'lista participantes 15', 9, '00:11:00', '00:36:00', '00:17:00');
INSERT INTO eventos VALUES ('espectaculo 15', 'entrevista', '1992-05-08', 'productora 15', '2022-09-01 18:00:00', 'Calle de las flores número 15 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 15', 'entrevista', '1992-05-08', 'productora 15', '2022-09-01 18:00:00', 'Calle de las flores número 15 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 15', 'entrevista', '1992-05-08', 'productora 15', '2022-09-01 18:00:00', 'Calle de las flores número 15 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 15', 'entrevista', '1992-05-08', 'productora 15', '2022-09-01 18:00:00', 'Calle de las flores número 15 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 16', 'pelicula', '2017-05-04', 'productora 16', 'lista participantes 16', 1, '00:14:00', '00:44:00', '00:29:00');
INSERT INTO eventos VALUES ('espectaculo 16', 'pelicula', '2017-05-04', 'productora 16', '2022-09-01 18:00:00', 'Calle de las flores número 16 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 16', 'pelicula', '2017-05-04', 'productora 16', '2022-09-01 18:00:00', 'Calle de las flores número 16 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 16', 'pelicula', '2017-05-04', 'productora 16', '2022-09-01 18:00:00', 'Calle de las flores número 16 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 16', 'pelicula', '2017-05-04', 'productora 16', '2022-09-01 18:00:00', 'Calle de las flores número 16 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 17', 'teatro', '2015-04-26', 'productora 17', 'lista participantes 17', 8, '00:12:00', '00:49:00', '00:28:00');
INSERT INTO eventos VALUES ('espectaculo 17', 'teatro', '2015-04-26', 'productora 17', '2022-09-01 18:00:00', 'Calle de las flores número 17 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 17', 'teatro', '2015-04-26', 'productora 17', '2022-09-01 18:00:00', 'Calle de las flores número 17 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 17', 'teatro', '2015-04-26', 'productora 17', '2022-09-01 18:00:00', 'Calle de las flores número 17 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 17', 'teatro', '2015-04-26', 'productora 17', '2022-09-01 18:00:00', 'Calle de las flores número 17 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 18', 'deportivo', '2005-10-03', 'productora 18', 'lista participantes 18', 5, '00:17:00', '00:51:00', '00:24:00');
INSERT INTO eventos VALUES ('espectaculo 18', 'deportivo', '2005-10-03', 'productora 18', '2022-09-01 18:00:00', 'Calle de las flores número 18 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 18', 'deportivo', '2005-10-03', 'productora 18', '2022-09-01 18:00:00', 'Calle de las flores número 18 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 18', 'deportivo', '2005-10-03', 'productora 18', '2022-09-01 18:00:00', 'Calle de las flores número 18 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 18', 'deportivo', '2005-10-03', 'productora 18', '2022-09-01 18:00:00', 'Calle de las flores número 18 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 19', 'pelicula', '1996-08-14', 'productora 19', 'lista participantes 19', 1, '00:12:00', '00:47:00', '00:24:00');
INSERT INTO eventos VALUES ('espectaculo 19', 'pelicula', '1996-08-14', 'productora 19', '2022-09-01 18:00:00', 'Calle de las flores número 19 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 19', 'pelicula', '1996-08-14', 'productora 19', '2022-09-01 18:00:00', 'Calle de las flores número 19 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 19', 'pelicula', '1996-08-14', 'productora 19', '2022-09-01 18:00:00', 'Calle de las flores número 19 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 19', 'pelicula', '1996-08-14', 'productora 19', '2022-09-01 18:00:00', 'Calle de las flores número 19 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 20', 'deportivo', '1991-05-22', 'productora 20', 'lista participantes 20', 3, '00:14:00', '00:36:00', '00:23:00');
INSERT INTO eventos VALUES ('espectaculo 20', 'deportivo', '1991-05-22', 'productora 20', '2022-09-01 18:00:00', 'Calle de las flores número 20 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 20', 'deportivo', '1991-05-22', 'productora 20', '2022-09-01 18:00:00', 'Calle de las flores número 20 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 20', 'deportivo', '1991-05-22', 'productora 20', '2022-09-01 18:00:00', 'Calle de las flores número 20 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 20', 'deportivo', '1991-05-22', 'productora 20', '2022-09-01 18:00:00', 'Calle de las flores número 20 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 21', 'teatro', '2001-11-05', 'productora 21', 'lista participantes 21', 1, '00:15:00', '00:47:00', '00:27:00');
INSERT INTO eventos VALUES ('espectaculo 21', 'teatro', '2001-11-05', 'productora 21', '2022-09-01 18:00:00', 'Calle de las flores número 21 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 21', 'teatro', '2001-11-05', 'productora 21', '2022-09-01 18:00:00', 'Calle de las flores número 21 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 21', 'teatro', '2001-11-05', 'productora 21', '2022-09-01 18:00:00', 'Calle de las flores número 21 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 21', 'teatro', '2001-11-05', 'productora 21', '2022-09-01 18:00:00', 'Calle de las flores número 21 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 22', 'pelicula', '2006-02-20', 'productora 22', 'lista participantes 22', 1, '00:11:00', '00:17:00', '00:25:00');
INSERT INTO eventos VALUES ('espectaculo 22', 'pelicula', '2006-02-20', 'productora 22', '2022-09-01 18:00:00', 'Calle de las flores número 22 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 22', 'pelicula', '2006-02-20', 'productora 22', '2022-09-01 18:00:00', 'Calle de las flores número 22 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 22', 'pelicula', '2006-02-20', 'productora 22', '2022-09-01 18:00:00', 'Calle de las flores número 22 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 22', 'pelicula', '2006-02-20', 'productora 22', '2022-09-01 18:00:00', 'Calle de las flores número 22 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 23', 'teatro', '1997-03-16', 'productora 23', 'lista participantes 23', 8, '00:19:00', '00:54:00', '00:22:00');
INSERT INTO eventos VALUES ('espectaculo 23', 'teatro', '1997-03-16', 'productora 23', '2022-09-01 18:00:00', 'Calle de las flores número 23 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 23', 'teatro', '1997-03-16', 'productora 23', '2022-09-01 18:00:00', 'Calle de las flores número 23 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 23', 'teatro', '1997-03-16', 'productora 23', '2022-09-01 18:00:00', 'Calle de las flores número 23 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 23', 'teatro', '1997-03-16', 'productora 23', '2022-09-01 18:00:00', 'Calle de las flores número 23 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 24', 'concierto', '2008-05-12', 'productora 24', 'lista participantes 24', 7, '00:14:00', '00:21:00', '00:15:00');
INSERT INTO eventos VALUES ('espectaculo 24', 'concierto', '2008-05-12', 'productora 24', '2022-09-01 18:00:00', 'Calle de las flores número 24 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 24', 'concierto', '2008-05-12', 'productora 24', '2022-09-01 18:00:00', 'Calle de las flores número 24 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 24', 'concierto', '2008-05-12', 'productora 24', '2022-09-01 18:00:00', 'Calle de las flores número 24 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 24', 'concierto', '2008-05-12', 'productora 24', '2022-09-01 18:00:00', 'Calle de las flores número 24 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 25', 'teatro', '1985-03-27', 'productora 25', 'lista participantes 25', 7, '00:16:00', '00:44:00', '00:18:00');
INSERT INTO eventos VALUES ('espectaculo 25', 'teatro', '1985-03-27', 'productora 25', '2022-09-01 18:00:00', 'Calle de las flores número 25 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 25', 'teatro', '1985-03-27', 'productora 25', '2022-09-01 18:00:00', 'Calle de las flores número 25 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 25', 'teatro', '1985-03-27', 'productora 25', '2022-09-01 18:00:00', 'Calle de las flores número 25 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 25', 'teatro', '1985-03-27', 'productora 25', '2022-09-01 18:00:00', 'Calle de las flores número 25 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 26', 'concierto', '2001-01-11', 'productora 26', 'lista participantes 26', 1, '00:19:00', '00:24:00', '00:25:00');
INSERT INTO eventos VALUES ('espectaculo 26', 'concierto', '2001-01-11', 'productora 26', '2022-09-01 18:00:00', 'Calle de las flores número 26 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 26', 'concierto', '2001-01-11', 'productora 26', '2022-09-01 18:00:00', 'Calle de las flores número 26 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 26', 'concierto', '2001-01-11', 'productora 26', '2022-09-01 18:00:00', 'Calle de las flores número 26 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 26', 'concierto', '2001-01-11', 'productora 26', '2022-09-01 18:00:00', 'Calle de las flores número 26 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 27', 'deportivo', '1997-07-10', 'productora 27', 'lista participantes 27', 9, '00:13:00', '00:37:00', '00:19:00');
INSERT INTO eventos VALUES ('espectaculo 27', 'deportivo', '1997-07-10', 'productora 27', '2022-09-01 18:00:00', 'Calle de las flores número 27 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 27', 'deportivo', '1997-07-10', 'productora 27', '2022-09-01 18:00:00', 'Calle de las flores número 27 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 27', 'deportivo', '1997-07-10', 'productora 27', '2022-09-01 18:00:00', 'Calle de las flores número 27 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 27', 'deportivo', '1997-07-10', 'productora 27', '2022-09-01 18:00:00', 'Calle de las flores número 27 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 28', 'concierto', '2019-04-03', 'productora 28', 'lista participantes 28', 1, '00:12:00', '00:54:00', '00:19:00');
INSERT INTO eventos VALUES ('espectaculo 28', 'concierto', '2019-04-03', 'productora 28', '2022-09-01 18:00:00', 'Calle de las flores número 28 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 28', 'concierto', '2019-04-03', 'productora 28', '2022-09-01 18:00:00', 'Calle de las flores número 28 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 28', 'concierto', '2019-04-03', 'productora 28', '2022-09-01 18:00:00', 'Calle de las flores número 28 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 28', 'concierto', '2019-04-03', 'productora 28', '2022-09-01 18:00:00', 'Calle de las flores número 28 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 29', 'concierto', '1991-04-11', 'productora 29', 'lista participantes 29', 8, '00:12:00', '00:19:00', '00:17:00');
INSERT INTO eventos VALUES ('espectaculo 29', 'concierto', '1991-04-11', 'productora 29', '2022-09-01 18:00:00', 'Calle de las flores número 29 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 29', 'concierto', '1991-04-11', 'productora 29', '2022-09-01 18:00:00', 'Calle de las flores número 29 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 29', 'concierto', '1991-04-11', 'productora 29', '2022-09-01 18:00:00', 'Calle de las flores número 29 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 29', 'concierto', '1991-04-11', 'productora 29', '2022-09-01 18:00:00', 'Calle de las flores número 29 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 30', 'teatro', '2013-11-14', 'productora 30', 'lista participantes 30', 8, '00:19:00', '00:45:00', '00:28:00');
INSERT INTO eventos VALUES ('espectaculo 30', 'teatro', '2013-11-14', 'productora 30', '2022-09-01 18:00:00', 'Calle de las flores número 30 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 30', 'teatro', '2013-11-14', 'productora 30', '2022-09-01 18:00:00', 'Calle de las flores número 30 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 30', 'teatro', '2013-11-14', 'productora 30', '2022-09-01 18:00:00', 'Calle de las flores número 30 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 30', 'teatro', '2013-11-14', 'productora 30', '2022-09-01 18:00:00', 'Calle de las flores número 30 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 31', 'concierto', '2009-10-15', 'productora 31', 'lista participantes 31', 3, '00:18:00', '00:44:00', '00:15:00');
INSERT INTO eventos VALUES ('espectaculo 31', 'concierto', '2009-10-15', 'productora 31', '2022-09-01 18:00:00', 'Calle de las flores número 31 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 31', 'concierto', '2009-10-15', 'productora 31', '2022-09-01 18:00:00', 'Calle de las flores número 31 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 31', 'concierto', '2009-10-15', 'productora 31', '2022-09-01 18:00:00', 'Calle de las flores número 31 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 31', 'concierto', '2009-10-15', 'productora 31', '2022-09-01 18:00:00', 'Calle de las flores número 31 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 32', 'entrevista', '1998-07-26', 'productora 32', 'lista participantes 32', 3, '00:10:00', '00:43:00', '00:25:00');
INSERT INTO eventos VALUES ('espectaculo 32', 'entrevista', '1998-07-26', 'productora 32', '2022-09-01 18:00:00', 'Calle de las flores número 32 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 32', 'entrevista', '1998-07-26', 'productora 32', '2022-09-01 18:00:00', 'Calle de las flores número 32 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 32', 'entrevista', '1998-07-26', 'productora 32', '2022-09-01 18:00:00', 'Calle de las flores número 32 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 32', 'entrevista', '1998-07-26', 'productora 32', '2022-09-01 18:00:00', 'Calle de las flores número 32 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 33', 'deportivo', '1995-11-11', 'productora 33', 'lista participantes 33', 5, '00:13:00', '00:39:00', '00:20:00');
INSERT INTO eventos VALUES ('espectaculo 33', 'deportivo', '1995-11-11', 'productora 33', '2022-09-01 18:00:00', 'Calle de las flores número 33 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 33', 'deportivo', '1995-11-11', 'productora 33', '2022-09-01 18:00:00', 'Calle de las flores número 33 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 33', 'deportivo', '1995-11-11', 'productora 33', '2022-09-01 18:00:00', 'Calle de las flores número 33 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 33', 'deportivo', '1995-11-11', 'productora 33', '2022-09-01 18:00:00', 'Calle de las flores número 33 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 34', 'teatro', '2016-05-04', 'productora 34', 'lista participantes 34', 7, '00:18:00', '00:41:00', '00:22:00');
INSERT INTO eventos VALUES ('espectaculo 34', 'teatro', '2016-05-04', 'productora 34', '2022-09-01 18:00:00', 'Calle de las flores número 34 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 34', 'teatro', '2016-05-04', 'productora 34', '2022-09-01 18:00:00', 'Calle de las flores número 34 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 34', 'teatro', '2016-05-04', 'productora 34', '2022-09-01 18:00:00', 'Calle de las flores número 34 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 34', 'teatro', '2016-05-04', 'productora 34', '2022-09-01 18:00:00', 'Calle de las flores número 34 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 35', 'teatro', '1991-06-01', 'productora 35', 'lista participantes 35', 3, '00:15:00', '00:15:00', '00:20:00');
INSERT INTO eventos VALUES ('espectaculo 35', 'teatro', '1991-06-01', 'productora 35', '2022-09-01 18:00:00', 'Calle de las flores número 35 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 35', 'teatro', '1991-06-01', 'productora 35', '2022-09-01 18:00:00', 'Calle de las flores número 35 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 35', 'teatro', '1991-06-01', 'productora 35', '2022-09-01 18:00:00', 'Calle de las flores número 35 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 35', 'teatro', '1991-06-01', 'productora 35', '2022-09-01 18:00:00', 'Calle de las flores número 35 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 36', 'deportivo', '2004-06-21', 'productora 36', 'lista participantes 36', 2, '00:12:00', '00:29:00', '00:22:00');
INSERT INTO eventos VALUES ('espectaculo 36', 'deportivo', '2004-06-21', 'productora 36', '2022-09-01 18:00:00', 'Calle de las flores número 36 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 36', 'deportivo', '2004-06-21', 'productora 36', '2022-09-01 18:00:00', 'Calle de las flores número 36 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 36', 'deportivo', '2004-06-21', 'productora 36', '2022-09-01 18:00:00', 'Calle de las flores número 36 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 36', 'deportivo', '2004-06-21', 'productora 36', '2022-09-01 18:00:00', 'Calle de las flores número 36 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 37', 'deportivo', '1994-04-27', 'productora 37', 'lista participantes 37', 1, '00:10:00', '00:21:00', '00:27:00');
INSERT INTO eventos VALUES ('espectaculo 37', 'deportivo', '1994-04-27', 'productora 37', '2022-09-01 18:00:00', 'Calle de las flores número 37 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 37', 'deportivo', '1994-04-27', 'productora 37', '2022-09-01 18:00:00', 'Calle de las flores número 37 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 37', 'deportivo', '1994-04-27', 'productora 37', '2022-09-01 18:00:00', 'Calle de las flores número 37 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 37', 'deportivo', '1994-04-27', 'productora 37', '2022-09-01 18:00:00', 'Calle de las flores número 37 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 38', 'concierto', '1992-05-01', 'productora 38', 'lista participantes 38', 5, '00:17:00', '00:15:00', '00:23:00');
INSERT INTO eventos VALUES ('espectaculo 38', 'concierto', '1992-05-01', 'productora 38', '2022-09-01 18:00:00', 'Calle de las flores número 38 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 38', 'concierto', '1992-05-01', 'productora 38', '2022-09-01 18:00:00', 'Calle de las flores número 38 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 38', 'concierto', '1992-05-01', 'productora 38', '2022-09-01 18:00:00', 'Calle de las flores número 38 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 38', 'concierto', '1992-05-01', 'productora 38', '2022-09-01 18:00:00', 'Calle de las flores número 38 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 39', 'deportivo', '1998-08-02', 'productora 39', 'lista participantes 39', 8, '00:17:00', '00:42:00', '00:18:00');
INSERT INTO eventos VALUES ('espectaculo 39', 'deportivo', '1998-08-02', 'productora 39', '2022-09-01 18:00:00', 'Calle de las flores número 39 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 39', 'deportivo', '1998-08-02', 'productora 39', '2022-09-01 18:00:00', 'Calle de las flores número 39 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 39', 'deportivo', '1998-08-02', 'productora 39', '2022-09-01 18:00:00', 'Calle de las flores número 39 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 39', 'deportivo', '1998-08-02', 'productora 39', '2022-09-01 18:00:00', 'Calle de las flores número 39 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 40', 'deportivo', '1998-04-07', 'productora 40', 'lista participantes 40', 1, '00:18:00', '00:40:00', '00:26:00');
INSERT INTO eventos VALUES ('espectaculo 40', 'deportivo', '1998-04-07', 'productora 40', '2022-09-01 18:00:00', 'Calle de las flores número 40 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 40', 'deportivo', '1998-04-07', 'productora 40', '2022-09-01 18:00:00', 'Calle de las flores número 40 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 40', 'deportivo', '1998-04-07', 'productora 40', '2022-09-01 18:00:00', 'Calle de las flores número 40 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 40', 'deportivo', '1998-04-07', 'productora 40', '2022-09-01 18:00:00', 'Calle de las flores número 40 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 41', 'teatro', '2007-11-02', 'productora 41', 'lista participantes 41', 1, '00:12:00', '00:19:00', '00:21:00');
INSERT INTO eventos VALUES ('espectaculo 41', 'teatro', '2007-11-02', 'productora 41', '2022-09-01 18:00:00', 'Calle de las flores número 41 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 41', 'teatro', '2007-11-02', 'productora 41', '2022-09-01 18:00:00', 'Calle de las flores número 41 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 41', 'teatro', '2007-11-02', 'productora 41', '2022-09-01 18:00:00', 'Calle de las flores número 41 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 41', 'teatro', '2007-11-02', 'productora 41', '2022-09-01 18:00:00', 'Calle de las flores número 41 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 42', 'concierto', '2003-02-24', 'productora 42', 'lista participantes 42', 3, '00:17:00', '00:47:00', '00:27:00');
INSERT INTO eventos VALUES ('espectaculo 42', 'concierto', '2003-02-24', 'productora 42', '2022-09-01 18:00:00', 'Calle de las flores número 42 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 42', 'concierto', '2003-02-24', 'productora 42', '2022-09-01 18:00:00', 'Calle de las flores número 42 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 42', 'concierto', '2003-02-24', 'productora 42', '2022-09-01 18:00:00', 'Calle de las flores número 42 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 42', 'concierto', '2003-02-24', 'productora 42', '2022-09-01 18:00:00', 'Calle de las flores número 42 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 43', 'entrevista', '1986-01-06', 'productora 43', 'lista participantes 43', 6, '00:19:00', '00:33:00', '00:22:00');
INSERT INTO eventos VALUES ('espectaculo 43', 'entrevista', '1986-01-06', 'productora 43', '2022-09-01 18:00:00', 'Calle de las flores número 43 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 43', 'entrevista', '1986-01-06', 'productora 43', '2022-09-01 18:00:00', 'Calle de las flores número 43 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 43', 'entrevista', '1986-01-06', 'productora 43', '2022-09-01 18:00:00', 'Calle de las flores número 43 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 43', 'entrevista', '1986-01-06', 'productora 43', '2022-09-01 18:00:00', 'Calle de las flores número 43 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 44', 'teatro', '1989-05-16', 'productora 44', 'lista participantes 44', 7, '00:15:00', '00:45:00', '00:21:00');
INSERT INTO eventos VALUES ('espectaculo 44', 'teatro', '1989-05-16', 'productora 44', '2022-09-01 18:00:00', 'Calle de las flores número 44 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 44', 'teatro', '1989-05-16', 'productora 44', '2022-09-01 18:00:00', 'Calle de las flores número 44 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 44', 'teatro', '1989-05-16', 'productora 44', '2022-09-01 18:00:00', 'Calle de las flores número 44 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 44', 'teatro', '1989-05-16', 'productora 44', '2022-09-01 18:00:00', 'Calle de las flores número 44 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 45', 'teatro', '2016-07-13', 'productora 45', 'lista participantes 45', 3, '00:13:00', '00:52:00', '00:29:00');
INSERT INTO eventos VALUES ('espectaculo 45', 'teatro', '2016-07-13', 'productora 45', '2022-09-01 18:00:00', 'Calle de las flores número 45 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 45', 'teatro', '2016-07-13', 'productora 45', '2022-09-01 18:00:00', 'Calle de las flores número 45 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 45', 'teatro', '2016-07-13', 'productora 45', '2022-09-01 18:00:00', 'Calle de las flores número 45 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 45', 'teatro', '2016-07-13', 'productora 45', '2022-09-01 18:00:00', 'Calle de las flores número 45 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 46', 'pelicula', '2013-02-09', 'productora 46', 'lista participantes 46', 7, '00:15:00', '00:56:00', '00:17:00');
INSERT INTO eventos VALUES ('espectaculo 46', 'pelicula', '2013-02-09', 'productora 46', '2022-09-01 18:00:00', 'Calle de las flores número 46 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 46', 'pelicula', '2013-02-09', 'productora 46', '2022-09-01 18:00:00', 'Calle de las flores número 46 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 46', 'pelicula', '2013-02-09', 'productora 46', '2022-09-01 18:00:00', 'Calle de las flores número 46 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 46', 'pelicula', '2013-02-09', 'productora 46', '2022-09-01 18:00:00', 'Calle de las flores número 46 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 47', 'deportivo', '2020-10-24', 'productora 47', 'lista participantes 47', 5, '00:18:00', '00:24:00', '00:27:00');
INSERT INTO eventos VALUES ('espectaculo 47', 'deportivo', '2020-10-24', 'productora 47', '2022-09-01 18:00:00', 'Calle de las flores número 47 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 47', 'deportivo', '2020-10-24', 'productora 47', '2022-09-01 18:00:00', 'Calle de las flores número 47 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 47', 'deportivo', '2020-10-24', 'productora 47', '2022-09-01 18:00:00', 'Calle de las flores número 47 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 47', 'deportivo', '2020-10-24', 'productora 47', '2022-09-01 18:00:00', 'Calle de las flores número 47 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 48', 'concierto', '1991-10-15', 'productora 48', 'lista participantes 48', 6, '00:12:00', '00:22:00', '00:16:00');
INSERT INTO eventos VALUES ('espectaculo 48', 'concierto', '1991-10-15', 'productora 48', '2022-09-01 18:00:00', 'Calle de las flores número 48 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 48', 'concierto', '1991-10-15', 'productora 48', '2022-09-01 18:00:00', 'Calle de las flores número 48 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 48', 'concierto', '1991-10-15', 'productora 48', '2022-09-01 18:00:00', 'Calle de las flores número 48 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 48', 'concierto', '1991-10-15', 'productora 48', '2022-09-01 18:00:00', 'Calle de las flores número 48 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 49', 'deportivo', '1996-09-03', 'productora 49', 'lista participantes 49', 2, '00:19:00', '00:35:00', '00:18:00');
INSERT INTO eventos VALUES ('espectaculo 49', 'deportivo', '1996-09-03', 'productora 49', '2022-09-01 18:00:00', 'Calle de las flores número 49 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 49', 'deportivo', '1996-09-03', 'productora 49', '2022-09-01 18:00:00', 'Calle de las flores número 49 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 49', 'deportivo', '1996-09-03', 'productora 49', '2022-09-01 18:00:00', 'Calle de las flores número 49 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 49', 'deportivo', '1996-09-03', 'productora 49', '2022-09-01 18:00:00', 'Calle de las flores número 49 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 50', 'pelicula', '2016-06-02', 'productora 50', 'lista participantes 50', 2, '00:19:00', '00:37:00', '00:25:00');
INSERT INTO eventos VALUES ('espectaculo 50', 'pelicula', '2016-06-02', 'productora 50', '2022-09-01 18:00:00', 'Calle de las flores número 50 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 50', 'pelicula', '2016-06-02', 'productora 50', '2022-09-01 18:00:00', 'Calle de las flores número 50 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 50', 'pelicula', '2016-06-02', 'productora 50', '2022-09-01 18:00:00', 'Calle de las flores número 50 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 50', 'pelicula', '2016-06-02', 'productora 50', '2022-09-01 18:00:00', 'Calle de las flores número 50 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 51', 'teatro', '2003-07-19', 'productora 51', 'lista participantes 51', 7, '00:18:00', '00:37:00', '00:15:00');
INSERT INTO eventos VALUES ('espectaculo 51', 'teatro', '2003-07-19', 'productora 51', '2022-09-01 18:00:00', 'Calle de las flores número 51 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 51', 'teatro', '2003-07-19', 'productora 51', '2022-09-01 18:00:00', 'Calle de las flores número 51 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 51', 'teatro', '2003-07-19', 'productora 51', '2022-09-01 18:00:00', 'Calle de las flores número 51 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 51', 'teatro', '2003-07-19', 'productora 51', '2022-09-01 18:00:00', 'Calle de las flores número 51 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 52', 'entrevista', '1998-09-15', 'productora 52', 'lista participantes 52', 4, '00:12:00', '00:49:00', '00:17:00');
INSERT INTO eventos VALUES ('espectaculo 52', 'entrevista', '1998-09-15', 'productora 52', '2022-09-01 18:00:00', 'Calle de las flores número 52 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 52', 'entrevista', '1998-09-15', 'productora 52', '2022-09-01 18:00:00', 'Calle de las flores número 52 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 52', 'entrevista', '1998-09-15', 'productora 52', '2022-09-01 18:00:00', 'Calle de las flores número 52 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 52', 'entrevista', '1998-09-15', 'productora 52', '2022-09-01 18:00:00', 'Calle de las flores número 52 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 53', 'concierto', '2003-11-05', 'productora 53', 'lista participantes 53', 2, '00:11:00', '00:16:00', '00:27:00');
INSERT INTO eventos VALUES ('espectaculo 53', 'concierto', '2003-11-05', 'productora 53', '2022-09-01 18:00:00', 'Calle de las flores número 53 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 53', 'concierto', '2003-11-05', 'productora 53', '2022-09-01 18:00:00', 'Calle de las flores número 53 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 53', 'concierto', '2003-11-05', 'productora 53', '2022-09-01 18:00:00', 'Calle de las flores número 53 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 53', 'concierto', '2003-11-05', 'productora 53', '2022-09-01 18:00:00', 'Calle de las flores número 53 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 54', 'teatro', '2010-02-15', 'productora 54', 'lista participantes 54', 3, '00:13:00', '00:52:00', '00:23:00');
INSERT INTO eventos VALUES ('espectaculo 54', 'teatro', '2010-02-15', 'productora 54', '2022-09-01 18:00:00', 'Calle de las flores número 54 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 54', 'teatro', '2010-02-15', 'productora 54', '2022-09-01 18:00:00', 'Calle de las flores número 54 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 54', 'teatro', '2010-02-15', 'productora 54', '2022-09-01 18:00:00', 'Calle de las flores número 54 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 54', 'teatro', '2010-02-15', 'productora 54', '2022-09-01 18:00:00', 'Calle de las flores número 54 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 55', 'pelicula', '2019-11-10', 'productora 55', 'lista participantes 55', 7, '00:17:00', '00:36:00', '00:29:00');
INSERT INTO eventos VALUES ('espectaculo 55', 'pelicula', '2019-11-10', 'productora 55', '2022-09-01 18:00:00', 'Calle de las flores número 55 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 55', 'pelicula', '2019-11-10', 'productora 55', '2022-09-01 18:00:00', 'Calle de las flores número 55 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 55', 'pelicula', '2019-11-10', 'productora 55', '2022-09-01 18:00:00', 'Calle de las flores número 55 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 55', 'pelicula', '2019-11-10', 'productora 55', '2022-09-01 18:00:00', 'Calle de las flores número 55 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 56', 'pelicula', '2020-06-11', 'productora 56', 'lista participantes 56', 9, '00:13:00', '00:33:00', '00:17:00');
INSERT INTO eventos VALUES ('espectaculo 56', 'pelicula', '2020-06-11', 'productora 56', '2022-09-01 18:00:00', 'Calle de las flores número 56 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 56', 'pelicula', '2020-06-11', 'productora 56', '2022-09-01 18:00:00', 'Calle de las flores número 56 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 56', 'pelicula', '2020-06-11', 'productora 56', '2022-09-01 18:00:00', 'Calle de las flores número 56 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 56', 'pelicula', '2020-06-11', 'productora 56', '2022-09-01 18:00:00', 'Calle de las flores número 56 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 57', 'teatro', '1990-02-18', 'productora 57', 'lista participantes 57', 8, '00:13:00', '00:43:00', '00:27:00');
INSERT INTO eventos VALUES ('espectaculo 57', 'teatro', '1990-02-18', 'productora 57', '2022-09-01 18:00:00', 'Calle de las flores número 57 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 57', 'teatro', '1990-02-18', 'productora 57', '2022-09-01 18:00:00', 'Calle de las flores número 57 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 57', 'teatro', '1990-02-18', 'productora 57', '2022-09-01 18:00:00', 'Calle de las flores número 57 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 57', 'teatro', '1990-02-18', 'productora 57', '2022-09-01 18:00:00', 'Calle de las flores número 57 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 58', 'pelicula', '2004-10-15', 'productora 58', 'lista participantes 58', 2, '00:19:00', '00:31:00', '00:19:00');
INSERT INTO eventos VALUES ('espectaculo 58', 'pelicula', '2004-10-15', 'productora 58', '2022-09-01 18:00:00', 'Calle de las flores número 58 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 58', 'pelicula', '2004-10-15', 'productora 58', '2022-09-01 18:00:00', 'Calle de las flores número 58 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 58', 'pelicula', '2004-10-15', 'productora 58', '2022-09-01 18:00:00', 'Calle de las flores número 58 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 58', 'pelicula', '2004-10-15', 'productora 58', '2022-09-01 18:00:00', 'Calle de las flores número 58 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 59', 'deportivo', '2011-06-09', 'productora 59', 'lista participantes 59', 9, '00:11:00', '00:58:00', '00:18:00');
INSERT INTO eventos VALUES ('espectaculo 59', 'deportivo', '2011-06-09', 'productora 59', '2022-09-01 18:00:00', 'Calle de las flores número 59 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 59', 'deportivo', '2011-06-09', 'productora 59', '2022-09-01 18:00:00', 'Calle de las flores número 59 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 59', 'deportivo', '2011-06-09', 'productora 59', '2022-09-01 18:00:00', 'Calle de las flores número 59 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 59', 'deportivo', '2011-06-09', 'productora 59', '2022-09-01 18:00:00', 'Calle de las flores número 59 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 60', 'pelicula', '1985-06-13', 'productora 60', 'lista participantes 60', 2, '00:14:00', '00:18:00', '00:23:00');
INSERT INTO eventos VALUES ('espectaculo 60', 'pelicula', '1985-06-13', 'productora 60', '2022-09-01 18:00:00', 'Calle de las flores número 60 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 60', 'pelicula', '1985-06-13', 'productora 60', '2022-09-01 18:00:00', 'Calle de las flores número 60 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 60', 'pelicula', '1985-06-13', 'productora 60', '2022-09-01 18:00:00', 'Calle de las flores número 60 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 60', 'pelicula', '1985-06-13', 'productora 60', '2022-09-01 18:00:00', 'Calle de las flores número 60 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 61', 'pelicula', '2018-11-23', 'productora 61', 'lista participantes 61', 4, '00:18:00', '00:45:00', '00:26:00');
INSERT INTO eventos VALUES ('espectaculo 61', 'pelicula', '2018-11-23', 'productora 61', '2022-09-01 18:00:00', 'Calle de las flores número 61 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 61', 'pelicula', '2018-11-23', 'productora 61', '2022-09-01 18:00:00', 'Calle de las flores número 61 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 61', 'pelicula', '2018-11-23', 'productora 61', '2022-09-01 18:00:00', 'Calle de las flores número 61 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 61', 'pelicula', '2018-11-23', 'productora 61', '2022-09-01 18:00:00', 'Calle de las flores número 61 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 62', 'pelicula', '2007-04-04', 'productora 62', 'lista participantes 62', 1, '00:14:00', '00:35:00', '00:16:00');
INSERT INTO eventos VALUES ('espectaculo 62', 'pelicula', '2007-04-04', 'productora 62', '2022-09-01 18:00:00', 'Calle de las flores número 62 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 62', 'pelicula', '2007-04-04', 'productora 62', '2022-09-01 18:00:00', 'Calle de las flores número 62 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 62', 'pelicula', '2007-04-04', 'productora 62', '2022-09-01 18:00:00', 'Calle de las flores número 62 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 62', 'pelicula', '2007-04-04', 'productora 62', '2022-09-01 18:00:00', 'Calle de las flores número 62 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 63', 'entrevista', '1998-09-23', 'productora 63', 'lista participantes 63', 9, '00:13:00', '00:38:00', '00:28:00');
INSERT INTO eventos VALUES ('espectaculo 63', 'entrevista', '1998-09-23', 'productora 63', '2022-09-01 18:00:00', 'Calle de las flores número 63 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 63', 'entrevista', '1998-09-23', 'productora 63', '2022-09-01 18:00:00', 'Calle de las flores número 63 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 63', 'entrevista', '1998-09-23', 'productora 63', '2022-09-01 18:00:00', 'Calle de las flores número 63 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 63', 'entrevista', '1998-09-23', 'productora 63', '2022-09-01 18:00:00', 'Calle de las flores número 63 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 64', 'pelicula', '1997-02-03', 'productora 64', 'lista participantes 64', 8, '00:19:00', '00:19:00', '00:28:00');
INSERT INTO eventos VALUES ('espectaculo 64', 'pelicula', '1997-02-03', 'productora 64', '2022-09-01 18:00:00', 'Calle de las flores número 64 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 64', 'pelicula', '1997-02-03', 'productora 64', '2022-09-01 18:00:00', 'Calle de las flores número 64 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 64', 'pelicula', '1997-02-03', 'productora 64', '2022-09-01 18:00:00', 'Calle de las flores número 64 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 64', 'pelicula', '1997-02-03', 'productora 64', '2022-09-01 18:00:00', 'Calle de las flores número 64 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 65', 'deportivo', '1987-09-20', 'productora 65', 'lista participantes 65', 4, '00:18:00', '00:54:00', '00:16:00');
INSERT INTO eventos VALUES ('espectaculo 65', 'deportivo', '1987-09-20', 'productora 65', '2022-09-01 18:00:00', 'Calle de las flores número 65 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 65', 'deportivo', '1987-09-20', 'productora 65', '2022-09-01 18:00:00', 'Calle de las flores número 65 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 65', 'deportivo', '1987-09-20', 'productora 65', '2022-09-01 18:00:00', 'Calle de las flores número 65 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 65', 'deportivo', '1987-09-20', 'productora 65', '2022-09-01 18:00:00', 'Calle de las flores número 65 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 66', 'concierto', '2013-02-24', 'productora 66', 'lista participantes 66', 1, '00:12:00', '00:19:00', '00:26:00');
INSERT INTO eventos VALUES ('espectaculo 66', 'concierto', '2013-02-24', 'productora 66', '2022-09-01 18:00:00', 'Calle de las flores número 66 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 66', 'concierto', '2013-02-24', 'productora 66', '2022-09-01 18:00:00', 'Calle de las flores número 66 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 66', 'concierto', '2013-02-24', 'productora 66', '2022-09-01 18:00:00', 'Calle de las flores número 66 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 66', 'concierto', '2013-02-24', 'productora 66', '2022-09-01 18:00:00', 'Calle de las flores número 66 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 67', 'pelicula', '2001-09-19', 'productora 67', 'lista participantes 67', 4, '00:19:00', '00:50:00', '00:18:00');
INSERT INTO eventos VALUES ('espectaculo 67', 'pelicula', '2001-09-19', 'productora 67', '2022-09-01 18:00:00', 'Calle de las flores número 67 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 67', 'pelicula', '2001-09-19', 'productora 67', '2022-09-01 18:00:00', 'Calle de las flores número 67 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 67', 'pelicula', '2001-09-19', 'productora 67', '2022-09-01 18:00:00', 'Calle de las flores número 67 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 67', 'pelicula', '2001-09-19', 'productora 67', '2022-09-01 18:00:00', 'Calle de las flores número 67 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 68', 'concierto', '2003-11-08', 'productora 68', 'lista participantes 68', 1, '00:19:00', '00:41:00', '00:24:00');
INSERT INTO eventos VALUES ('espectaculo 68', 'concierto', '2003-11-08', 'productora 68', '2022-09-01 18:00:00', 'Calle de las flores número 68 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 68', 'concierto', '2003-11-08', 'productora 68', '2022-09-01 18:00:00', 'Calle de las flores número 68 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 68', 'concierto', '2003-11-08', 'productora 68', '2022-09-01 18:00:00', 'Calle de las flores número 68 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 68', 'concierto', '2003-11-08', 'productora 68', '2022-09-01 18:00:00', 'Calle de las flores número 68 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 69', 'pelicula', '1987-09-08', 'productora 69', 'lista participantes 69', 5, '00:12:00', '00:32:00', '00:23:00');
INSERT INTO eventos VALUES ('espectaculo 69', 'pelicula', '1987-09-08', 'productora 69', '2022-09-01 18:00:00', 'Calle de las flores número 69 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 69', 'pelicula', '1987-09-08', 'productora 69', '2022-09-01 18:00:00', 'Calle de las flores número 69 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 69', 'pelicula', '1987-09-08', 'productora 69', '2022-09-01 18:00:00', 'Calle de las flores número 69 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 69', 'pelicula', '1987-09-08', 'productora 69', '2022-09-01 18:00:00', 'Calle de las flores número 69 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 70', 'teatro', '1985-01-09', 'productora 70', 'lista participantes 70', 9, '00:14:00', '00:22:00', '00:17:00');
INSERT INTO eventos VALUES ('espectaculo 70', 'teatro', '1985-01-09', 'productora 70', '2022-09-01 18:00:00', 'Calle de las flores número 70 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 70', 'teatro', '1985-01-09', 'productora 70', '2022-09-01 18:00:00', 'Calle de las flores número 70 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 70', 'teatro', '1985-01-09', 'productora 70', '2022-09-01 18:00:00', 'Calle de las flores número 70 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 70', 'teatro', '1985-01-09', 'productora 70', '2022-09-01 18:00:00', 'Calle de las flores número 70 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 71', 'entrevista', '2004-09-20', 'productora 71', 'lista participantes 71', 6, '00:15:00', '00:57:00', '00:15:00');
INSERT INTO eventos VALUES ('espectaculo 71', 'entrevista', '2004-09-20', 'productora 71', '2022-09-01 18:00:00', 'Calle de las flores número 71 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 71', 'entrevista', '2004-09-20', 'productora 71', '2022-09-01 18:00:00', 'Calle de las flores número 71 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 71', 'entrevista', '2004-09-20', 'productora 71', '2022-09-01 18:00:00', 'Calle de las flores número 71 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 71', 'entrevista', '2004-09-20', 'productora 71', '2022-09-01 18:00:00', 'Calle de las flores número 71 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 72', 'entrevista', '1997-02-24', 'productora 72', 'lista participantes 72', 8, '00:13:00', '00:57:00', '00:20:00');
INSERT INTO eventos VALUES ('espectaculo 72', 'entrevista', '1997-02-24', 'productora 72', '2022-09-01 18:00:00', 'Calle de las flores número 72 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 72', 'entrevista', '1997-02-24', 'productora 72', '2022-09-01 18:00:00', 'Calle de las flores número 72 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 72', 'entrevista', '1997-02-24', 'productora 72', '2022-09-01 18:00:00', 'Calle de las flores número 72 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 72', 'entrevista', '1997-02-24', 'productora 72', '2022-09-01 18:00:00', 'Calle de las flores número 72 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 73', 'entrevista', '2008-07-05', 'productora 73', 'lista participantes 73', 4, '00:15:00', '00:32:00', '00:16:00');
INSERT INTO eventos VALUES ('espectaculo 73', 'entrevista', '2008-07-05', 'productora 73', '2022-09-01 18:00:00', 'Calle de las flores número 73 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 73', 'entrevista', '2008-07-05', 'productora 73', '2022-09-01 18:00:00', 'Calle de las flores número 73 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 73', 'entrevista', '2008-07-05', 'productora 73', '2022-09-01 18:00:00', 'Calle de las flores número 73 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 73', 'entrevista', '2008-07-05', 'productora 73', '2022-09-01 18:00:00', 'Calle de las flores número 73 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 74', 'concierto', '2003-03-05', 'productora 74', 'lista participantes 74', 5, '00:11:00', '00:36:00', '00:28:00');
INSERT INTO eventos VALUES ('espectaculo 74', 'concierto', '2003-03-05', 'productora 74', '2022-09-01 18:00:00', 'Calle de las flores número 74 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 74', 'concierto', '2003-03-05', 'productora 74', '2022-09-01 18:00:00', 'Calle de las flores número 74 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 74', 'concierto', '2003-03-05', 'productora 74', '2022-09-01 18:00:00', 'Calle de las flores número 74 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 74', 'concierto', '2003-03-05', 'productora 74', '2022-09-01 18:00:00', 'Calle de las flores número 74 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 75', 'deportivo', '2003-05-08', 'productora 75', 'lista participantes 75', 2, '00:12:00', '00:17:00', '00:21:00');
INSERT INTO eventos VALUES ('espectaculo 75', 'deportivo', '2003-05-08', 'productora 75', '2022-09-01 18:00:00', 'Calle de las flores número 75 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 75', 'deportivo', '2003-05-08', 'productora 75', '2022-09-01 18:00:00', 'Calle de las flores número 75 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 75', 'deportivo', '2003-05-08', 'productora 75', '2022-09-01 18:00:00', 'Calle de las flores número 75 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 75', 'deportivo', '2003-05-08', 'productora 75', '2022-09-01 18:00:00', 'Calle de las flores número 75 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 76', 'concierto', '2019-03-13', 'productora 76', 'lista participantes 76', 6, '00:16:00', '00:47:00', '00:20:00');
INSERT INTO eventos VALUES ('espectaculo 76', 'concierto', '2019-03-13', 'productora 76', '2022-09-01 18:00:00', 'Calle de las flores número 76 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 76', 'concierto', '2019-03-13', 'productora 76', '2022-09-01 18:00:00', 'Calle de las flores número 76 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 76', 'concierto', '2019-03-13', 'productora 76', '2022-09-01 18:00:00', 'Calle de las flores número 76 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 76', 'concierto', '2019-03-13', 'productora 76', '2022-09-01 18:00:00', 'Calle de las flores número 76 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 77', 'pelicula', '2001-04-02', 'productora 77', 'lista participantes 77', 9, '00:19:00', '00:24:00', '00:27:00');
INSERT INTO eventos VALUES ('espectaculo 77', 'pelicula', '2001-04-02', 'productora 77', '2022-09-01 18:00:00', 'Calle de las flores número 77 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 77', 'pelicula', '2001-04-02', 'productora 77', '2022-09-01 18:00:00', 'Calle de las flores número 77 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 77', 'pelicula', '2001-04-02', 'productora 77', '2022-09-01 18:00:00', 'Calle de las flores número 77 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 77', 'pelicula', '2001-04-02', 'productora 77', '2022-09-01 18:00:00', 'Calle de las flores número 77 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 78', 'deportivo', '2000-03-16', 'productora 78', 'lista participantes 78', 6, '00:18:00', '00:23:00', '00:29:00');
INSERT INTO eventos VALUES ('espectaculo 78', 'deportivo', '2000-03-16', 'productora 78', '2022-09-01 18:00:00', 'Calle de las flores número 78 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 78', 'deportivo', '2000-03-16', 'productora 78', '2022-09-01 18:00:00', 'Calle de las flores número 78 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 78', 'deportivo', '2000-03-16', 'productora 78', '2022-09-01 18:00:00', 'Calle de las flores número 78 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 78', 'deportivo', '2000-03-16', 'productora 78', '2022-09-01 18:00:00', 'Calle de las flores número 78 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 79', 'pelicula', '1997-11-02', 'productora 79', 'lista participantes 79', 7, '00:15:00', '00:45:00', '00:22:00');
INSERT INTO eventos VALUES ('espectaculo 79', 'pelicula', '1997-11-02', 'productora 79', '2022-09-01 18:00:00', 'Calle de las flores número 79 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 79', 'pelicula', '1997-11-02', 'productora 79', '2022-09-01 18:00:00', 'Calle de las flores número 79 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 79', 'pelicula', '1997-11-02', 'productora 79', '2022-09-01 18:00:00', 'Calle de las flores número 79 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 79', 'pelicula', '1997-11-02', 'productora 79', '2022-09-01 18:00:00', 'Calle de las flores número 79 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 80', 'deportivo', '2013-07-19', 'productora 80', 'lista participantes 80', 3, '00:13:00', '00:57:00', '00:26:00');
INSERT INTO eventos VALUES ('espectaculo 80', 'deportivo', '2013-07-19', 'productora 80', '2022-09-01 18:00:00', 'Calle de las flores número 80 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 80', 'deportivo', '2013-07-19', 'productora 80', '2022-09-01 18:00:00', 'Calle de las flores número 80 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 80', 'deportivo', '2013-07-19', 'productora 80', '2022-09-01 18:00:00', 'Calle de las flores número 80 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 80', 'deportivo', '2013-07-19', 'productora 80', '2022-09-01 18:00:00', 'Calle de las flores número 80 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 81', 'concierto', '2002-10-07', 'productora 81', 'lista participantes 81', 2, '00:12:00', '00:15:00', '00:15:00');
INSERT INTO eventos VALUES ('espectaculo 81', 'concierto', '2002-10-07', 'productora 81', '2022-09-01 18:00:00', 'Calle de las flores número 81 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 81', 'concierto', '2002-10-07', 'productora 81', '2022-09-01 18:00:00', 'Calle de las flores número 81 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 81', 'concierto', '2002-10-07', 'productora 81', '2022-09-01 18:00:00', 'Calle de las flores número 81 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 81', 'concierto', '2002-10-07', 'productora 81', '2022-09-01 18:00:00', 'Calle de las flores número 81 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 82', 'deportivo', '2020-04-18', 'productora 82', 'lista participantes 82', 2, '00:17:00', '00:23:00', '00:19:00');
INSERT INTO eventos VALUES ('espectaculo 82', 'deportivo', '2020-04-18', 'productora 82', '2022-09-01 18:00:00', 'Calle de las flores número 82 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 82', 'deportivo', '2020-04-18', 'productora 82', '2022-09-01 18:00:00', 'Calle de las flores número 82 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 82', 'deportivo', '2020-04-18', 'productora 82', '2022-09-01 18:00:00', 'Calle de las flores número 82 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 82', 'deportivo', '2020-04-18', 'productora 82', '2022-09-01 18:00:00', 'Calle de las flores número 82 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 83', 'entrevista', '2012-03-17', 'productora 83', 'lista participantes 83', 2, '00:19:00', '00:42:00', '00:27:00');
INSERT INTO eventos VALUES ('espectaculo 83', 'entrevista', '2012-03-17', 'productora 83', '2022-09-01 18:00:00', 'Calle de las flores número 83 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 83', 'entrevista', '2012-03-17', 'productora 83', '2022-09-01 18:00:00', 'Calle de las flores número 83 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 83', 'entrevista', '2012-03-17', 'productora 83', '2022-09-01 18:00:00', 'Calle de las flores número 83 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 83', 'entrevista', '2012-03-17', 'productora 83', '2022-09-01 18:00:00', 'Calle de las flores número 83 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 84', 'deportivo', '2015-02-04', 'productora 84', 'lista participantes 84', 9, '00:13:00', '00:55:00', '00:27:00');
INSERT INTO eventos VALUES ('espectaculo 84', 'deportivo', '2015-02-04', 'productora 84', '2022-09-01 18:00:00', 'Calle de las flores número 84 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 84', 'deportivo', '2015-02-04', 'productora 84', '2022-09-01 18:00:00', 'Calle de las flores número 84 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 84', 'deportivo', '2015-02-04', 'productora 84', '2022-09-01 18:00:00', 'Calle de las flores número 84 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 84', 'deportivo', '2015-02-04', 'productora 84', '2022-09-01 18:00:00', 'Calle de las flores número 84 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 85', 'pelicula', '2001-02-18', 'productora 85', 'lista participantes 85', 1, '00:14:00', '00:36:00', '00:26:00');
INSERT INTO eventos VALUES ('espectaculo 85', 'pelicula', '2001-02-18', 'productora 85', '2022-09-01 18:00:00', 'Calle de las flores número 85 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 85', 'pelicula', '2001-02-18', 'productora 85', '2022-09-01 18:00:00', 'Calle de las flores número 85 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 85', 'pelicula', '2001-02-18', 'productora 85', '2022-09-01 18:00:00', 'Calle de las flores número 85 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 85', 'pelicula', '2001-02-18', 'productora 85', '2022-09-01 18:00:00', 'Calle de las flores número 85 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 86', 'concierto', '2000-05-11', 'productora 86', 'lista participantes 86', 2, '00:11:00', '00:30:00', '00:23:00');
INSERT INTO eventos VALUES ('espectaculo 86', 'concierto', '2000-05-11', 'productora 86', '2022-09-01 18:00:00', 'Calle de las flores número 86 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 86', 'concierto', '2000-05-11', 'productora 86', '2022-09-01 18:00:00', 'Calle de las flores número 86 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 86', 'concierto', '2000-05-11', 'productora 86', '2022-09-01 18:00:00', 'Calle de las flores número 86 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 86', 'concierto', '2000-05-11', 'productora 86', '2022-09-01 18:00:00', 'Calle de las flores número 86 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 87', 'pelicula', '2014-05-12', 'productora 87', 'lista participantes 87', 7, '00:17:00', '00:17:00', '00:20:00');
INSERT INTO eventos VALUES ('espectaculo 87', 'pelicula', '2014-05-12', 'productora 87', '2022-09-01 18:00:00', 'Calle de las flores número 87 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 87', 'pelicula', '2014-05-12', 'productora 87', '2022-09-01 18:00:00', 'Calle de las flores número 87 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 87', 'pelicula', '2014-05-12', 'productora 87', '2022-09-01 18:00:00', 'Calle de las flores número 87 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 87', 'pelicula', '2014-05-12', 'productora 87', '2022-09-01 18:00:00', 'Calle de las flores número 87 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 88', 'entrevista', '1987-05-03', 'productora 88', 'lista participantes 88', 8, '00:19:00', '00:22:00', '00:16:00');
INSERT INTO eventos VALUES ('espectaculo 88', 'entrevista', '1987-05-03', 'productora 88', '2022-09-01 18:00:00', 'Calle de las flores número 88 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 88', 'entrevista', '1987-05-03', 'productora 88', '2022-09-01 18:00:00', 'Calle de las flores número 88 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 88', 'entrevista', '1987-05-03', 'productora 88', '2022-09-01 18:00:00', 'Calle de las flores número 88 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 88', 'entrevista', '1987-05-03', 'productora 88', '2022-09-01 18:00:00', 'Calle de las flores número 88 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 89', 'entrevista', '1997-07-09', 'productora 89', 'lista participantes 89', 4, '00:12:00', '00:35:00', '00:28:00');
INSERT INTO eventos VALUES ('espectaculo 89', 'entrevista', '1997-07-09', 'productora 89', '2022-09-01 18:00:00', 'Calle de las flores número 89 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 89', 'entrevista', '1997-07-09', 'productora 89', '2022-09-01 18:00:00', 'Calle de las flores número 89 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 89', 'entrevista', '1997-07-09', 'productora 89', '2022-09-01 18:00:00', 'Calle de las flores número 89 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 89', 'entrevista', '1997-07-09', 'productora 89', '2022-09-01 18:00:00', 'Calle de las flores número 89 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 90', 'concierto', '2016-11-23', 'productora 90', 'lista participantes 90', 7, '00:13:00', '00:25:00', '00:24:00');
INSERT INTO eventos VALUES ('espectaculo 90', 'concierto', '2016-11-23', 'productora 90', '2022-09-01 18:00:00', 'Calle de las flores número 90 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 90', 'concierto', '2016-11-23', 'productora 90', '2022-09-01 18:00:00', 'Calle de las flores número 90 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 90', 'concierto', '2016-11-23', 'productora 90', '2022-09-01 18:00:00', 'Calle de las flores número 90 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 90', 'concierto', '2016-11-23', 'productora 90', '2022-09-01 18:00:00', 'Calle de las flores número 90 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 91', 'deportivo', '2007-07-04', 'productora 91', 'lista participantes 91', 3, '00:12:00', '00:20:00', '00:18:00');
INSERT INTO eventos VALUES ('espectaculo 91', 'deportivo', '2007-07-04', 'productora 91', '2022-09-01 18:00:00', 'Calle de las flores número 91 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 91', 'deportivo', '2007-07-04', 'productora 91', '2022-09-01 18:00:00', 'Calle de las flores número 91 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 91', 'deportivo', '2007-07-04', 'productora 91', '2022-09-01 18:00:00', 'Calle de las flores número 91 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 91', 'deportivo', '2007-07-04', 'productora 91', '2022-09-01 18:00:00', 'Calle de las flores número 91 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 92', 'entrevista', '2018-11-08', 'productora 92', 'lista participantes 92', 9, '00:19:00', '00:43:00', '00:26:00');
INSERT INTO eventos VALUES ('espectaculo 92', 'entrevista', '2018-11-08', 'productora 92', '2022-09-01 18:00:00', 'Calle de las flores número 92 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 92', 'entrevista', '2018-11-08', 'productora 92', '2022-09-01 18:00:00', 'Calle de las flores número 92 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 92', 'entrevista', '2018-11-08', 'productora 92', '2022-09-01 18:00:00', 'Calle de las flores número 92 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 92', 'entrevista', '2018-11-08', 'productora 92', '2022-09-01 18:00:00', 'Calle de las flores número 92 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 93', 'entrevista', '2013-11-03', 'productora 93', 'lista participantes 93', 7, '00:11:00', '00:44:00', '00:22:00');
INSERT INTO eventos VALUES ('espectaculo 93', 'entrevista', '2013-11-03', 'productora 93', '2022-09-01 18:00:00', 'Calle de las flores número 93 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 93', 'entrevista', '2013-11-03', 'productora 93', '2022-09-01 18:00:00', 'Calle de las flores número 93 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 93', 'entrevista', '2013-11-03', 'productora 93', '2022-09-01 18:00:00', 'Calle de las flores número 93 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 93', 'entrevista', '2013-11-03', 'productora 93', '2022-09-01 18:00:00', 'Calle de las flores número 93 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 94', 'concierto', '1987-05-14', 'productora 94', 'lista participantes 94', 3, '00:14:00', '00:17:00', '00:17:00');
INSERT INTO eventos VALUES ('espectaculo 94', 'concierto', '1987-05-14', 'productora 94', '2022-09-01 18:00:00', 'Calle de las flores número 94 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 94', 'concierto', '1987-05-14', 'productora 94', '2022-09-01 18:00:00', 'Calle de las flores número 94 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 94', 'concierto', '1987-05-14', 'productora 94', '2022-09-01 18:00:00', 'Calle de las flores número 94 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 94', 'concierto', '1987-05-14', 'productora 94', '2022-09-01 18:00:00', 'Calle de las flores número 94 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 95', 'entrevista', '2010-07-07', 'productora 95', 'lista participantes 95', 9, '00:14:00', '00:30:00', '00:27:00');
INSERT INTO eventos VALUES ('espectaculo 95', 'entrevista', '2010-07-07', 'productora 95', '2022-09-01 18:00:00', 'Calle de las flores número 95 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 95', 'entrevista', '2010-07-07', 'productora 95', '2022-09-01 18:00:00', 'Calle de las flores número 95 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 95', 'entrevista', '2010-07-07', 'productora 95', '2022-09-01 18:00:00', 'Calle de las flores número 95 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 95', 'entrevista', '2010-07-07', 'productora 95', '2022-09-01 18:00:00', 'Calle de las flores número 95 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 96', 'deportivo', '2013-07-13', 'productora 96', 'lista participantes 96', 1, '00:13:00', '00:57:00', '00:29:00');
INSERT INTO eventos VALUES ('espectaculo 96', 'deportivo', '2013-07-13', 'productora 96', '2022-09-01 18:00:00', 'Calle de las flores número 96 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 96', 'deportivo', '2013-07-13', 'productora 96', '2022-09-01 18:00:00', 'Calle de las flores número 96 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 96', 'deportivo', '2013-07-13', 'productora 96', '2022-09-01 18:00:00', 'Calle de las flores número 96 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 96', 'deportivo', '2013-07-13', 'productora 96', '2022-09-01 18:00:00', 'Calle de las flores número 96 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 97', 'entrevista', '2005-03-22', 'productora 97', 'lista participantes 97', 4, '00:10:00', '00:58:00', '00:28:00');
INSERT INTO eventos VALUES ('espectaculo 97', 'entrevista', '2005-03-22', 'productora 97', '2022-09-01 18:00:00', 'Calle de las flores número 97 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 97', 'entrevista', '2005-03-22', 'productora 97', '2022-09-01 18:00:00', 'Calle de las flores número 97 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 97', 'entrevista', '2005-03-22', 'productora 97', '2022-09-01 18:00:00', 'Calle de las flores número 97 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 97', 'entrevista', '2005-03-22', 'productora 97', '2022-09-01 18:00:00', 'Calle de las flores número 97 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 98', 'teatro', '2007-04-23', 'productora 98', 'lista participantes 98', 3, '00:15:00', '00:56:00', '00:28:00');
INSERT INTO eventos VALUES ('espectaculo 98', 'teatro', '2007-04-23', 'productora 98', '2022-09-01 18:00:00', 'Calle de las flores número 98 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 98', 'teatro', '2007-04-23', 'productora 98', '2022-09-01 18:00:00', 'Calle de las flores número 98 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 98', 'teatro', '2007-04-23', 'productora 98', '2022-09-01 18:00:00', 'Calle de las flores número 98 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 98', 'teatro', '2007-04-23', 'productora 98', '2022-09-01 18:00:00', 'Calle de las flores número 98 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 99', 'deportivo', '1999-05-03', 'productora 99', 'lista participantes 99', 5, '00:18:00', '00:25:00', '00:29:00');
INSERT INTO eventos VALUES ('espectaculo 99', 'deportivo', '1999-05-03', 'productora 99', '2022-09-01 18:00:00', 'Calle de las flores número 99 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 99', 'deportivo', '1999-05-03', 'productora 99', '2022-09-01 18:00:00', 'Calle de las flores número 99 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 99', 'deportivo', '1999-05-03', 'productora 99', '2022-09-01 18:00:00', 'Calle de las flores número 99 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 99', 'deportivo', '1999-05-03', 'productora 99', '2022-09-01 18:00:00', 'Calle de las flores número 99 puerta C');
SELECT table_name, table_rows FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'proyecto';