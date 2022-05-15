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
    tValidezReserva INT NOT NULL,
    tAntelacionReserva INT NOT NULL,
    tCancelacion INT NOT NULL,
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
    FOREIGN KEY(fechaYHora) references horarios(fechaYHora),
    FOREIGN KEY(direccion) references recintos(direccion),
    primary key(fechaYHora, direccion)
    );
CREATE TABLE eventos (
    nombreEsp VARCHAR(30) NOT NULL,
    tipoEsp VARCHAR(30) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(30) NOT NULL,
    fechaYHora DATETIME NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
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
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
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
    estado ENUM ('Libre', 'Reservado', 'Prereservado', 'Deteriodado') NOT NULL DEFAULT 'Libre',
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada),
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
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada),
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
    horaReserva DATE NOT NULL,
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
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada),
    FOREIGN KEY(asientoLocalidad) references localidades(asientoLocalidad),
    FOREIGN KEY(tipoUsuario) references tarifas(tipoUsuario),
    FOREIGN KEY(correoCliente) references clientes(correoCliente),
    PRIMARY KEY(horaReserva, tipoUsuario, asientoLocalidad, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );
CREATE TABLE cancelaciones (
    formaPago VARCHAR(20) NOT NULL,
    horaReserva DATE NOT NULL,
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
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada),
    FOREIGN KEY(asientoLocalidad) references localidades(asientoLocalidad),
    FOREIGN KEY(tipoUsuario) references tarifas(tipoUsuario),
    FOREIGN KEY(correoCliente) references clientes(correoCliente),
    PRIMARY KEY(horaReserva, tipoUsuario, asientoLocalidad, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );

