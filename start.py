'''
INSTRUCCIÓNS:
1) executar este script co comando "python3 start.py <num tuplas>"
    num tuplas é o número de instancias que queremos crear na táboa espectáculo
2) crease o fichero data.sql no directorio onde executas o script
3) executas data.sql co comando "mysql -u root -p < data.sql"
4) abres mysql e xa tes na base de datos "proyecto" as taboas e datos
'''
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

''' este metodo non se usa, creamos os espectaculos no metodo insert_eventos
def insert_espectaculos(f, n):
    for i in range(n):
        nombreEsp = f"espectaculo {i}"
        tipoEsp = random_tipo_espectaculo()
        fechaProduccion = str(random_fecha_produccion())
        productora = f"productora {i}"
        participantes = f"lista participantes {i}"
        penalizacion = random_penalizacion()

        query = f"\nINSERT INTO espectaculos VALUES ('{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{participantes}', {penalizacion}, '00:01:00', '00:02:00', '00:04:00');"
        f.write(query)
'''



def insert_recintos(f, n):
    for i in range(n):
        dir = f"Calle de las flores número {i} puerta C"
        nombre = f"Recinto {i}"

        query = f"\nINSERT INTO recintos VALUES ('{dir}', '{nombre}');"
        f.write(query)


def insert_horarios(f):
    query = f"\nINSERT INTO horarios VALUES ('2022-09-01 18:00:00');"
    f.write(query)
    query = f"\nINSERT INTO horarios VALUES ('2021-09-01 18:00:00');"
    f.write(query)
    query = f"\nINSERT INTO horarios VALUES ('2020-09-01 03:00:00');"
    f.write(query)


def insert_horariosRecintos(f, n):
    for i in range(n):
        dir = f"Calle de las flores número {i} puerta C"

        query = f"\nINSERT INTO horariosRecintos VALUES ('2022-09-01 18:00:00', '{dir}');"
        f.write(query)
        query = f"\nINSERT INTO horariosRecintos VALUES ('2021-09-01 18:00:00', '{dir}');"
        f.write(query)
        query = f"\nINSERT INTO horariosRecintos VALUES ('2020-09-01 03:00:00', '{dir}');"
        f.write(query)


def insert_localidades(inserts, m, nombreGrada, nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora, dir):
    for i in range(m):
        inserts.append(f"\nINSERT INTO localidades VALUES ({i},'{nombreGrada}', '{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{fechaYHora}', '{dir}', 'Libre');")

