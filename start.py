'''
INSTRUCCIÓNS:
1) executar este script co comando "python3 start.py <num tuplas>"
    num tuplas é o número de instancias que queremos crear na táboa espectáculo
2) crease o fichero data.sql no directorio onde executas o script
3) executas data.sql co comando "mysql -u root -p < data.sql"
4) abres mysql e xa tes na base de datos "proyecto" as taboas e datos
'''
from termios import tcdrain
import time
import random
import sys

inicio = time.time()

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
    return str(random.randrange(1,11))


def random_tValidezReserva():
    return str(random.randrange(10,21))


def random_tAntelacionReserva():
    return str(random.randrange(15, 60))


def random_tCancelacion():
    return str(random.randrange(15, 31))

def random_num_localidades():
    return random.randrange(10, 51)
    

def insert_clientes(f):
    lista = [0,1,2,3,4]
    correos = ["alba@gmail.com", "omar@gmail.com", "dario@gmail.com", "martina@gmail.com", "fernando@gmail.com"]
    personas = ["Alba", "Omar", "Dario", "Martina", "Fernando"]
    telefonos = [123456789, 147258369, 987654321, 258369147, 369147258]
    banco = ["ES15753123", "ES15753123", "ES15753123", "ES15753123", "ES15753123"]

    for i in lista:
      query = f"\nINSERT INTO clientes VALUES ('{correos[i]}', '{personas[i]}', '{telefonos[i]}', '{banco[i]}');"
      f.write(query)


def insert_recinto(inserts, dir, dirName):
        inserts.append(f"\nINSERT IGNORE INTO recintos VALUES ('{dir}', '{dirName}');")


def insert_horario(inserts, h):
    inserts.append(f"\nINSERT IGNORE INTO horarios VALUES ('{h}');")


def insert_horarioRecintos(inserts, h, dir):
    inserts.append(f"\nINSERT IGNORE INTO horariosRecintos VALUES ('{h}', '{dir}');")


def insert_grada(inserts, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, dir):
    inserts.append(f"\nINSERT INTO gradas VALUES ('{nombreGrada}', '{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{fechaYHora}', '{dir}');")


def insert_grada_e_locs(inserts, m, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, dir):
    inserts.append(f"\nINSERT INTO gradas VALUES ('{nombreGrada}', '{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{fechaYHora}', '{dir}');")
    for i in range(m):
        inserts.append(f"\nINSERT INTO localidades VALUES ({i},'{nombreGrada}', '{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{fechaYHora}', '{dir}', 'Libre');")


def insert_localidades(inserts, m, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, dir):
    for i in range(m):
        inserts.append(f"\nINSERT INTO localidades VALUES ({i},'{nombreGrada}', '{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{fechaYHora}', '{dir}', 'Libre');")


def insert_espectaculo(inserts, nombreEsp, tipoEsp, fechaProduccion, productora, participantes, penalz, t1, t2, t3):
    inserts.append(f"\nINSERT INTO espectaculos VALUES ('{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{participantes}', '{penalz}', '{t1}', '{t2}', '{t3}');")


def insert_evento(inserts, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, dir):
    inserts.append(f"\nINSERT INTO eventos VALUES ('{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{fechaYHora}', '{dir}', 'Abierto');")


def insert_tarifa(inserts, listaTarifa, maxLocReserva, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, dir):
    for t in listaTarifa.keys():
        inserts.append(f"\nINSERT INTO tarifas VALUES ('{t}', '{listaTarifa.get(t)}', '{maxLocReserva}', '{nombreGrada}', '{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{fechaYHora}', '{dir}');")