INSERT INTO clientes VALUES ('alba@gmail.com', 'Alba', '123456789', 'ES15753123');
INSERT INTO clientes VALUES ('omar@gmail.com', 'Omar', '147258369', 'ES15753123');
INSERT INTO clientes VALUES ('dario@gmail.com', 'Dario', '987654321', 'ES15753123');
INSERT INTO clientes VALUES ('martina@gmail.com', 'Martina', '258369147', 'ES15753123');
INSERT INTO clientes VALUES ('fernando@gmail.com', 'Fernando', '369147258', 'ES15753123');
INSERT INTO espectaculos VALUES ('espectaculo 0', 'entrevista', '2017-01-11', 'productora 0', 'lista participantes 0', 5, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 1', 'pelicula', '2000-09-23', 'productora 1', 'lista participantes 1', 8, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 2', 'deportivo', '2011-10-27', 'productora 2', 'lista participantes 2', 2, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 3', 'entrevista', '1996-05-11', 'productora 3', 'lista participantes 3', 8, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 4', 'teatro', '2003-01-09', 'productora 4', 'lista participantes 4', 2, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 5', 'concierto', '1989-08-06', 'productora 5', 'lista participantes 5', 3, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 6', 'entrevista', '2007-01-16', 'productora 6', 'lista participantes 6', 9, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 7', 'pelicula', '1987-01-17', 'productora 7', 'lista participantes 7', 9, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 8', 'teatro', '1990-07-13', 'productora 8', 'lista participantes 8', 7, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 9', 'deportivo', '1987-02-10', 'productora 9', 'lista participantes 9', 1, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 10', 'concierto', '2009-11-07', 'productora 10', 'lista participantes 10', 8, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 11', 'teatro', '1999-01-27', 'productora 11', 'lista participantes 11', 6, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 12', 'entrevista', '1991-03-03', 'productora 12', 'lista participantes 12', 8, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 13', 'pelicula', '1986-01-26', 'productora 13', 'lista participantes 13', 4, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 14', 'pelicula', '2016-06-14', 'productora 14', 'lista participantes 14', 7, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 15', 'concierto', '1988-05-12', 'productora 15', 'lista participantes 15', 8, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 16', 'pelicula', '1994-04-10', 'productora 16', 'lista participantes 16', 7, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 17', 'deportivo', '1995-08-23', 'productora 17', 'lista participantes 17', 9, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 18', 'deportivo', '1987-08-04', 'productora 18', 'lista participantes 18', 2, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 19', 'teatro', '2015-02-19', 'productora 19', 'lista participantes 19', 9, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 20', 'entrevista', '1999-08-24', 'productora 20', 'lista participantes 20', 1, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 21', 'deportivo', '2002-02-09', 'productora 21', 'lista participantes 21', 8, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 22', 'entrevista', '2016-06-12', 'productora 22', 'lista participantes 22', 4, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 23', 'deportivo', '1999-02-04', 'productora 23', 'lista participantes 23', 9, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 24', 'concierto', '2009-08-16', 'productora 24', 'lista participantes 24', 6, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 25', 'teatro', '1997-08-19', 'productora 25', 'lista participantes 25', 2, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 26', 'teatro', '1998-10-05', 'productora 26', 'lista participantes 26', 2, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 27', 'concierto', '2017-05-16', 'productora 27', 'lista participantes 27', 7, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 28', 'deportivo', '2012-07-10', 'productora 28', 'lista participantes 28', 1, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 29', 'concierto', '1996-01-13', 'productora 29', 'lista participantes 29', 2, 1, 2, 4);
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
INSERT INTO espectaculos VALUES ('Rey Leon', 'pelicula', '1994-01-01', 'Disney', 'dibujos animados', 3, 1, 2, 4);
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
INSERT INTO tarifas VALUES ('bebe', 0, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');
INSERT INTO tarifas VALUES ('infantil', 5, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');
INSERT INTO tarifas VALUES ('juvenil', 8, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');
INSERT INTO tarifas VALUES ('adulto', 10, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');
INSERT INTO tarifas VALUES ('jubilado', 5, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');
INSERT INTO eventos VALUES ('Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO gradas VALUES ('grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO tarifas VALUES ('bebe', 0, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO tarifas VALUES ('infantil', 5, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO tarifas VALUES ('juvenil', 8, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO tarifas VALUES ('adulto', 10, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO tarifas VALUES ('jubilado', 5, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');
INSERT INTO espectaculos VALUES ('Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', 'Pedro Gomez - Laura Perez', 5, 1, 2, 4);
INSERT INTO eventos VALUES ('Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO gradas VALUES ('grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO tarifas VALUES ('adulto', 20, 5, 'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO tarifas VALUES ('jubilado', 12, 5, 'grada centro', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO gradas VALUES ('grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO tarifas VALUES ('adulto', 18, 5, 'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO tarifas VALUES ('jubilado', 10, 5, 'grada superior', 'Romeo y Julieta', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');
INSERT INTO espectaculos VALUES ('espectaculo 0', 'entrevista', '2019-10-09', 'productora 0', 'lista participantes 0', 4, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 0', 'entrevista', '2019-10-09', 'productora 0', '2022-09-01 18:00:00', 'Calle de las flores número 0 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 0', 'entrevista', '2019-10-09', 'productora 0', '2022-09-01 18:00:00', 'Calle de las flores número 0 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 0', 'entrevista', '2019-10-09', 'productora 0', '2022-09-01 18:00:00', 'Calle de las flores número 0 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 0', 'entrevista', '2019-10-09', 'productora 0', '2022-09-01 18:00:00', 'Calle de las flores número 0 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 1', 'concierto', '2005-07-09', 'productora 1', 'lista participantes 1', 1, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 1', 'concierto', '2005-07-09', 'productora 1', '2022-09-01 18:00:00', 'Calle de las flores número 1 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 1', 'concierto', '2005-07-09', 'productora 1', '2022-09-01 18:00:00', 'Calle de las flores número 1 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 1', 'concierto', '2005-07-09', 'productora 1', '2022-09-01 18:00:00', 'Calle de las flores número 1 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 1', 'concierto', '2005-07-09', 'productora 1', '2022-09-01 18:00:00', 'Calle de las flores número 1 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 2', 'pelicula', '1997-06-06', 'productora 2', 'lista participantes 2', 2, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 2', 'pelicula', '1997-06-06', 'productora 2', '2022-09-01 18:00:00', 'Calle de las flores número 2 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 2', 'pelicula', '1997-06-06', 'productora 2', '2022-09-01 18:00:00', 'Calle de las flores número 2 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 2', 'pelicula', '1997-06-06', 'productora 2', '2022-09-01 18:00:00', 'Calle de las flores número 2 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 2', 'pelicula', '1997-06-06', 'productora 2', '2022-09-01 18:00:00', 'Calle de las flores número 2 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 3', 'concierto', '1993-05-17', 'productora 3', 'lista participantes 3', 4, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 3', 'concierto', '1993-05-17', 'productora 3', '2022-09-01 18:00:00', 'Calle de las flores número 3 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 3', 'concierto', '1993-05-17', 'productora 3', '2022-09-01 18:00:00', 'Calle de las flores número 3 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 3', 'concierto', '1993-05-17', 'productora 3', '2022-09-01 18:00:00', 'Calle de las flores número 3 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 3', 'concierto', '1993-05-17', 'productora 3', '2022-09-01 18:00:00', 'Calle de las flores número 3 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 4', 'entrevista', '2005-04-11', 'productora 4', 'lista participantes 4', 3, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 4', 'entrevista', '2005-04-11', 'productora 4', '2022-09-01 18:00:00', 'Calle de las flores número 4 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 4', 'entrevista', '2005-04-11', 'productora 4', '2022-09-01 18:00:00', 'Calle de las flores número 4 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 4', 'entrevista', '2005-04-11', 'productora 4', '2022-09-01 18:00:00', 'Calle de las flores número 4 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 4', 'entrevista', '2005-04-11', 'productora 4', '2022-09-01 18:00:00', 'Calle de las flores número 4 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 5', 'entrevista', '1986-08-05', 'productora 5', 'lista participantes 5', 6, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 5', 'entrevista', '1986-08-05', 'productora 5', '2022-09-01 18:00:00', 'Calle de las flores número 5 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 5', 'entrevista', '1986-08-05', 'productora 5', '2022-09-01 18:00:00', 'Calle de las flores número 5 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 5', 'entrevista', '1986-08-05', 'productora 5', '2022-09-01 18:00:00', 'Calle de las flores número 5 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 5', 'entrevista', '1986-08-05', 'productora 5', '2022-09-01 18:00:00', 'Calle de las flores número 5 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 6', 'teatro', '2003-07-05', 'productora 6', 'lista participantes 6', 3, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 6', 'teatro', '2003-07-05', 'productora 6', '2022-09-01 18:00:00', 'Calle de las flores número 6 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 6', 'teatro', '2003-07-05', 'productora 6', '2022-09-01 18:00:00', 'Calle de las flores número 6 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 6', 'teatro', '2003-07-05', 'productora 6', '2022-09-01 18:00:00', 'Calle de las flores número 6 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 6', 'teatro', '2003-07-05', 'productora 6', '2022-09-01 18:00:00', 'Calle de las flores número 6 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 7', 'concierto', '1991-02-23', 'productora 7', 'lista participantes 7', 1, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 7', 'concierto', '1991-02-23', 'productora 7', '2022-09-01 18:00:00', 'Calle de las flores número 7 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 7', 'concierto', '1991-02-23', 'productora 7', '2022-09-01 18:00:00', 'Calle de las flores número 7 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 7', 'concierto', '1991-02-23', 'productora 7', '2022-09-01 18:00:00', 'Calle de las flores número 7 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 7', 'concierto', '1991-02-23', 'productora 7', '2022-09-01 18:00:00', 'Calle de las flores número 7 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 8', 'concierto', '2010-01-27', 'productora 8', 'lista participantes 8', 3, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 8', 'concierto', '2010-01-27', 'productora 8', '2022-09-01 18:00:00', 'Calle de las flores número 8 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 8', 'concierto', '2010-01-27', 'productora 8', '2022-09-01 18:00:00', 'Calle de las flores número 8 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 8', 'concierto', '2010-01-27', 'productora 8', '2022-09-01 18:00:00', 'Calle de las flores número 8 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 8', 'concierto', '2010-01-27', 'productora 8', '2022-09-01 18:00:00', 'Calle de las flores número 8 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 9', 'teatro', '2003-06-05', 'productora 9', 'lista participantes 9', 2, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 9', 'teatro', '2003-06-05', 'productora 9', '2022-09-01 18:00:00', 'Calle de las flores número 9 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 9', 'teatro', '2003-06-05', 'productora 9', '2022-09-01 18:00:00', 'Calle de las flores número 9 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 9', 'teatro', '2003-06-05', 'productora 9', '2022-09-01 18:00:00', 'Calle de las flores número 9 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 9', 'teatro', '2003-06-05', 'productora 9', '2022-09-01 18:00:00', 'Calle de las flores número 9 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 10', 'concierto', '1991-10-19', 'productora 10', 'lista participantes 10', 6, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 10', 'concierto', '1991-10-19', 'productora 10', '2022-09-01 18:00:00', 'Calle de las flores número 10 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 10', 'concierto', '1991-10-19', 'productora 10', '2022-09-01 18:00:00', 'Calle de las flores número 10 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 10', 'concierto', '1991-10-19', 'productora 10', '2022-09-01 18:00:00', 'Calle de las flores número 10 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 10', 'concierto', '1991-10-19', 'productora 10', '2022-09-01 18:00:00', 'Calle de las flores número 10 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 11', 'entrevista', '2016-03-14', 'productora 11', 'lista participantes 11', 9, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 11', 'entrevista', '2016-03-14', 'productora 11', '2022-09-01 18:00:00', 'Calle de las flores número 11 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 11', 'entrevista', '2016-03-14', 'productora 11', '2022-09-01 18:00:00', 'Calle de las flores número 11 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 11', 'entrevista', '2016-03-14', 'productora 11', '2022-09-01 18:00:00', 'Calle de las flores número 11 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 11', 'entrevista', '2016-03-14', 'productora 11', '2022-09-01 18:00:00', 'Calle de las flores número 11 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 12', 'teatro', '1990-10-26', 'productora 12', 'lista participantes 12', 2, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 12', 'teatro', '1990-10-26', 'productora 12', '2022-09-01 18:00:00', 'Calle de las flores número 12 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 12', 'teatro', '1990-10-26', 'productora 12', '2022-09-01 18:00:00', 'Calle de las flores número 12 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 12', 'teatro', '1990-10-26', 'productora 12', '2022-09-01 18:00:00', 'Calle de las flores número 12 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 12', 'teatro', '1990-10-26', 'productora 12', '2022-09-01 18:00:00', 'Calle de las flores número 12 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 13', 'concierto', '1989-06-05', 'productora 13', 'lista participantes 13', 3, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 13', 'concierto', '1989-06-05', 'productora 13', '2022-09-01 18:00:00', 'Calle de las flores número 13 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 13', 'concierto', '1989-06-05', 'productora 13', '2022-09-01 18:00:00', 'Calle de las flores número 13 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 13', 'concierto', '1989-06-05', 'productora 13', '2022-09-01 18:00:00', 'Calle de las flores número 13 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 13', 'concierto', '1989-06-05', 'productora 13', '2022-09-01 18:00:00', 'Calle de las flores número 13 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 14', 'teatro', '2015-05-06', 'productora 14', 'lista participantes 14', 4, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 14', 'teatro', '2015-05-06', 'productora 14', '2022-09-01 18:00:00', 'Calle de las flores número 14 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 14', 'teatro', '2015-05-06', 'productora 14', '2022-09-01 18:00:00', 'Calle de las flores número 14 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 14', 'teatro', '2015-05-06', 'productora 14', '2022-09-01 18:00:00', 'Calle de las flores número 14 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 14', 'teatro', '2015-05-06', 'productora 14', '2022-09-01 18:00:00', 'Calle de las flores número 14 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 15', 'teatro', '1986-08-16', 'productora 15', 'lista participantes 15', 9, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 15', 'teatro', '1986-08-16', 'productora 15', '2022-09-01 18:00:00', 'Calle de las flores número 15 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 15', 'teatro', '1986-08-16', 'productora 15', '2022-09-01 18:00:00', 'Calle de las flores número 15 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 15', 'teatro', '1986-08-16', 'productora 15', '2022-09-01 18:00:00', 'Calle de las flores número 15 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 15', 'teatro', '1986-08-16', 'productora 15', '2022-09-01 18:00:00', 'Calle de las flores número 15 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 16', 'teatro', '1997-02-18', 'productora 16', 'lista participantes 16', 5, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 16', 'teatro', '1997-02-18', 'productora 16', '2022-09-01 18:00:00', 'Calle de las flores número 16 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 16', 'teatro', '1997-02-18', 'productora 16', '2022-09-01 18:00:00', 'Calle de las flores número 16 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 16', 'teatro', '1997-02-18', 'productora 16', '2022-09-01 18:00:00', 'Calle de las flores número 16 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 16', 'teatro', '1997-02-18', 'productora 16', '2022-09-01 18:00:00', 'Calle de las flores número 16 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 17', 'deportivo', '1999-09-23', 'productora 17', 'lista participantes 17', 9, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 17', 'deportivo', '1999-09-23', 'productora 17', '2022-09-01 18:00:00', 'Calle de las flores número 17 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 17', 'deportivo', '1999-09-23', 'productora 17', '2022-09-01 18:00:00', 'Calle de las flores número 17 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 17', 'deportivo', '1999-09-23', 'productora 17', '2022-09-01 18:00:00', 'Calle de las flores número 17 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 17', 'deportivo', '1999-09-23', 'productora 17', '2022-09-01 18:00:00', 'Calle de las flores número 17 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 18', 'pelicula', '1996-06-27', 'productora 18', 'lista participantes 18', 3, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 18', 'pelicula', '1996-06-27', 'productora 18', '2022-09-01 18:00:00', 'Calle de las flores número 18 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 18', 'pelicula', '1996-06-27', 'productora 18', '2022-09-01 18:00:00', 'Calle de las flores número 18 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 18', 'pelicula', '1996-06-27', 'productora 18', '2022-09-01 18:00:00', 'Calle de las flores número 18 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 18', 'pelicula', '1996-06-27', 'productora 18', '2022-09-01 18:00:00', 'Calle de las flores número 18 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 19', 'entrevista', '2013-07-03', 'productora 19', 'lista participantes 19', 1, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 19', 'entrevista', '2013-07-03', 'productora 19', '2022-09-01 18:00:00', 'Calle de las flores número 19 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 19', 'entrevista', '2013-07-03', 'productora 19', '2022-09-01 18:00:00', 'Calle de las flores número 19 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 19', 'entrevista', '2013-07-03', 'productora 19', '2022-09-01 18:00:00', 'Calle de las flores número 19 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 19', 'entrevista', '2013-07-03', 'productora 19', '2022-09-01 18:00:00', 'Calle de las flores número 19 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 20', 'teatro', '2001-01-03', 'productora 20', 'lista participantes 20', 1, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 20', 'teatro', '2001-01-03', 'productora 20', '2022-09-01 18:00:00', 'Calle de las flores número 20 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 20', 'teatro', '2001-01-03', 'productora 20', '2022-09-01 18:00:00', 'Calle de las flores número 20 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 20', 'teatro', '2001-01-03', 'productora 20', '2022-09-01 18:00:00', 'Calle de las flores número 20 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 20', 'teatro', '2001-01-03', 'productora 20', '2022-09-01 18:00:00', 'Calle de las flores número 20 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 21', 'pelicula', '2012-01-09', 'productora 21', 'lista participantes 21', 4, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 21', 'pelicula', '2012-01-09', 'productora 21', '2022-09-01 18:00:00', 'Calle de las flores número 21 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 21', 'pelicula', '2012-01-09', 'productora 21', '2022-09-01 18:00:00', 'Calle de las flores número 21 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 21', 'pelicula', '2012-01-09', 'productora 21', '2022-09-01 18:00:00', 'Calle de las flores número 21 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 21', 'pelicula', '2012-01-09', 'productora 21', '2022-09-01 18:00:00', 'Calle de las flores número 21 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 22', 'deportivo', '2004-04-05', 'productora 22', 'lista participantes 22', 5, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 22', 'deportivo', '2004-04-05', 'productora 22', '2022-09-01 18:00:00', 'Calle de las flores número 22 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 22', 'deportivo', '2004-04-05', 'productora 22', '2022-09-01 18:00:00', 'Calle de las flores número 22 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 22', 'deportivo', '2004-04-05', 'productora 22', '2022-09-01 18:00:00', 'Calle de las flores número 22 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 22', 'deportivo', '2004-04-05', 'productora 22', '2022-09-01 18:00:00', 'Calle de las flores número 22 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 23', 'teatro', '1988-01-10', 'productora 23', 'lista participantes 23', 2, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 23', 'teatro', '1988-01-10', 'productora 23', '2022-09-01 18:00:00', 'Calle de las flores número 23 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 23', 'teatro', '1988-01-10', 'productora 23', '2022-09-01 18:00:00', 'Calle de las flores número 23 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 23', 'teatro', '1988-01-10', 'productora 23', '2022-09-01 18:00:00', 'Calle de las flores número 23 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 23', 'teatro', '1988-01-10', 'productora 23', '2022-09-01 18:00:00', 'Calle de las flores número 23 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 24', 'concierto', '2014-11-20', 'productora 24', 'lista participantes 24', 6, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 24', 'concierto', '2014-11-20', 'productora 24', '2022-09-01 18:00:00', 'Calle de las flores número 24 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 24', 'concierto', '2014-11-20', 'productora 24', '2022-09-01 18:00:00', 'Calle de las flores número 24 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 24', 'concierto', '2014-11-20', 'productora 24', '2022-09-01 18:00:00', 'Calle de las flores número 24 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 24', 'concierto', '2014-11-20', 'productora 24', '2022-09-01 18:00:00', 'Calle de las flores número 24 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 25', 'teatro', '1998-10-11', 'productora 25', 'lista participantes 25', 9, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 25', 'teatro', '1998-10-11', 'productora 25', '2022-09-01 18:00:00', 'Calle de las flores número 25 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 25', 'teatro', '1998-10-11', 'productora 25', '2022-09-01 18:00:00', 'Calle de las flores número 25 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 25', 'teatro', '1998-10-11', 'productora 25', '2022-09-01 18:00:00', 'Calle de las flores número 25 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 25', 'teatro', '1998-10-11', 'productora 25', '2022-09-01 18:00:00', 'Calle de las flores número 25 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 26', 'concierto', '1989-01-25', 'productora 26', 'lista participantes 26', 6, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 26', 'concierto', '1989-01-25', 'productora 26', '2022-09-01 18:00:00', 'Calle de las flores número 26 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 26', 'concierto', '1989-01-25', 'productora 26', '2022-09-01 18:00:00', 'Calle de las flores número 26 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 26', 'concierto', '1989-01-25', 'productora 26', '2022-09-01 18:00:00', 'Calle de las flores número 26 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 26', 'concierto', '1989-01-25', 'productora 26', '2022-09-01 18:00:00', 'Calle de las flores número 26 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 27', 'entrevista', '2017-02-27', 'productora 27', 'lista participantes 27', 4, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 27', 'entrevista', '2017-02-27', 'productora 27', '2022-09-01 18:00:00', 'Calle de las flores número 27 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 27', 'entrevista', '2017-02-27', 'productora 27', '2022-09-01 18:00:00', 'Calle de las flores número 27 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 27', 'entrevista', '2017-02-27', 'productora 27', '2022-09-01 18:00:00', 'Calle de las flores número 27 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 27', 'entrevista', '2017-02-27', 'productora 27', '2022-09-01 18:00:00', 'Calle de las flores número 27 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 28', 'concierto', '1992-02-01', 'productora 28', 'lista participantes 28', 4, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 28', 'concierto', '1992-02-01', 'productora 28', '2022-09-01 18:00:00', 'Calle de las flores número 28 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 28', 'concierto', '1992-02-01', 'productora 28', '2022-09-01 18:00:00', 'Calle de las flores número 28 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 28', 'concierto', '1992-02-01', 'productora 28', '2022-09-01 18:00:00', 'Calle de las flores número 28 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 28', 'concierto', '1992-02-01', 'productora 28', '2022-09-01 18:00:00', 'Calle de las flores número 28 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 29', 'teatro', '2005-07-06', 'productora 29', 'lista participantes 29', 2, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 29', 'teatro', '2005-07-06', 'productora 29', '2022-09-01 18:00:00', 'Calle de las flores número 29 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 29', 'teatro', '2005-07-06', 'productora 29', '2022-09-01 18:00:00', 'Calle de las flores número 29 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 29', 'teatro', '2005-07-06', 'productora 29', '2022-09-01 18:00:00', 'Calle de las flores número 29 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 29', 'teatro', '2005-07-06', 'productora 29', '2022-09-01 18:00:00', 'Calle de las flores número 29 puerta C');