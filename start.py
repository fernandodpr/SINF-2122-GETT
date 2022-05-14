'''
INSTRUCCIÓNS:
1) executar este script co comando "python3 start.py <num tuplas>"
    num tuplas é o número de instancias que queremos crear na táboa espectáculo
2) crease o fichero data.sql no directorio onde executas o script
3) executas data.sql co comando "mysql -u root -p < data.sql"
4) abres mysql e xa tes na base de datos "proyecto" as taboas e datos
'''

import random
import sys


def random_tipo_espectaculo():
    tipos = ["concierto", "entrevista", "teatro", "pelicula", "deportivo"]
    i = random.randrange(0, len(tipos))
    return tipos[i]


def random_fecha_produccion():
    anho = str(random.randrange(1985, 2021))
    mes = str(random.randrange(1, 12))
    dia = str(random.randrange(1, 28))

    if len(mes) == 1: 
        mes = '0' + mes
    if len(dia) == 1: 
        dia = '0' + dia
    return "{}-{}-{}".format(anho, mes, dia)


def random_penalizacion():
    return str(random.randrange(1,10))


def insert_espectaculos(f, n):
    for i in range(n):
        nombre = f"espectaculo {i}"
        productora = f"productora {i}"
        participantes = f"lista participantes {i}"
        
        query = f"\nINSERT INTO espectaculos VALUES ('{nombre}', '{random_tipo_espectaculo()}', '{str(random_fecha_produccion())}', '{productora}', '{participantes}', {random_penalizacion()}, 1, 2, 4);"
        f.write(query)


def insert_recintos(f, n):
    for i in range(n):
        dir = f"Calle de las flores número {i} puerta C"
        nombre = f"Recinto {i}"
        
        query = f"\nINSERT INTO recintos VALUES ('{dir}', '{nombre}');"
        f.write(query)


def insert_eventos(f, n):
    for i in range(n):
        nombreEsp = f"evento {i}"
        nombre = f"Recinto {i}"
        
        query = f"\nINSERT INTO recintos VALUES ('{dir}', '{nombre}');"
        f.write(query)



