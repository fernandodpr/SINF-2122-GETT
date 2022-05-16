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
    estado ENUM ('Abierto', 'Cerrado', 'Finalizado') NOT NULL DEFAULT 'Abierto',
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
INSERT INTO espectaculos VALUES ('Rey Leon', 'pelicula', '1994-01-01', 'Disney', 'dibujos animados', 3, '00:01:00', '00:02:00', '00:04:00');
INSERT INTO recintos VALUES ('Cines Gran Via Vigo sala 1', 'Cine Gran Via');
INSERT INTO recintos VALUES ('Cines Gran Via Vigo sala 2', 'Cine Gran Via');
INSERT INTO recintos VALUES ('Auditorio Mar de Vigo', 'Auditorio Mar de Vigo');
INSERT INTO horarios VALUES ('2022-07-01 19:00:00');
INSERT INTO horarios VALUES ('2022-07-10 20:30:00');
INSERT INTO horariosRecintos VALUES ('2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');
INSERT INTO horariosRecintos VALUES ('2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO horariosRecintos VALUES ('2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO eventos VALUES ('Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1','Abierto');
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
INSERT INTO eventos VALUES ('Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2','Abierto');
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
INSERT INTO eventos VALUES ('Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo','Abierto');
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
INSERT INTO espectaculos VALUES ('espectaculo 0', 'teatro', '2007-07-09', 'productora 0', 'lista participantes 0', 2, '00:13:00', '00:50:00', '00:23:00');
INSERT INTO eventos VALUES ('espectaculo 0', 'teatro', '2007-07-09', 'productora 0', '2022-09-01 18:00:00', 'Calle de las flores número 0 puerta C','Abierto');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 0', 'teatro', '2007-07-09', 'productora 0', '2022-09-01 18:00:00', 'Calle de las flores número 0 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 0', 'teatro', '2007-07-09', 'productora 0', '2022-09-01 18:00:00', 'Calle de las flores número 0 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 0', 'teatro', '2007-07-09', 'productora 0', '2022-09-01 18:00:00', 'Calle de las flores número 0 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 1', 'teatro', '1996-11-09', 'productora 1', 'lista participantes 1', 2, '00:12:00', '00:54:00', '00:18:00');
INSERT INTO eventos VALUES ('espectaculo 1', 'teatro', '1996-11-09', 'productora 1', '2022-09-01 18:00:00', 'Calle de las flores número 1 puerta C','Abierto');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 1', 'teatro', '1996-11-09', 'productora 1', '2022-09-01 18:00:00', 'Calle de las flores número 1 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 1', 'teatro', '1996-11-09', 'productora 1', '2022-09-01 18:00:00', 'Calle de las flores número 1 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 1', 'teatro', '1996-11-09', 'productora 1', '2022-09-01 18:00:00', 'Calle de las flores número 1 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 2', 'deportivo', '2019-05-01', 'productora 2', 'lista participantes 2', 2, '00:14:00', '00:47:00', '00:21:00');
INSERT INTO eventos VALUES ('espectaculo 2', 'deportivo', '2019-05-01', 'productora 2', '2022-09-01 18:00:00', 'Calle de las flores número 2 puerta C','Abierto');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 2', 'deportivo', '2019-05-01', 'productora 2', '2022-09-01 18:00:00', 'Calle de las flores número 2 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 2', 'deportivo', '2019-05-01', 'productora 2', '2022-09-01 18:00:00', 'Calle de las flores número 2 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 2', 'deportivo', '2019-05-01', 'productora 2', '2022-09-01 18:00:00', 'Calle de las flores número 2 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 3', 'entrevista', '1987-10-14', 'productora 3', 'lista participantes 3', 9, '00:10:00', '00:44:00', '00:19:00');
INSERT INTO eventos VALUES ('espectaculo 3', 'entrevista', '1987-10-14', 'productora 3', '2022-09-01 18:00:00', 'Calle de las flores número 3 puerta C','Abierto');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 3', 'entrevista', '1987-10-14', 'productora 3', '2022-09-01 18:00:00', 'Calle de las flores número 3 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 3', 'entrevista', '1987-10-14', 'productora 3', '2022-09-01 18:00:00', 'Calle de las flores número 3 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 3', 'entrevista', '1987-10-14', 'productora 3', '2022-09-01 18:00:00', 'Calle de las flores número 3 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 4', 'pelicula', '2000-07-14', 'productora 4', 'lista participantes 4', 2, '00:13:00', '00:35:00', '00:18:00');
INSERT INTO eventos VALUES ('espectaculo 4', 'pelicula', '2000-07-14', 'productora 4', '2022-09-01 18:00:00', 'Calle de las flores número 4 puerta C','Abierto');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 4', 'pelicula', '2000-07-14', 'productora 4', '2022-09-01 18:00:00', 'Calle de las flores número 4 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 4', 'pelicula', '2000-07-14', 'productora 4', '2022-09-01 18:00:00', 'Calle de las flores número 4 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 4', 'pelicula', '2000-07-14', 'productora 4', '2022-09-01 18:00:00', 'Calle de las flores número 4 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 5', 'teatro', '2010-04-07', 'productora 5', 'lista participantes 5', 4, '00:18:00', '00:56:00', '00:20:00');
INSERT INTO eventos VALUES ('espectaculo 5', 'teatro', '2010-04-07', 'productora 5', '2022-09-01 18:00:00', 'Calle de las flores número 5 puerta C','Abierto');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 5', 'teatro', '2010-04-07', 'productora 5', '2022-09-01 18:00:00', 'Calle de las flores número 5 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 5', 'teatro', '2010-04-07', 'productora 5', '2022-09-01 18:00:00', 'Calle de las flores número 5 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 5', 'teatro', '2010-04-07', 'productora 5', '2022-09-01 18:00:00', 'Calle de las flores número 5 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 6', 'entrevista', '2003-10-12', 'productora 6', 'lista participantes 6', 4, '00:11:00', '00:32:00', '00:29:00');
INSERT INTO eventos VALUES ('espectaculo 6', 'entrevista', '2003-10-12', 'productora 6', '2022-09-01 18:00:00', 'Calle de las flores número 6 puerta C','Abierto');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 6', 'entrevista', '2003-10-12', 'productora 6', '2022-09-01 18:00:00', 'Calle de las flores número 6 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 6', 'entrevista', '2003-10-12', 'productora 6', '2022-09-01 18:00:00', 'Calle de las flores número 6 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 6', 'entrevista', '2003-10-12', 'productora 6', '2022-09-01 18:00:00', 'Calle de las flores número 6 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 7', 'deportivo', '1989-09-16', 'productora 7', 'lista participantes 7', 8, '00:17:00', '00:40:00', '00:28:00');
INSERT INTO eventos VALUES ('espectaculo 7', 'deportivo', '1989-09-16', 'productora 7', '2022-09-01 18:00:00', 'Calle de las flores número 7 puerta C','Abierto');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 7', 'deportivo', '1989-09-16', 'productora 7', '2022-09-01 18:00:00', 'Calle de las flores número 7 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 7', 'deportivo', '1989-09-16', 'productora 7', '2022-09-01 18:00:00', 'Calle de las flores número 7 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 7', 'deportivo', '1989-09-16', 'productora 7', '2022-09-01 18:00:00', 'Calle de las flores número 7 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 8', 'deportivo', '1996-10-07', 'productora 8', 'lista participantes 8', 5, '00:15:00', '00:24:00', '00:25:00');
INSERT INTO eventos VALUES ('espectaculo 8', 'deportivo', '1996-10-07', 'productora 8', '2022-09-01 18:00:00', 'Calle de las flores número 8 puerta C','Abierto');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 8', 'deportivo', '1996-10-07', 'productora 8', '2022-09-01 18:00:00', 'Calle de las flores número 8 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 8', 'deportivo', '1996-10-07', 'productora 8', '2022-09-01 18:00:00', 'Calle de las flores número 8 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 8', 'deportivo', '1996-10-07', 'productora 8', '2022-09-01 18:00:00', 'Calle de las flores número 8 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 9', 'deportivo', '2001-04-03', 'productora 9', 'lista participantes 9', 8, '00:11:00', '00:34:00', '00:18:00');
INSERT INTO eventos VALUES ('espectaculo 9', 'deportivo', '2001-04-03', 'productora 9', '2022-09-01 18:00:00', 'Calle de las flores número 9 puerta C','Abierto');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 9', 'deportivo', '2001-04-03', 'productora 9', '2022-09-01 18:00:00', 'Calle de las flores número 9 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 9', 'deportivo', '2001-04-03', 'productora 9', '2022-09-01 18:00:00', 'Calle de las flores número 9 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 9', 'deportivo', '2001-04-03', 'productora 9', '2022-09-01 18:00:00', 'Calle de las flores número 9 puerta C');
SELECT table_name, table_rows FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'proyecto';