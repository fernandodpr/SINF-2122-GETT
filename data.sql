DROP DATABASE IF EXISTS proyecto;
CREATE DATABASE proyecto;
USE proyecto;
CREATE TABLE espectaculos (
    nombreEsp VARCHAR(20) NOT NULL,
    tipoEsp VARCHAR(20) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(20) NOT NULL,
    participantes VARCHAR(30),
    penalizacion INT NOT NULL,
    tValidezReserva INT NOT NULL,
    tAntelacionReserva INT NOT NULL,
    tCancelacion INT NOT NULL,
    PRIMARY KEY(nombreEsp, tipoEsp, fechaProduccion, productora)
    );
CREATE TABLE horarios (
    fechaYHora DATE NOT NULL,
    PRIMARY KEY(fechaYHora)
    );
CREATE TABLE recintos (
    direccion VARCHAR(50) NOT NULL,
    nombre VARCHAR(20),
    PRIMARY KEY(direccion)
    );
CREATE TABLE horariosRecintos (
    fechaYHora DATE NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    FOREIGN KEY(fechaYHora) references horarios(fechaYHora),
    FOREIGN KEY(direccion) references recintos(direccion),
    primary key(fechaYHora, direccion)
    );
CREATE TABLE eventos (
    nombreEsp VARCHAR(20) NOT NULL,
    tipoEsp VARCHAR(20) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(20) NOT NULL,
    fechaYHora DATE NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
    primary key (nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );
CREATE TABLE gradas (
    nombreGrada VARCHAR(20) NOT NULL,
    nombreEsp VARCHAR(20) NOT NULL,
    tipoEsp VARCHAR(20) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(20) NOT NULL,
    fechaYHora DATE NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
    PRIMARY KEY(nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );
CREATE TABLE localidades (
    asientoLocalidad INT NOT NULL,
    nombreGrada VARCHAR(20) NOT NULL,
    nombreEsp VARCHAR(20) NOT NULL,
    tipoEsp VARCHAR(20) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(20) NOT NULL,
    fechaYHora DATE NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    estado varchar(20) not null check (estado='Libre' or estado='Reservado' or estado='Deteriorado'),
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada),
    PRIMARY KEY(asientoLocalidad, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );
CREATE TABLE tarifas (
    tipoUsuario ENUM ('bebe', 'infantil', 'juvenil', 'adulto', 'jubilado') NOT NULL,
    precio INT NOT NULL,
    maxLocalidadesReserva INT NOT NULL,
    asientoLocalidad INT NOT NULL,
    nombreGrada VARCHAR(20) NOT NULL,
    nombreEsp VARCHAR(20) NOT NULL,
    tipoEsp VARCHAR(20) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(20) NOT NULL,
    fechaYHora DATE NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada),
    FOREIGN KEY(asientoLocalidad) references localidades(asientoLocalidad),
    PRIMARY KEY(tipoUsuario, asientoLocalidad, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );
CREATE TABLE clientes (
    correoCliente VARCHAR(30),
    nombreCliente VARCHAR(20),
    tlfCliente INT(9),
    datosBanco VARCHAR(20),
    PRIMARY KEY(correoCliente)
    );
CREATE TABLE entradas (
    estado ENUM ('pagada', 'prereservada') NOT NULL DEFAULT 'prereservada',
    formaPago VARCHAR(10) DEFAULT NULL,
    horaReserva DATE NOT NULL,
    correoCliente VARCHAR(20),
    tipoUsuario ENUM ('bebe', 'infantil', 'juvenil', 'adulto', 'jubilado') NOT NULL,
    asientoLocalidad INT NOT NULL,
    nombreGrada VARCHAR(20) NOT NULL,
    nombreEsp VARCHAR(20) NOT NULL,
    tipoEsp VARCHAR(20) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(20) NOT NULL,
    fechaYHora DATE NOT NULL,
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
    formaPago VARCHAR(10) NOT NULL,
    horaReserva DATE NOT NULL,
    correoCliente VARCHAR(20),
    tipoUsuario ENUM ('bebe', 'infantil', 'juvenil', 'adulto', 'jubilado') NOT NULL,
    asientoLocalidad INT NOT NULL,
    nombreGrada VARCHAR(20) NOT NULL,
    nombreEsp VARCHAR(20) NOT NULL,
    tipoEsp VARCHAR(20) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(20) NOT NULL,
    fechaYHora DATE NOT NULL,
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
INSERT INTO espectaculos VALUES ('espectaculo 0', 'entrevista', '2016-01-07', 'productora 0', 'lista participantes 0', 2, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 1', 'teatro', '2016-04-26', 'productora 1', 'lista participantes 1', 4, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 2', 'entrevista', '2003-01-02', 'productora 2', 'lista participantes 2', 4, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 3', 'teatro', '2018-11-24', 'productora 3', 'lista participantes 3', 3, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 4', 'concierto', '1985-02-04', 'productora 4', 'lista participantes 4', 6, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 5', 'teatro', '2008-04-03', 'productora 5', 'lista participantes 5', 3, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 6', 'teatro', '2008-07-26', 'productora 6', 'lista participantes 6', 4, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 7', 'deportivo', '2009-10-07', 'productora 7', 'lista participantes 7', 3, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 8', 'entrevista', '1995-01-26', 'productora 8', 'lista participantes 8', 8, 1, 2, 4);
INSERT INTO espectaculos VALUES ('espectaculo 9', 'entrevista', '2020-05-17', 'productora 9', 'lista participantes 9', 2, 1, 2, 4);
INSERT INTO horarios VALUES ('2022-07-01');
INSERT INTO horarios VALUES ('2021-07-01');
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
INSERT INTO horariosRecintos VALUES ('2022-07-01', 'Calle de las flores número 0 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-07-01', 'Calle de las flores número 0 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-07-01', 'Calle de las flores número 1 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-07-01', 'Calle de las flores número 1 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-07-01', 'Calle de las flores número 2 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-07-01', 'Calle de las flores número 2 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-07-01', 'Calle de las flores número 3 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-07-01', 'Calle de las flores número 3 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-07-01', 'Calle de las flores número 4 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-07-01', 'Calle de las flores número 4 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-07-01', 'Calle de las flores número 5 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-07-01', 'Calle de las flores número 5 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-07-01', 'Calle de las flores número 6 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-07-01', 'Calle de las flores número 6 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-07-01', 'Calle de las flores número 7 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-07-01', 'Calle de las flores número 7 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-07-01', 'Calle de las flores número 8 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-07-01', 'Calle de las flores número 8 puerta C');
INSERT INTO horariosRecintos VALUES ('2022-07-01', 'Calle de las flores número 9 puerta C');
INSERT INTO horariosRecintos VALUES ('2021-07-01', 'Calle de las flores número 9 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 0', 'entrevista', '1985-06-24', 'productora 0', 'lista participantes 0', 4, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 0', 'entrevista', '1985-06-24', 'productora 0', '2021-07-01', 'Calle de las flores número 0 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 0', 'entrevista', '1985-06-24', 'productora 0', '2021-07-01', 'Calle de las flores número 0 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 0', 'entrevista', '1985-06-24', 'productora 0', '2021-07-01', 'Calle de las flores número 0 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 0', 'entrevista', '1985-06-24', 'productora 0', '2021-07-01', 'Calle de las flores número 0 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 1', 'pelicula', '1991-07-07', 'productora 1', 'lista participantes 1', 3, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 1', 'pelicula', '1991-07-07', 'productora 1', '2021-07-01', 'Calle de las flores número 1 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 1', 'pelicula', '1991-07-07', 'productora 1', '2021-07-01', 'Calle de las flores número 1 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 1', 'pelicula', '1991-07-07', 'productora 1', '2021-07-01', 'Calle de las flores número 1 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 1', 'pelicula', '1991-07-07', 'productora 1', '2021-07-01', 'Calle de las flores número 1 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 2', 'pelicula', '2015-07-19', 'productora 2', 'lista participantes 2', 7, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 2', 'pelicula', '2015-07-19', 'productora 2', '2021-07-01', 'Calle de las flores número 2 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 2', 'pelicula', '2015-07-19', 'productora 2', '2021-07-01', 'Calle de las flores número 2 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 2', 'pelicula', '2015-07-19', 'productora 2', '2021-07-01', 'Calle de las flores número 2 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 2', 'pelicula', '2015-07-19', 'productora 2', '2021-07-01', 'Calle de las flores número 2 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 3', 'pelicula', '2018-05-27', 'productora 3', 'lista participantes 3', 8, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 3', 'pelicula', '2018-05-27', 'productora 3', '2021-07-01', 'Calle de las flores número 3 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 3', 'pelicula', '2018-05-27', 'productora 3', '2021-07-01', 'Calle de las flores número 3 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 3', 'pelicula', '2018-05-27', 'productora 3', '2021-07-01', 'Calle de las flores número 3 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 3', 'pelicula', '2018-05-27', 'productora 3', '2021-07-01', 'Calle de las flores número 3 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 4', 'teatro', '2012-04-11', 'productora 4', 'lista participantes 4', 3, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 4', 'teatro', '2012-04-11', 'productora 4', '2021-07-01', 'Calle de las flores número 4 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 4', 'teatro', '2012-04-11', 'productora 4', '2021-07-01', 'Calle de las flores número 4 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 4', 'teatro', '2012-04-11', 'productora 4', '2021-07-01', 'Calle de las flores número 4 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 4', 'teatro', '2012-04-11', 'productora 4', '2021-07-01', 'Calle de las flores número 4 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 5', 'entrevista', '2010-02-13', 'productora 5', 'lista participantes 5', 5, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 5', 'entrevista', '2010-02-13', 'productora 5', '2021-07-01', 'Calle de las flores número 5 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 5', 'entrevista', '2010-02-13', 'productora 5', '2021-07-01', 'Calle de las flores número 5 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 5', 'entrevista', '2010-02-13', 'productora 5', '2021-07-01', 'Calle de las flores número 5 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 5', 'entrevista', '2010-02-13', 'productora 5', '2021-07-01', 'Calle de las flores número 5 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 6', 'deportivo', '1992-05-03', 'productora 6', 'lista participantes 6', 6, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 6', 'deportivo', '1992-05-03', 'productora 6', '2021-07-01', 'Calle de las flores número 6 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 6', 'deportivo', '1992-05-03', 'productora 6', '2021-07-01', 'Calle de las flores número 6 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 6', 'deportivo', '1992-05-03', 'productora 6', '2021-07-01', 'Calle de las flores número 6 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 6', 'deportivo', '1992-05-03', 'productora 6', '2021-07-01', 'Calle de las flores número 6 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 7', 'concierto', '1989-10-09', 'productora 7', 'lista participantes 7', 6, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 7', 'concierto', '1989-10-09', 'productora 7', '2021-07-01', 'Calle de las flores número 7 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 7', 'concierto', '1989-10-09', 'productora 7', '2021-07-01', 'Calle de las flores número 7 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 7', 'concierto', '1989-10-09', 'productora 7', '2021-07-01', 'Calle de las flores número 7 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 7', 'concierto', '1989-10-09', 'productora 7', '2021-07-01', 'Calle de las flores número 7 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 8', 'teatro', '2012-09-18', 'productora 8', 'lista participantes 8', 4, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 8', 'teatro', '2012-09-18', 'productora 8', '2021-07-01', 'Calle de las flores número 8 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 8', 'teatro', '2012-09-18', 'productora 8', '2021-07-01', 'Calle de las flores número 8 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 8', 'teatro', '2012-09-18', 'productora 8', '2021-07-01', 'Calle de las flores número 8 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 8', 'teatro', '2012-09-18', 'productora 8', '2021-07-01', 'Calle de las flores número 8 puerta C');
INSERT INTO espectaculos VALUES ('espectaculo 9', 'entrevista', '1992-09-15', 'productora 9', 'lista participantes 9', 9, 1, 2, 4);
INSERT INTO eventos VALUES ('espectaculo 9', 'entrevista', '1992-09-15', 'productora 9', '2021-07-01', 'Calle de las flores número 9 puerta C');
INSERT INTO gradas VALUES ('grada 1', 'espectaculo 9', 'entrevista', '1992-09-15', 'productora 9', '2021-07-01', 'Calle de las flores número 9 puerta C');
INSERT INTO gradas VALUES ('grada 2', 'espectaculo 9', 'entrevista', '1992-09-15', 'productora 9', '2021-07-01', 'Calle de las flores número 9 puerta C');
INSERT INTO gradas VALUES ('grada 3', 'espectaculo 9', 'entrevista', '1992-09-15', 'productora 9', '2021-07-01', 'Calle de las flores número 9 puerta C');