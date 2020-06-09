function bucle_segundos() {
    setInterval("enviar_usuarios()", 3000, true);
}

function enviar_usuarios() {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (xhttp.readyState == 4 && xhttp.status == 200){
            var cont = document.getElementById("usuarios");
            cont.innerHTML = "Usuarios conectados: " + xhttp.responseText;
        }
    };
    var url = document.getElementById("url").value;
    xhttp.open("GET", url , true);
    xhttp.send();
}