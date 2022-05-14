from multiprocessing import connection
import mysql.connector
from mysql.connector import Error
import random

def create_server_connection(host_name, user_name, user_pw):
    connection = None
    
    try:
        connection = mysql.connector.connect(
            host = host_name,
            user = user_name,
            passwd = user_pw
        )
        print("MySQL DB connection successful")
    
    except Error as err:
        print("Error: ", err)

    return connection


def create_db_connection(host_name, user_name, user_pw, db_name):
    connection = None
    
    try:
        connection = mysql.connector.connect(
            host = host_name,
            user = user_name,
            passwd = user_pw,
            db = db_name
        )
        print("MySQL DB connection successful")
    
    except Error as err:
        print("Error: ", err)

    return connection


def create_db(conn, query):
    cursor = conn.cursor()
    try:
        cursor.execute(query)
        print("DB create successfully")
    except Error as err:
        print("Error: ", err)


def delete_db(conn, query):
    cursor = conn.cursor()
    try:
        cursor.execute(query)
        print("DB delete successfully")
    except Error as err:
        print("Error: ", err)


def execute_query(conn, query):
    cursor = conn.cursor()
    try:
        cursor.execute(query)
        conn.commit()
        #print("Query successfully")
    except Error as err:
        print("Error: ", err) 


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


def insert_espectaculo(conn, n):

    for i in range(n):
        
        nombre = "espectaculo {}".format(i)
        productora = "productora {}".format(i)
        participantes = "lista participantes {}".format(i)
        penaliz = random_penalizacion()
        
        insert = "INSERT INTO espectaculo (nombre, tipo, fechaProduccion, productora, participantes, penalizacion, tValidezReserva, tAntelacionReserva, tCancelacion)"
        values = " VALUES ('" + nombre + "', '" + random_tipo_espectaculo() + "', '" + str(random_fecha_produccion()) + "', '" + productora + "', '" + participantes + "', " + penaliz + ", 1, 2, 4);"
        
        query = insert + values
        #print(query)
        execute_query(conn, query)
    print("fin")


def insert_exemplo(conn, n):

    for i in range(n):
        
        nombre = "espectaculo {}".format(i)
        productora = "productora {}".format(i)
        participantes = "lista participantes {}".format(i)
        
        ex = "INSERT INTO exemplo (nombre, tipo) VALUES (" + "'" + nombre + "', '" + random_tipo_espectaculo() + "');"
        
        #print(ex)
        execute_query(conn, ex)
    print("fin")

#def create_table_
def main():
    '''xa temos a db_proba creada, podemos saltar este paso
    conn = create_server_connection("localhost", "root", "password")
    delete_db_query = "DROP DATABASE db_proba"
    create_db_query = "CREATE DATABASE db_proba"
    delete_db(conn, delete_db_query)
    create_db(conn, create_db_query)
    '''

    create_espectaculo_table = """
    CREATE TABLE IF NOT EXISTS espectaculo (
        nombre VARCHAR(20) NOT NULL,
        tipo VARCHAR(20) NOT NULL,
        fechaProduccion DATE NOT NULL,
        productora VARCHAR(20) NOT NULL,
        participantes VARCHAR(30),
        penalizacion INT NOT NULL,
        tValidezReserva INT NOT NULL,
        tAntelacionReserva INT NOT NULL,
        tCancelacion INT NOT NULL,
        PRIMARY KEY(nombre, tipo, fechaProduccion, productora, participantes)
    );
    """


    create_exemplo_table = """
        CREATE TABLE IF NOT EXISTS exemplo (
            nombre VARCHAR(20) NOT NULL,
            tipo VARCHAR(20) NOT NULL,
            PRIMARY KEY(nombre)
        );
        """


    conn = create_db_connection("localhost", "root", "password", "db_proba")
    execute_query(conn, "drop table IF EXISTS espectaculo")
    execute_query(conn, create_espectaculo_table)
    execute_query(conn, "drop table IF EXISTS exemplo")
    execute_query(conn, create_exemplo_table)
    insert_espectaculo(conn, 10)

    

if __name__ == "__main__":
    main()