def insert_data(f, n):

    # datos personalizados
    inserts = []

    ## rey leon nunha sala para todo o publico pero distintos prezos
    nombreEsp = "Rey Leon"
    tipoEsp = "pelicula"
    fechaProduccion = "1994-01-01"
    productora = "Disney"
    participantes = "dibujos animados" 
    penalizacion = 3
    tValidezReserva = "00:01:00"  # t1
    tAntelacionReserva = "00:02:00"   # t2
    tCancelacion = "00:02:00"   # t3
    horario = "2022-07-01 19:00:00"
    dirRecinto = "Cine Gran Via Vigo sala 1"
    nomRecinto = "Cine Gran Via"
    nombreGrada = "grada 1"
    numLoc = 30
    listaTarifa = {'bebe': 0, 'infantil': 5, 'juvenil': 8, 'adulto': 10, 'jubilado': 5}
    maxLocReserva = 5

    insert_espectaculo(inserts, nombreEsp, tipoEsp, fechaProduccion, productora, participantes, penalizacion, tValidezReserva, tAntelacionReserva, tCancelacion)
    insert_horario(inserts, horario)
    insert_recinto(inserts, dirRecinto, nomRecinto)
    insert_horarioRecintos(inserts, horario, dirRecinto)
    insert_evento(inserts, nombreEsp, tipoEsp, fechaProduccion, productora, horario, dirRecinto)
    insert_grada_e_locs(inserts, numLoc, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, horario, dirRecinto)
    insert_tarifa(inserts, listaTarifa, maxLocReserva, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, horario, dirRecinto)

    ## rey leon a mesma hora noutro sitio
    dirRecinto = "Cine Gran Via Vigo sala 2"
    
    insert_recinto(inserts, dirRecinto, nomRecinto)
    insert_horarioRecintos(inserts, horario, dirRecinto)
    insert_evento(inserts, nombreEsp, tipoEsp, fechaProduccion, productora, horario, dirRecinto)
    insert_grada_e_locs(inserts, numLoc, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, horario, dirRecinto)
    insert_tarifa(inserts, listaTarifa, maxLocReserva, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, horario, dirRecinto)
    
    
    ## hamlet, teatro con varias gradas, non para todo o publico, distintas tarifas por grada
    nombreEsp = "Hamlet"
    tipoEsp = "teatro"
    fechaProduccion = "2010-01-01"
    productora = "Teatro andante"
    participantes = "Pedro Gomez - Laura Perez" 
    penalizacion = 10
    tValidezReserva = "00:03:00"  # t1
    tAntelacionReserva = "00:10:00"   # t2
    tCancelacion = "00:10:00"   # t3
    horario = "2022-07-01 19:00:00"
    dirRecinto = "Auditorio Mar de Vigo"
    nomRecinto = "Auditorio Mar de Vigo"
    nombreGrada = "grada central"
    numLoc = 100
    listaTarifa = {'adulto': 35, 'jubilado': 20}
    maxLocReserva = 5

    insert_espectaculo(inserts, nombreEsp, tipoEsp, fechaProduccion, productora, participantes, penalizacion, tValidezReserva, tAntelacionReserva, tCancelacion)
    insert_horario(inserts, horario)
    insert_recinto(inserts, dirRecinto, nomRecinto)
    insert_horarioRecintos(inserts, horario, dirRecinto)
    insert_evento(inserts, nombreEsp, tipoEsp, fechaProduccion, productora, horario, dirRecinto)
    insert_grada_e_locs(inserts, numLoc, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, horario, dirRecinto)
    insert_tarifa(inserts, listaTarifa, maxLocReserva, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, horario, dirRecinto)

    nombreGrada = "grada superior"
    numLoc = 200
    listaTarifa = {'adulto': 30, 'jubilado': 15}
    insert_grada_e_locs(inserts, numLoc, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, horario, dirRecinto)
    insert_tarifa(inserts, listaTarifa, maxLocReserva, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, horario, dirRecinto)


    # creacion por defecto
    for i in range(n):
        nombreEsp = f"espectaculo {i}"
        tipoEsp = random_tipo_espectaculo()
        fechaProduccion = str(random_fecha_produccion())
        productora = f"productora {i}"
        participantes = f"lista participantes {i}"
        penalizacion = random_penalizacion()
        tValidezReserva = "00"+random_tValidezReserva()+"00"
        tAntelacionReserva = "00"+random_tAntelacionReserva()+"00"
        tCancelacion = "00"+random_tCancelacion()+"00"
        numLoc = random_num_localidades()
        fechaYHora1 = "2022-09-01 18:00:00"
        fechaYHora2 = "2020-09-01 03:00:00"
        dirDefault = f"Calle de las flores número {i} puerta C"
        dirNameDefault = f"Recinto {i}"
        gradaDefault1 = "grada 1"
        gradaDefault2 = "grada 2"

        # recinto e horarios por defecto
        insert_horario(inserts, fechaYHora1)
        insert_horario(inserts, fechaYHora2)
        insert_recinto(inserts, dirDefault, dirNameDefault)
        insert_horarioRecintos(inserts, fechaYHora1, dirDefault)
        insert_horarioRecintos(inserts, fechaYHora2, dirDefault)

        #espectaculos por defecto
        insert_espectaculo(inserts, nombreEsp, tipoEsp, fechaProduccion, productora, participantes, penalizacion,tValidezReserva, tAntelacionReserva, tCancelacion)
        
        # 2 eventos por defecto por espectaculo (distintas datas mesmo recinto)
        insert_evento(inserts, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora1, dirDefault)
        insert_evento(inserts, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora2, dirDefault)

        # 2 gradas por defecto por evento
        insert_grada_e_locs(inserts, numLoc, gradaDefault1, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora1, dirDefault)
        insert_grada_e_locs(inserts, numLoc, gradaDefault2, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora1, dirDefault)
        insert_grada_e_locs(inserts, numLoc, gradaDefault1, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora2, dirDefault)
        insert_grada_e_locs(inserts, numLoc, gradaDefault2, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora2, dirDefault)

        # tarifas por defecto
        listaTarifaDefault = {'bebe': 0, 'infantil': 5, 'juvenil': 8, 'adulto': 10, 'jubilado': 5}
        maxLocReservaDefault = 5

        insert_tarifa(inserts, listaTarifaDefault, maxLocReservaDefault, gradaDefault1, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora1, dirDefault)
        insert_tarifa(inserts, listaTarifaDefault, maxLocReservaDefault, gradaDefault2, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora1, dirDefault)
        insert_tarifa(inserts, listaTarifaDefault, maxLocReservaDefault, gradaDefault1, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora2, dirDefault)
        insert_tarifa(inserts, listaTarifaDefault, maxLocReservaDefault, gradaDefault2, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora2, dirDefault)

    for i in range(len(inserts)):
        f.write(inserts[i])


