# -*- coding: utf-8 -*-

'''
  File: database.py
  Fichero con las funciones que acceden a la BD
  Autores: Daniel Mateo
           Aitor Melero
'''

import os
import sys, traceback
from sqlalchemy import create_engine
from sqlalchemy import Table, Column, Integer, String, MetaData, ForeignKey, text
from sqlalchemy.sql import select

# Configuramos sqlalchemy
db_engine = create_engine("postgresql://alumnodb:alumnodb@localhost/si1", echo=False)
db_meta = MetaData(bind=db_engine)
# Cargamos algunas tablas
db_table_movies = Table('imdb_movies', db_meta, autoload=True, autoload_with=db_engine)
db_table_usuarios = Table('customers', db_meta, autoload=True, autoload_with=db_engine)


# Devuelve 10 peliculas de la tabla peliculas, mostradas en index
def db_index():
    try:
        # conexion a la base de datos
        db_conn = None
        db_conn = db_engine.connect()
        
        # Seleccionar las peliculas para mostrarlas en index
        #db_movies_2019 = select([db_table_movies]).where(text("year = '2019' limit 10"))
        #db_result = db_conn.execute(db_movies_2019)
        db_result = db_conn.execute("Select * from imdb_movies limit 10")
        
        db_conn.close()
        
        return list(db_result)
    except:
        if db_conn is not None:
            db_conn.close()
        print("Exception in DB access:")
        print("-"*60)
        traceback.print_exc(file=sys.stderr)
        print("-"*60)

        return 'Something is broken'


# Funcion que crea un nuevo usuario en la BD
def db_crearUsuario(email, nombre, contrasenia, tarjeta, saldo):
    uwu = "uwu"
    id_mayor = list()

    try:
        db_conn = None
        db_conn = db_engine.connect()

        db_usuario = select([db_table_usuarios]).where(text("email = email"))
        db_result = db_conn.execute(db_usuario)

        #existe ese usuario
        if len(list(db_result)) is 0:
            db_conn.close()
            return False

        db_id_usuario_mayor = db_conn.execute("SELECT MAX(customerid) FROM customers") 
        for i,row in enumerate(db_id_usuario_mayor.fetchall()):
            id_mayor.append(row[i])
        id_mayor[0] += 1
        print("Nuevo id usuario creado:" + str(id_mayor[0]))

        db_conn.execute("INSERT INTO customers(customerid, email, address1, country, city, region, firstname, lastname, username, password, creditcard, creditcardtype, creditcardexpiration, income) \
        VALUES('" + str(id_mayor[0]) + "','" + email + "','" + uwu + "','" + uwu + "','" + uwu + "','" + uwu + "','" + nombre + "','" + nombre + "','" + nombre + "','" + contrasenia + "','" + tarjeta + "','" \
        + uwu + "','" + uwu + "','" + saldo + "')")

        db_conn.close()

        return True

    except:
        if db_conn is not None:
            db_conn.close()
        print("Exception in DB access:")
        print("-"*60)
        traceback.print_exc(file=sys.stderr)
        print("-"*60)
        return False
    

# Funcion que indica si los datos pasados son de un usuario existente
def db_iniciarSesion(nombre, contrasenia):
    try:
        # conexion a la base de datos
        db_conn = None
        db_conn = db_engine.connect()
        
        db_usuario = select([db_table_usuarios]).where(text("email = '" + nombre + "' AND password = '" + contrasenia + "'"))
        db_result = db_conn.execute(db_usuario)
        
        db_conn.close()

        #no existe ese usuario
        if len(list(db_result)) is 0:
            return False
        
        return True

    except:
        if db_conn is not None:
            db_conn.close()
        print("Exception in DB access:")
        print("-"*60)
        traceback.print_exc(file=sys.stderr)
        print("-"*60)

        return False


# Funcion que obtiene todas las peliculas con un mismo genero
def db_search_films(categoria):
    try:
        # conexion a la base de datos
        db_conn = None
        db_conn = db_engine.connect()

        if categoria == 'All':
            db_result = db_conn.execute("SELECT imdb_movies.movieid, movietitle FROM imdb_movies \
            JOIN imdb_moviegenres ON imdb_movies.movieid=imdb_moviegenres.movieid JOIN genres \
            ON imdb_moviegenres.genreid=genres.genreid")
        
        else:
            db_result = db_conn.execute("SELECT imdb_movies.movieid, movietitle FROM imdb_movies \
            JOIN imdb_moviegenres ON imdb_movies.movieid=imdb_moviegenres.movieid JOIN genres \
            ON imdb_moviegenres.genreid=genres.genreid WHERE genre_name='" + categoria + "'")

        db_conn.close()
        
        return list(db_result)
    except:
        if db_conn is not None:
            db_conn.close()
        print("Exception in DB access:")
        print("-"*60)
        traceback.print_exc(file=sys.stderr)
        print("-"*60)

        return 'Something is broken'


