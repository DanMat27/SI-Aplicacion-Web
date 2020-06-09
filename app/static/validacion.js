function validar(formulario) {
    var nombre, contrasenia, contrasenia2, edad, email, expresion;
    nombre = formulario.nombre.value;
    contrasenia = formulario.contrasenia.value;
    contrasenia2 = formulario.contrasenia2.value;
    email = formulario.email.value;
    tarjeta = formulario.tarjeta.value;
    expresion = /^[a-zA-Z0-9_-]{4,}$/;
    expresion2 = /\w+@\w+\.+[a-z]/;

    if (nombre == "" || contrasenia == "" || contrasenia2 == "" ||
    email == "" || tarjeta == "") {
      alert("Rellene todos los campos");
      return false;
    }

    if (nombre.length < 4) {
      alert("Nombre demasiado corto");
      return false;
    }

    if (!expresion.test(nombre)) {
      alert("Nombre con caracteres incorrectos");
      return false;
    }

    if (contrasenia.length < 8) {
      alert("Contraseña demasiado corta");
      return false;
    }

    if (contrasenia != contrasenia2) {
      alert("Confirmación de contraseña errónea");
      return false;
    }

    if (!expresion2.test(email)) {
      alert("Correo incorrecto");
      return false;
    }

    if (tarjeta.length != 16 || isNaN(tarjeta)) {
      alert("Número de tarjeta incorrecta");
      return false;
    }

    return true;
  }