### MAIN FUNCTION ###
def main():

    create_espectaculos_table = """CREATE TABLE espectaculos (
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
    );"""

    create_recintos_table = """CREATE TABLE recintos (
    direccion VARCHAR(50) NOT NULL,
    nombre VARCHAR(30),
    PRIMARY KEY(direccion)
    );"""

    create_horarios_table = """CREATE TABLE horarios (
    fechaYHora DATETIME NOT NULL,
    PRIMARY KEY(fechaYHora)
    );"""

    create_horarios_recintos_table = """CREATE TABLE horariosRecintos (
    fechaYHora DATETIME NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    FOREIGN KEY(fechaYHora) references horarios(fechaYHora) ON DELETE CASCADE,
    FOREIGN KEY(direccion) references recintos(direccion) ON DELETE CASCADE,
    primary key(fechaYHora, direccion)
    );"""

    create_evento_table = """CREATE TABLE eventos (
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
    );"""

    create_gradas_table = """CREATE TABLE gradas (
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
    );"""

    create_localidades_table = """CREATE TABLE localidades (
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
    );"""		##estado reservado indica pagado de cualquier forma, prereservado no puede ser en efectivo

    create_tarifas_table = """CREATE TABLE tarifas (
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
    );"""

    create_clientes_table = """CREATE TABLE clientes (
    correoCliente VARCHAR(30),
    nombreCliente VARCHAR(30),
    tlfCliente INT(9),
    datosBanco VARCHAR(30),
    PRIMARY KEY(correoCliente)
    );"""

    create_entradas_table = """CREATE TABLE entradas (
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
    PRIMARY KEY(tipoUsuario, asientoLocalidad, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion)
    );"""

    create_cancelaciones_table = """CREATE TABLE cancelaciones (
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
    horaCancelacion DATETIME NOT NULL,
    FOREIGN KEY(nombreEsp, tipoEsp, fechaProduccion, productora) references espectaculos(nombreEsp, tipoEsp, fechaProduccion, productora) ON DELETE CASCADE,
    FOREIGN KEY(fechaYHora, direccion) references horariosRecintos(fechaYHora, direccion) ON DELETE CASCADE,
    FOREIGN KEY(nombreGrada) references gradas(nombreGrada) ON DELETE CASCADE,
    FOREIGN KEY(asientoLocalidad) references localidades(asientoLocalidad) ON DELETE CASCADE,
    FOREIGN KEY(tipoUsuario) references tarifas(tipoUsuario) ON DELETE CASCADE,
    FOREIGN KEY(correoCliente) references clientes(correoCliente) ON DELETE CASCADE,
    PRIMARY KEY(tipoUsuario, asientoLocalidad, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, direccion, horaCancelacion)
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
            insert_clientes(f)
            insert_data(f, int(sys.argv[1]))

        f.write("\nSELECT table_name, table_rows FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'proyecto';")
    
    fin = time.time()
    print (f"Tiempo total de ejecución = {fin-inicio}")


if __name__ == "__main__":
    main()