# Funcion que devuelve los datos importantes para detalle de una pelicula
def db_detalle(idpeli):
    try:
        # conexion a la base de datos
        db_conn = None
        db_conn = db_engine.connect()
        db_result = {}
        
        db_result['titulo'] = []
        db_titulo = db_conn.execute("Select imdb_movies.movietitle from imdb_movies where movieid = '"+ idpeli +"'")
        
        for tuple in list(db_titulo):
            newTuple = str(tuple)
            for char in newTuple:
                if char in "()',":
                    newTuple = newTuple.replace(char,'')
            print(newTuple)
            db_result['titulo'].append(newTuple) 
        
        db_result['anyo'] = []
        db_anyo = db_conn.execute("Select imdb_movies.year from imdb_movies where movieid = '"+ idpeli +"'")
        
        for tuple in list(db_anyo):
            newTuple = str(tuple)
            for char in newTuple:
                if char in "()',":
                    newTuple = newTuple.replace(char,'')
            print(newTuple)
            db_result['anyo'].append(newTuple) 
        
        db_result['genero'] = []    
        db_genero = db_conn.execute("Select genres.genre_name from imdb_movies, imdb_moviegenres, \
        genres where imdb_movies.movieid = '"+ idpeli +"' and imdb_moviegenres.movieid = '"+ idpeli +"' \
        and genres.genreid = imdb_moviegenres.genreid")

        for tuple in list(db_genero):
            newTuple = str(tuple)
            for char in newTuple:
                if char in "()',":
                    newTuple = newTuple.replace(char,'')
            print(newTuple)
            db_result['genero'].append(newTuple)


        db_result['director'] = []    
        db_director= db_conn.execute("Select imdb_directors.directorname from imdb_movies, imdb_directormovies, \
        imdb_directors where imdb_movies.movieid = '"+ idpeli +"' and imdb_directormovies.movieid = '"+ idpeli +"' \
        and imdb_directors.directorid = imdb_directormovies.directorid")

        for tuple in list(db_director):
            newTuple = str(tuple)
            for char in newTuple:
                if char in "()',":
                    newTuple = newTuple.replace(char,'')
            print(newTuple)
            db_result['director'].append(newTuple)     
        
        db_result['precio'] = []         
        db_precio = db_conn.execute("Select products.price from imdb_movies, products where \
        imdb_movies.movieid = products.movieid and products.movieid = '"+ idpeli +"' limit 1")
        
        for tuple in list(db_precio):
            newTuple = str(tuple)
            for char in newTuple:
                if char in "()',Decimal":
                    newTuple = newTuple.replace(char,'')
            print(newTuple)
            db_result['precio'].append(newTuple)   

        db_conn.close()
        
        return db_result

    except:
        if db_conn is not None:
            db_conn.close()
        print("Exception in DB access:")
        print("-"*60)
        traceback.print_exc(file=sys.stderr)
        print("-"*60)

        return 'Something is broken'


#Funcion que devuelve el top ventas usando el procedimiento almacenado getTopVentas()
def db_top_ventas():
    try:
        # conexion a la base de datos
        db_conn = None
        db_conn = db_engine.connect()

        db_result = db_conn.execute("SELECT * FROM getTopVentas(2016)")

        db_conn.close()
        
        return db_result

    except:
        if db_conn is not None:
            db_conn.close()
        print("Exception in DB access:")
        print("-"*60)
        traceback.print_exc(file=sys.stderr)
        print("-"*60)

        return 'Something is broken'


# Funcion que devuelve los datos del perfil de un usuario
def db_perfil(email):
    try:
        # conexion a la base de datos
        db_conn = None
        db_conn = db_engine.connect()

        db_result = db_conn.execute("SELECT income, creditcard FROM customers WHERE email = '" + email + "'")

        db_conn.close()
        
        return db_result

    except:
        if db_conn is not None:
            db_conn.close()
        print("Exception in DB access:")
        print("-"*60)
        traceback.print_exc(file=sys.stderr)
        print("-"*60)

        return 'Something is broken'


# Funcion que modifica el saldo con el nuevo pasado de un usuario
def db_aumentar_saldo(nombre, saldo):
    try:
        # conexion a la base de datos
        db_conn = None
        db_conn = db_engine.connect()
        
        # Aumentamos el saldo
        db_conn.execute("UPDATE customers SET income = '" + saldo + "' where email='" + nombre + "'")
        db_conn.close()
        
        return True

    except:
        if db_conn is not None:
            db_conn.close()
        print("Exception in DB access:")
        print("-"*60)
        traceback.print_exc(file=sys.stderr)
        print("-"*60)

        return 'Something is broken'


# Funcion que devuelve los orders de un usuario pasado
def db_historial(usuario):
    try:
        # conexion a la base de datos
        db_conn = None
        db_conn = db_engine.connect()
        
        db_result = db_conn.execute("SELECT orders.orderid, totalamount, netamount, status, orderdate, tax \
        FROM orders JOIN customers ON orders.customerid = customers.customerid \
        WHERE email = '"+ usuario + "'")
        db_conn.close()
        
        return db_result

    except:
        if db_conn is not None:
            db_conn.close()
        print("Exception in DB access:")
        print("-"*60)
        traceback.print_exc(file=sys.stderr)
        print("-"*60)