def insert_eventos(f, n):

    # datos estaticos
    ## rey leon nunha sala para todo o publico pero distintos prezos
    inserts = []
    inserts.append("\nINSERT INTO espectaculos VALUES ('Rey Leon', 'pelicula', '1994-01-01', 'Disney', 'dibujos animados', 3, '00:01:00', '00:02:00', '00:04:00');")

    # isto dos recintos e horarios hai q conseguir q se metan automatico q senon...
    inserts.append("\nINSERT INTO recintos VALUES ('Cines Gran Via Vigo sala 1', 'Cine Gran Via');")
    inserts.append("\nINSERT INTO recintos VALUES ('Cines Gran Via Vigo sala 2', 'Cine Gran Via');")
    inserts.append("\nINSERT INTO recintos VALUES ('Auditorio Mar de Vigo', 'Auditorio Mar de Vigo');")
    inserts.append("\nINSERT INTO horarios VALUES ('2022-07-01 19:00:00');")
    inserts.append("\nINSERT INTO horarios VALUES ('2022-07-10 20:30:00');")
   
    inserts.append("\nINSERT INTO horariosRecintos VALUES ('2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');")
    inserts.append("\nINSERT INTO horariosRecintos VALUES ('2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');")
    inserts.append("\nINSERT INTO horariosRecintos VALUES ('2022-07-10 20:30:00', 'Auditorio Mar de Vigo');")

    inserts.append("\nINSERT INTO eventos VALUES ('Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1','Abierto');")

    inserts.append("\nINSERT INTO gradas VALUES ('grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');")
    insert_localidades(inserts, 30, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1')
    inserts.append("\nINSERT INTO tarifas VALUES ('bebe', 0, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');")
    inserts.append("\nINSERT INTO tarifas VALUES ('infantil', 5, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');")
    inserts.append("\nINSERT INTO tarifas VALUES ('juvenil', 8, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');")
    inserts.append("\nINSERT INTO tarifas VALUES ('adulto', 10, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');")
    inserts.append("\nINSERT INTO tarifas VALUES ('jubilado', 5, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 1');")

    ''' comentado para tes so unha grada nunha sala, de querer máis descomentar
    inserts.append("\nINSERT INTO gradas VALUES ('grada 2', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo, sala 1');")
    inserts.append("\nINSERT INTO tarifas VALUES ('bebe', 0, 5, 'grada 2', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo, sala 1');")
    inserts.append("\nINSERT INTO tarifas VALUES ('infantil', 7, 5, 'grada 2', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo, sala 1');")
    inserts.append("\nINSERT INTO tarifas VALUES ('juvenil', 10, 5, 'grada 2', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo, sala 1');")
    inserts.append("\nINSERT INTO tarifas VALUES ('adulto', 12, 5, 'grada 2', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo, sala 1');")
    inserts.append("\nINSERT INTO tarifas VALUES ('jubilado', 7, 5, 'grada 2', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo, sala 1');")    
    '''

    # rey leon a mesma hora q o anterior pero noutra sala, para todo o publico pero distintos prezos
    inserts.append("\nINSERT INTO eventos VALUES ('Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2','Abierto');")

    inserts.append("\nINSERT INTO gradas VALUES ('grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');")
    insert_localidades(inserts, 30,'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2')
    inserts.append("\nINSERT INTO tarifas VALUES ('bebe', 0, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');")
    inserts.append("\nINSERT INTO tarifas VALUES ('infantil', 5, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');")
    inserts.append("\nINSERT INTO tarifas VALUES ('juvenil', 8, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');")
    inserts.append("\nINSERT INTO tarifas VALUES ('adulto', 10, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');")
    inserts.append("\nINSERT INTO tarifas VALUES ('jubilado', 5, 5, 'grada 1', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo sala 2');")

    '''comentado para tes so unha grada nunha sala, de querer máis descomentar
    inserts.append("\nINSERT INTO gradas VALUES ('grada 2', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo, sala 2');")
    inserts.append("\nINSERT INTO tarifas VALUES ('bebe', 0, 5, 'grada 2', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo, sala 2');")
    inserts.append("\nINSERT INTO tarifas VALUES ('infantil', 7, 5, 'grada 2', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo, sala 2');")
    inserts.append("\nINSERT INTO tarifas VALUES ('juvenil', 10, 5, 'grada 2', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo, sala 2');")
    inserts.append("\nINSERT INTO tarifas VALUES ('adulto', 12, 5, 'grada 2', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo, sala 2');")
    inserts.append("\nINSERT INTO tarifas VALUES ('jubilado', 7, 5, 'grada 2', 'Rey Leon', 'pelicula', '1994-01-01', 'Disney', '2022-07-01 19:00:00', 'Cines Gran Via Vigo, sala 2');")    
     '''
    
    # teatro para adultos e xubilados con varias gradas
    inserts.append("\nINSERT INTO espectaculos VALUES ('Hamlet', 'teatro', '2010-01-01', 'Teatro andante', 'Pedro Gomez - Laura Perez', 5, '00:01:00', '00:02:00', '00:04:00');")
    inserts.append("\nINSERT INTO eventos VALUES ('Hamlet', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo','Abierto');")

    inserts.append("\nINSERT INTO gradas VALUES ('grada centro', 'Hamlet', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');")
    insert_localidades(inserts, 50, 'grada centro', 'Hamlet', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo')
    inserts.append("\nINSERT INTO tarifas VALUES ('adulto', 20, 5, 'grada centro', 'Hamlet', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');")
    inserts.append("\nINSERT INTO tarifas VALUES ('jubilado', 12, 5, 'grada centro', 'Hamlet', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');")

    inserts.append("\nINSERT INTO gradas VALUES ('grada superior', 'Hamlet', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');")
    insert_localidades(inserts, 50, 'grada superior', 'Hamlet', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo')
    inserts.append("\nINSERT INTO tarifas VALUES ('adulto', 18, 5, 'grada superior', 'Hamlet', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');")
    inserts.append("\nINSERT INTO tarifas VALUES ('jubilado', 10, 5, 'grada superior', 'Hamlet', 'teatro', '2010-01-01', 'Teatro andante', '2022-07-10 20:30:00', 'Auditorio Mar de Vigo');")

    # creacion por defecto
    for i in range(n):
        nombreEsp = f"espectaculo {i}"
        tipoEsp = random_tipo_espectaculo()
        fechaProduccion = str(random_fecha_produccion())
        productora = f"productora {i}"
        participantes = f"lista participantes {i}"
        penalizacion = random_penalizacion()
        tValidezReserva = random_tValidezReserva()
        tAntelacionReserva = random_tAntelacionReserva()
        tCancelacion = random_tCancelacion()
        numLoc = random_num_localidades()
        fechaYHora1 = "2022-09-01 18:00:00"
        fechaYHora2 = "2020-09-01 03:00:00"
        dirDefault = f"Calle de las flores número {i} puerta C"

        #espectaculos por defecto
        inserts.append(f"\nINSERT INTO espectaculos VALUES ('{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{participantes}', {penalizacion}, '00:{tValidezReserva}:00', '00:{tAntelacionReserva}:00', '00:{tCancelacion}:00');")
        
        # 2 eventos por defecto por espectaculo (distintas datas mesmo recinto)
        inserts.append(f"\nINSERT INTO eventos VALUES ('{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{fechaYHora1}', '{dirDefault}','Abierto');")
        inserts.append(f"\nINSERT INTO eventos VALUES ('{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{fechaYHora2}', '{dirDefault}','Abierto');")

        # 2 gradas por defecto por evento
        inserts.append(f"\nINSERT INTO gradas VALUES ('grada 1', '{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{fechaYHora1}', '{dirDefault}');")
        inserts.append(f"\nINSERT INTO gradas VALUES ('grada 2', '{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{fechaYHora1}', '{dirDefault}');")
        inserts.append(f"\nINSERT INTO gradas VALUES ('grada 1', '{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{fechaYHora2}', '{dirDefault}');")
        inserts.append(f"\nINSERT INTO gradas VALUES ('grada 2', '{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{fechaYHora2}', '{dirDefault}');")

        # localidades por defecto por grada
        insert_localidades(inserts, numLoc, 'grada 1', nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora1, dirDefault)
        insert_localidades(inserts, numLoc, 'grada 2', nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora1, dirDefault)
        insert_localidades(inserts, numLoc, 'grada 1', nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora2, dirDefault)
        insert_localidades(inserts, numLoc, 'grada 2', nombreEsp, tipoEsp, fechaProduccion, productora, fechaYHora2, dirDefault)

        # tarifas por defecto
        listaTarifaDefault = {'bebe': 0, 'infantil': 5, 'juvenil': 8, 'adulto': 10, 'jubilado': 5}
        maxLocReservaDefault = 5

        for t in listaTarifaDefault.keys():
            inserts.append(f"\nINSERT INTO tarifas VALUES ('{t}', '{listaTarifaDefault.get(t)}', '{maxLocReservaDefault}', 'grada 1', '{nombreEsp}', '{tipoEsp}', '{fechaProduccion}', '{productora}', '{fechaYHora1}', '{dirDefault}');")

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
            # agora os espectaculos por defecto engadense xa no insert_eventos
            # insert_espectaculos(f, int(sys.argv[1]))
            insert_horarios(f)
            insert_recintos(f, int(sys.argv[1]))
            insert_horariosRecintos(f, int(sys.argv[1]))
            insert_eventos(f, int(sys.argv[1]))

        f.write("\nSELECT table_name, table_rows FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'proyecto';")
    
    fin = time.time()
    print (f"Tiempo total de ejecución = {fin-inicio}")


if __name__ == "__main__":
    main()
