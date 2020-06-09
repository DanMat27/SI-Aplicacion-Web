$(document).ready(function(){
    $(".flip").click(function(){
        $(this).next().find(".panel").slideToggle("slow");
    });
});