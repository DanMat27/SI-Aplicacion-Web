jQuery.fn.fortalezaClave = function(){

	$(this).each(function(){

		elem = $(this);
		barra = $('</br><span id="fortaleza" class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">Fortaleza: Insegura :(</span>');
		elem.after(barra);

		elem.keyup(function(e){
			fortalezaActual = document.getElementById("barra2_fortaleza").value;

			if(fortalezaActual.length < 8){
					$(".progress-bar").text('Fortaleza: ' + 'Insegura :(');
					$(".progress-bar").css('color', "red");
			}
			else if(fortalezaActual.length >= 8 && fortalezaActual.length < 12){
					$(".progress-bar").text('Fortaleza: ' + 'Normal :/');
					$(".progress-bar").css('color', "#F05904");
			}
			else if(fortalezaActual.length >= 12 && fortalezaActual.length < 15){
					$(".progress-bar").text('Fortaleza: ' + 'Segura :)');
					$(".progress-bar").css('color', "#2A7C1F");
			}
			else {
					$(".progress-bar").text('Fortaleza: ' + 'Extremadamente segura <:D');
					$(".progress-bar").css('color', "#0EC617");
			}

		});
	});
	return this;
}

//cuando la página esté lista, cargo la funcionalidad del plugin sobre el elemento password
$(document).ready(function(){
	$("#barra2_fortaleza").fortalezaClave();
});
