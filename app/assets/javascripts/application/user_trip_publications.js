$(function() {

    // pagination para show_own
    $('.pagination a').attr('data-remote', 'true');

    // AJAX call, se va a llamar cada vez que se actualiza algun filtro de cualquier tipo
    // De esta manera, la URL de busqueda nunca se va a ver en el navegador, por lo que tampoco se va a poder
    // favoritear. No tiene importancia, son filtros simples los de esta version.
    function updateTripPublications(){

        var originObject = new Object();
        originObject.description = $('#origin_description').val();
        originObject.city_name = $('#origin_city_name').val();
        originObject.region_name = $('#origin_region_name').val();
        originObject.country_name = $('#origin_country_name').val();
        originObject.lat = $('#origin_lat').val();
        originObject.lng = $('#origin_lng').val();

        var destinationObject = new Object();
        destinationObject.description = $('#destination_description').val();
        destinationObject.city_name = $('#destination_city_name').val();
        destinationObject.region_name = $('#destination_region_name').val();
        destinationObject.country_name = $('#destination_country_name').val();
        destinationObject.lat = $('#destination_lat').val();
        destinationObject.lng = $('#destination_lng').val();

        var departureDateObject = new Object();
        departureDateObject.departure_date = $('#departure_date').val();

        var updateLink = $('update_trips');

        $('.loading').css("display", "block");
        $.ajax({
            type: "GET",
            url: updateLink.href, // toma la url dinamicamente de un link_to no visible en index.html.erb
            dataType: 'script', // sin esto no responde al index.js.erb
            data: {
                origin: JSON.stringify(originObject),
                destination: JSON.stringify(destinationObject),
                departure_date: JSON.stringify(departureDateObject)
            },
            success: function() {
                console.log("Se filtró exitosamente");
            },
            error: function() {
                console.log("Hubo un error con el filtrado");
            },
            complete: function () {
                $('.loading').css("display", "none");
            }
        });
    }

    // resetear todos los filtros
    $('#btn-reset-filters').click(function () {
        clearOrigin();
        clearDestination();
        clearDate();

        updateTripPublications();
    });

    // limpiar filtros de origen y destino
    $('#clear-origin').click(function () {
        clearOrigin();
        updateTripPublications();
    });
    $('#clear-dest').click(function () {
        clearDestination();
        updateTripPublications();
    });
    $('#clear-date').click(function () {
        clearDate();
        updateTripPublications();
    });

    // filtrar por origen o destino
    $('#go-origin').click(function () {
        updateTripPublications();
    });
    $('#go-dest').click(function () {
        updateTripPublications();
    });
    $('#go-date').click(function () {
        updateTripPublications();
    });

    function clearOrigin(){
        $('#origin_description').val('');
        $('#origin_city_name').val('');
        $('#origin_region_name').val('');
        $('#origin_country_name').val('');
        $('#origin_lat').val('');
        $('#origin_lng').val('');
    }

    function clearDestination(){
        $('#destination_description').val('');
        $('#destination_city_name').val('');
        $('#destination_region_name').val('');
        $('#destination_country_name').val('');
        $('#destination_lat').val('');
        $('#destination_lng').val('');
    }

    function clearDate(){
        $('#departure_date').val('');
    }
});