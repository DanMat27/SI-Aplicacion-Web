#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
  File: routes.py
  Fichero con las funciones de control de la app
  Autores: Daniel Mateo
           Aitor Melero
'''

from app import app
from flask import render_template, request, url_for, redirect, session, make_response
import json
import os
import sys
import hashlib
import random
from datetime import date
from app import database


@app.route('/')
# Ruta para la pagina principal
@app.route('/index')
def index():
    session.modified = True
    print(url_for('static', filename='style.css'), file=sys.stderr)
    catalogue = database.db_index()
    if 'carrito' not in session:
        session['carrito'] = []
    return render_template('index.html', movies=catalogue)


# Ruta para la búsqueda de peliculas
# Funcion de busqueda de peliculas (recibe formulario)
# Si no introduces nada en el buscador, muestra las peliculas de
# la categoria seleccionada en el desplegable.
# Si introduces el nombre de la peli, o una subcadena de ese nombre,
# te muestra las peliculas encontradas con ello.
@app.route('/index_busqueda', methods=['GET', 'POST'])
def index_busqueda():
    print(url_for('static', filename='style.css'), file=sys.stderr)
    catalogue = database.db_index()

    if 'uwufilmsearch' in request.form:

        print("Categoria elegida: " + request.form['categoria'])

        if request.form['uwufilmsearch'] == '':

            if request.form['categoria'] == 'All':
                session.modified = True
                return render_template('index.html', movies=catalogue)

            else:
                peliculas = database.db_search_films(request.form['categoria'])
                session.modified = True
                return render_template('index.html', movies=peliculas)

        else:

            if request.form['categoria'] == 'All':
                session.modified = True
                peliculas = database.db_search_films("All")
                movies = []
                for pelicula in peliculas:
                    buscado = request.form['uwufilmsearch'].lower()
                    peli = pelicula['movietitle'].lower()
                    flag = 0
                    i = 0
                    while ((i < len(buscado)) & (i < len(peli))):
                        if buscado[i] == peli[i]:
                            flag += 1
                        i += 1
                    if flag == len(buscado):
                        movies.append(pelicula)
                return render_template('index.html', movies=movies)

            else:
                session.modified = True
                peliculas = database.db_search_films(request.form['categoria'])
                movies = []
                for pelicula in peliculas:
                    buscado = request.form['uwufilmsearch'].lower()
                    peli = pelicula['movietitle'].lower()
                    flag = 0
                    i = 0
                    while ((i < len(buscado)) & (i < len(peli))):
                        if buscado[i] == peli[i]:
                            flag += 1
                        i += 1
                    if flag == len(buscado):
                        movies.append(pelicula)
                return render_template('index.html', movies=movies)


# Ruta para la pagina del registro
@app.route('/registro')
def registro():
    print(url_for('static', filename='style.css'), file=sys.stderr)
    session.modified = True
    return render_template('registro.html')


# Ruta para crear un usuario
# Creamos el usuario y lo guardamos en la base de datos
# con los datos del formulario
# El id del nuevo usuario lo conseguimos sacando el id
# maximo y sumandole uno a dicho id
@app.route('/crear_usuario', methods=['GET', 'POST'])
def crear_usuario():
    nombre = request.form["nombre"]
    contrasenia = request.form["contrasenia"]
    email = request.form["email"]
    tarjeta = request.form["tarjeta"]
    saldo = str(random.randint(0, 100))
    dir_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    cad_error = []

    if database.db_crearUsuario(email, nombre, contrasenia, tarjeta, saldo):
        session.modified = True
        return render_template('login.html', mensaje=cad_error)

    else:
        cad_error.append("Error, ya hay un usuario registrado con ese nombre")
        return render_template('registro.html', mensaje=cad_error)


# Ruta para la pagina del historial
@app.route('/historial')
def historial():
    print(url_for('static', filename='style.css'), file=sys.stderr)

    if 'usuario' not in session:
        cad_error = []
        cad_error.append("Error, debe registrarse para ver su historial de compra")
        session.modified = True
        return render_template('registro.html', mensaje=cad_error)

    catalogue = database.db_historial(session['usuario'])

    session.modified = True
    return render_template('historial.html', movies=catalogue)


# Ruta para el carrito
@app.route('/carrito')
def carrito():
    print(url_for('static', filename='style.css'), file=sys.stderr)

    precio_total = 0
    for peli in session['carrito']:
        precio_total += peli['precio']

    session.modified = True
    return render_template('carrito.html', movies=session['carrito'], precio=precio_total)


# Ruta para aniadir al carrito
@app.route('/add_carrito', methods=['GET', 'POST'])
def add_carrito():
    id_peli = request.form['pelicula_carrito']

    

    session.modified = True
    return render_template('index.html', movies=catalogue['peliculas'])


# Ruta para quitar del carrito
@app.route('/descartar_carrito', methods=['GET', 'POST'])
def descartar_carrito():
    id_peli = request.form["pelicula"]

    i = -1
    for peli in session['carrito']:
        i += 1
        if peli['id'] == id_peli:
            print(id_peli)
            break

    session['carrito'].pop(i)
    session.modified = True
    return redirect(url_for('carrito'))


# Ruta para pagar el carrito
@app.route('/pagar_carrito', methods=['GET', 'POST'])
def pagar_carrito():
    dir_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    if 'usuario' not in session:
        cad_error = []
        cad_error.append("Debe registrarse para pagar las peliculas del carrito")
        session.modified = True
        return render_template('registro.html', mensaje=cad_error)

    catalogue_data = open(os.path.join(app.root_path, dir_path + '/usuarios/' + session['usuario'] + '/historial.json'),
                          encoding="utf-8").read()
    historial = json.loads(catalogue_data)

    f = open(dir_path + '/usuarios/' + session['usuario'] + '/datos.dat', 'r')
    fichero_leido = f.read()
    fich_cortado = fichero_leido.split('\n')
    nombre = fich_cortado[0]
    contrasenia = fich_cortado[1]
    email = fich_cortado[2]
    tarjeta = fich_cortado[3]
    s = fich_cortado[4]
    f.close()

    saldo = float(s)

    precio_total = 0
    for peli in session['carrito']:
        p = peli
        precio_total += p['precio']
        f = date.today()
        p['fecha_compra'] = f.strftime("%d/%m/%Y")
        print(p['fecha_compra'])
        historial[nombre].append(p)

    if saldo < precio_total:
        cad_error = []
        cad_error.append("Error. Saldo insuficiente para la compra.")
        session.modified = True
        return render_template('carrito.html', mensaje=cad_error)

    with open(dir_path + '/usuarios/' + nombre + '/historial.json', 'w') as file:
        json.dump(historial, file, indent=4)

    saldo -= precio_total

    f = open(dir_path + '/usuarios/' + nombre + '/datos.dat', 'w')
    f.write(nombre + '\n')
    f.write(contrasenia + '\n')
    f.write(email + '\n')
    f.write(tarjeta + '\n')
    f.write(str(saldo) + '\n')
    f.close()

    session['carrito'] = []
    session.modified = True
    return render_template('carrito.html', movies=session['carrito'])


# Ruta para la pagina del login
@app.route('/login')
def login():
    session.modified = True
    print(url_for('static', filename='style.css'), file=sys.stderr)
    lastuser = request.cookies.get('lastuser')
    return render_template('login.html', usuario_anterior = lastuser)


# Ruta para iniciar sesion
@app.route('/iniciar_sesion', methods=['GET', 'POST'])
def iniciar_sesion():
    catalogue = database.db_index()
    nombre = request.form["nombre"]
    contrasenia = request.form["contrasenia"]
    dir_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    cad_error = []

    if database.db_iniciarSesion(nombre, contrasenia):
        session['usuario'] = nombre
        session.modified = True
        return render_template('index.html', movies=catalogue)
    else:
        session.modified = True
        cad_error.append("Error al intentar iniciar sesión")
        return render_template('login.html', mensaje=cad_error)


# Ruta para cerrar sesion
# Hace pop del usuario iniciado y lo guarda en una cookie como
# el ultimo usuario conectado.
@app.route('/logout', methods=['GET', 'POST'])
def logout():
    catalogue = database.db_index()
    session['carrito'] = []
    usuario = session['usuario']
    session.pop('usuario', None)
    response = make_response(render_template('index.html', movies=catalogue))
    response.set_cookie('lastuser', usuario)
    session.modified = True
    return response


# Ruta para la pagina del detalle de la pelicula
# Funcion que muestra la informacion correspondiente a una pelicula.
# Recibe un formulario y obtiene el id de la pelicula mediante
# un campo hidden en la pagina de index.
@app.route('/detalle', methods=['GET', 'POST'])
def detalle():
    print(url_for('static', filename='style.css'), file=sys.stderr)
    id_peli = request.form['id_pelicula']
    catalogue = database.db_detalle(id_peli)
    print(catalogue)
    session.modified = True
    return render_template('detalle_pelicula.html', peliculas=catalogue['titulo'], 
                           anios=catalogue['anyo'], generos=catalogue['genero'], 
                           precios=catalogue['precio'], directores=catalogue['director'],
                           id_peli=id_peli)


# Ruta para la pagina del perfil del usuario conectado
@app.route('/perfil')
def perfil():
    dir_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    catalogue = database.db_perfil(session['usuario'])
    session.modified = True
    return render_template('perfil.html', dic = catalogue)


# Ruta para aumentar el saldo de un usuario
@app.route('/aumentar_saldo', methods=['GET', 'POST'])
def aumentar_saldo():
    dir_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    saldo = request.form['money']
    aumento = request.form['aumento']

    nuevoSaldo = str(int(saldo) + int(aumento))

    database.db_aumentar_saldo(session['usuario'], nuevoSaldo)

    session.modified = True
    return redirect(url_for('perfil'))


# Para generar un numero aleatorio de visitantes
@app.route('/aleat', methods=['GET', 'POST'])
def aleat():
    aleatorio = random.randint(1, 4000)
    return str(aleatorio)


# Ruta para mostrar peliculas mas vendidas desde el 2016
@app.route('/ventas')
def ventas():
    catalogue = database.db_top_ventas()
    return render_template('index.html', movies=catalogue, ventas=True)