### MAIN FUNCTION ###
def main():

    create_espectaculos_table = """CREATE TABLE espectaculos (
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
    );"""

    create_recintos_table = """CREATE TABLE recintos (
    direccion VARCHAR(50) NOT NULL,
    nombre VARCHAR(20),
    PRIMARY KEY(direccion)
    );"""

    create_horarios_table = """CREATE TABLE horarios (
    fechaYHora VARCHAR(20) NOT NULL,
    PRIMARY KEY(fechaYHora)
    );"""

    create_horarios_recintos_table = """CREATE TABLE horariosRecintos (
    fechaYHora VARCHAR(20) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    FOREIGN KEY(fechaYHora) references horarios(fechaYHora),
    FOREIGN KEY(direccion) references recintos(direccion),
    primary key(fechaYHora, direccion)
    );"""

    create_evento_table = """CREATE TABLE eventos (
    nombreEsp VARCHAR(20) NOT NULL,
    tipoEsp VARCHAR(20) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(20) NOT NULL,
    fechaYHora VARCHAR(20) NOT NULL,
    direccion VARCHAR(30) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
    primary key (nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );"""
    
    create_gradas_table = """CREATE TABLE gradas (
    nombreGrada VARCHAR(20) NOT NULL,
    nombreEsp VARCHAR(20) NOT NULL,
    tipoEsp VARCHAR(20) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(20) NOT NULL,
    fechaYHora VARCHAR(20) NOT NULL,
    direccion VARCHAR(30) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
    PRIMARY KEY(nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );"""

    create_localidades_table = """CREATE TABLE localidades (
    asientoLocalidad INT NOT NULL,
    nombreGrada VARCHAR(20) NOT NULL,
    nombreEsp VARCHAR(20) NOT NULL,
    tipoEsp VARCHAR(20) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(20) NOT NULL,
    fechaYHora VARCHAR(20) NOT NULL,
    direccion VARCHAR(30) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada),
    PRIMARY KEY(asientoLocalidad, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );"""

    create_tarifas_table = """CREATE TABLE tarifas (
    tipoUsuario VARCHAR(10) NOT NULL,
    precio INT NOT NULL,
    maxLocalidadesReserva INT NOT NULL,
    asientoLocalidad INT NOT NULL,
    nombreGrada VARCHAR(20) NOT NULL,
    nombreEsp VARCHAR(20) NOT NULL,
    tipoEsp VARCHAR(20) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(20) NOT NULL,
    fechaYHora VARCHAR(20) NOT NULL,
    direccion VARCHAR(30) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada),
    FOREIGN KEY(asientoLocalidad) references localidades(asientoLocalidad),
    PRIMARY KEY(tipoUsuario, asientoLocalidad, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );"""

    create_clientes_table = """CREATE TABLE clientes (
    correoCliente VARCHAR(30),
    nombreCliente VARCHAR(20),
    tltCliente INT(9),
    datosBanco VARCHAR(20),
    PRIMARY KEY(correoCliente)
    );"""

    create_entradas_table = """CREATE TABLE entradas (
    estado VARCHAR(10) NOT NULL,
    formaPago VARCHAR(10) NOT NULL,
    horaReserva DATE NOT NULL,
    correoCliente VARCHAR(20),
    tipoUsuario VARCHAR(10) NOT NULL,
    asientoLocalidad INT NOT NULL,
    nombreGrada VARCHAR(20) NOT NULL,
    nombreEsp VARCHAR(20) NOT NULL,
    tipoEsp VARCHAR(20) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(20) NOT NULL,
    fechaYHora VARCHAR(20) NOT NULL,
    direccion VARCHAR(30) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada),
    FOREIGN KEY(asientoLocalidad) references localidades(asientoLocalidad),
    FOREIGN KEY(tipoUsuario) references tarifas(tipoUsuario),
    FOREIGN KEY(correoCliente) references clientes(correoCliente),
    PRIMARY KEY(horaReserva)
    );"""

    create_cancelaciones_table = """CREATE TABLE cancelaciones (
    formaPago VARCHAR(10) NOT NULL,
    horaReserva DATE NOT NULL,
    correoCliente VARCHAR(20),
    tipoUsuario VARCHAR(10) NOT NULL,
    asientoLocalidad INT NOT NULL,
    nombreGrada VARCHAR(20) NOT NULL,
    nombreEsp VARCHAR(20) NOT NULL,
    tipoEsp VARCHAR(20) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(20) NOT NULL,
    fechaYHora VARCHAR(20) NOT NULL,
    direccion VARCHAR(30) NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora),
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion),
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada),
    FOREIGN KEY(asientoLocalidad) references localidades(asientoLocalidad),
    FOREIGN KEY(tipoUsuario) references tarifas(tipoUsuario),
    FOREIGN KEY(correoCliente) references clientes(correoCliente),
    PRIMARY KEY(horaReserva)
    );"""


    with open('./data.sql', 'w') as f:
        f.write("DROP DATABASE IF EXISTS proyecto;\n")
        f.write("CREATE DATABASE proyecto;\n")
        f.write("USE proyecto;\n")
        f.write(create_espectaculos_table + "\n")
        f.write(create_horarios_table + "\n")
        f.write(create_recintos_table + "\n")
        f.write(create_horarios_recintos_table + "\n")
        f.write(create_evento_table + "\n")
        f.write(create_gradas_table + "\n")
        f.write(create_localidades_table + "\n")
        f.write(create_tarifas_table + "\n")
        f.write(create_clientes_table + "\n")
        f.write(create_entradas_table + "\n")
        f.write(create_cancelaciones_table + "\n")

        if sys.argv[1]:
            insert_espectaculos(f, int(sys.argv[1]))
            insert_recintos(f, int(sys.argv[1]))
        

    

if __name__ == "__main__":
    main()
