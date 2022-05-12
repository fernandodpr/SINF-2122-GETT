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


def insert_espectaculo(f, n):
    for i in range(n):
        nombre = "espectaculo {}".format(i)
        productora = "productora {}".format(i)
        participantes = "lista participantes {}".format(i)
        
        insert = "\nINSERT INTO espectaculo (nombre, tipo, fechaProduccion, productora, participantes, penalizacion, tValidezReserva, tAntelacionReserva, tCancelacion)"
        values = " VALUES ('" + nombre + "', '" + random_tipo_espectaculo() + "', '" + str(random_fecha_produccion()) + "', '" + productora + "', '" + participantes + "', " + random_penalizacion() + ", 1, 2, 4);"
        
        query = insert + values
        f.write(query)


### MAIN FUNCTION ###
def main():

    create_espectaculo_table = """CREATE TABLE espectaculo (
    nombre VARCHAR(20) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    fechaProduccion DATE NOT NULL,
    productora VARCHAR(20) NOT NULL,
    participantes VARCHAR(30),
    penalizacion INT NOT NULL,
    tValidezReserva INT NOT NULL,
    tAntelacionReserva INT NOT NULL,
    tCancelacion INT NOT NULL,
    PRIMARY KEY(nombre, tipo, fechaProduccion, productora, participantes));"""

    create_exemplo_table = """
    CREATE TABLE IF NOT EXISTS exemplo (
        nombre VARCHAR(20) NOT NULL,
        tipo VARCHAR(20) NOT NULL,
        PRIMARY KEY(nombre)
    );
    """
    
    with open('./data.sql', 'w') as f:
        f.write("DROP DATABASE IF EXISTS proyecto;\n")
        f.write("CREATE DATABASE proyecto;\n")
        f.write("USE proyecto;\n")
        f.write(create_espectaculo_table + "\n")
        insert_espectaculo(f, int(sys.argv[1]))
        

    

if __name__ == "__main__":
    main()
