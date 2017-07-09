$(function() {
    // inicializacion y on change de los input de geocomplete
    $(".geo-input")
        .geocomplete()
        .bind("geocode:result", function (event, result) {

            if(result != null && result.address_components != null) {

                if (result.address_components != null) {
                    for (var i = 0; i < result.address_components.length; i++) {
                        if (result.address_components[i].types[0] != null) {
                            var locality;
                            var region;
                            var country;

                            if (result.address_components[i].types[0] === "locality") {
                                locality = result.address_components[i].long_name;
                            }
                            if (result.address_components[i].types[0] === "administrative_area_level_1") {
                                region = result.address_components[i].long_name;
                            }
                            if (result.address_components[i].types[0] === "country") {
                                country = result.address_components[i].long_name;
                            }

                            if($("#city_name").length) {
                                // city_name exists on page, therefore the others too.
                                $("#city_name").val(locality);
                                $("#region_name").val(region);
                                $("#country_name").val(country);
                            }
                            if($(this).attr("id") === 'origin_description'){
                                $("#origin_city_name").val(locality);
                                $("#origin_region_name").val(region);
                                $("#origin_country_name").val(country);
                            }
                            if($(this).attr("id") === 'destination_description'){
                                $("#destination_city_name").val(locality);
                                $("#destination_region_name").val(region);
                                $("#destination_country_name").val(country);
                            }
                        }
                    }
                }
                if(result.geometry && result.geometry.location) {
                    var lat = result.geometry.location.lat();
                    var lng = result.geometry.location.lng();

                    if($('#lat').length){
                        $("#lat").val(lat);
                        $("#lng").val(lng);
                    }
                    if($(this).attr("id") === 'origin_description'){
                        $("#origin_lat").val(lat);
                        $("#origin_lng").val(lng);
                    }
                    if($(this).attr("id") === 'destination_description'){
                        $("#destination_lat").val(lat);
                        $("#destination_lng").val(lng);
                    }
                }
            }
        });

    // on change de los input que suben imagenes, para mostrar la preview (en editar datos de un transportista por ej)
    $(".img-upload-preview").change(function() {
        var preview = $(".preview");
        var input = $(event.currentTarget);
        var file = input[0].files[0];
        if (file == null) {
            preview
                .attr("src",'/assets/missing_thumb.jpg')
                .width(75)
                .height(75);
        } else {
            var reader = new FileReader();
            reader.onload = function (e) {
                var image_base64 = e.target.result;
                preview
                    .attr("src", image_base64)
                    .width(75)
                    .height(75);
            };
            reader.readAsDataURL(file);
        }
    });

    /**
     * PANTALLA: LISTA DE PUBLICACIONES MOSTRADA A UN TRANSPORTISTA
     */

    // cambiar iconos + y - en los items desplegables de los filtros de publicaciones
    $('.collapsible-panel').on('hide.bs.collapse', function (e){
        $(this).prev('a').find("i.collapse-indicator").removeClass("fa-minus-square-o").addClass("fa-plus-square-o");
        e.stopPropagation();
    });
    $('.collapsible-panel').on('show.bs.collapse', function (e) {
        $(this).prev('a').find("i.collapse-indicator").removeClass("fa-plus-square-o").addClass("fa-minus-square-o");
        e.stopPropagation();
    });

    // check or uncheck child checkbox when parent is checked or unchecked
    $('input.parent-category-check:checkbox').change(function(event) {
        var parentId = event.target.id;
        var isChecked= $(this).is(':checked');
        if (isChecked) {
            $('input.child-category-check.'+parentId+':checkbox').prop('checked', true);
        } else {
            $('input.child-category-check.'+parentId+':checkbox').prop('checked', false);
        }
        // se evita la propagacion del evento para que no se generen multiples llamadas AJAX innecesarias
        event.stopPropagation();
        // se filtra con los nuevos parametros
        updatePublications();
    });

    // check or uncheck parent checkbox when child is checked
    $('input.child-category-check:checkbox').change(function(event) {
        var isChecked= $(this).is(':checked');
        var listOfClases = $(this).attr("class").toString().split(' ');
        var parentId = "";
        // itero la lista de clases del check actual y busco la que correspondo con el id del checkbox padre
        for(var i = 0; i < listOfClases.length; i++){
            var className = listOfClases[i];
            if(className !== 'child-category-check'){
                parentId = className;
            }
        }
        if (isChecked) {
            $('input:checkbox.parent-category-check#'+parentId).prop('checked', true);
        }else{
            var someoneChecked = false;
            $('input:checkbox.'+parentId).each(function () {
                if(this.checked){
                    someoneChecked = true;
                }
            });
            if(!someoneChecked){
                $('input:checkbox.parent-category-check#'+parentId).prop('checked', false);
            }
        }
        // se evita la propagacion del evento para que no se generen multiples llamadas AJAX innecesarias
        event.stopPropagation();
        // se filtra con los nuevos parametros
        updatePublications();
    });

    // AJAX call, se va a llamar cada vez que se actualiza algun filtro de cualquier tipo
    // De esta manera, la URL de busqueda nunca se va a ver en el navegador, por lo que tampoco se va a poder
    // favoritear. No tiene importancia, son filtros simples los de esta version.
    function updatePublications(){
        var categoriesIds = new Array();
        $('input.child-category-check:checkbox').each(function () {
            if($(this).is(':checked')){
                categoriesIds.push(this.id);
            }
        });
        // Se busca si hay categorias padres tildadas sólo por la categoria "Otro", que es categoria padre y
        // no tiene categorías hijas. En el caso de las otras categorias padres, no influye en nada que se envíen.
        // A excepcion de "Otros", las categorías padres nunca pueden estar referenciadas desde las publicaciones,
        // por eso no va a influir que se agreguen a los filtros.
        $('input.parent-category-check:checkbox').each(function () {
            if($(this).is(':checked')){
                categoriesIds.push(this.id);
            }
        });

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

        var updateLink = $('update_publication');

        $('.loading').css("display", "block");
        $.ajax({
            type: "GET",
            url: updateLink.href, // toma la url dinamicamente de un link_to no visible en index.html.erb
            dataType: 'script', // sin esto no responde al index.js.erb
            data: {
                categories: JSON.stringify(categoriesIds),
                origin: JSON.stringify(originObject),
                destination: JSON.stringify(destinationObject)
            },
            success: function() {
            },
            error: function() {
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
        clearCategories();
        updatePublications();
    });

    // limpiar filtros de origen y destino
    $('#clear-origin').click(function () {
        clearOrigin();
        updatePublications();
    });
    $('#clear-dest').click(function () {
        clearDestination();
        updatePublications();
    });

    // filtrar por origen o destino
    $('#go-origin').click(function () {
        updatePublications();
    });
    $('#go-dest').click(function () {
        updatePublications();
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

    function clearCategories(){
        $('input.parent-category-check:checkbox').each(function () {
            $(this).prop('checked', false);
            event.stopPropagation();
        });
        $('input.child-category-check:checkbox').each(function () {
            $(this).prop('checked', false);
            event.stopPropagation();
        });
    }

    /**
     * FIN PANTALLA LISTA DE PUBLICACIONES MOSTRADA A UN TRANSPORTISTA
     * */

    // Impide que los botones queden en foco luego de ser presionados
    $(".btn").mouseup(function(){
        $(this).blur();
    });

    /**
     * PANTALLA MOSTRAR PUBLICACION DE ENVIO DESDE UN TRANSPORTISTA
     * */

    // Con gmaps.js se inicializa el mapa de origen, destino y ruta
    if($("#shipment_road_map").length) {
        var origin_lat = $('#origin_lat').val();
        var origin_lng = $('#origin_lng').val();
        var destination_lat = $('#destination_lat').val();
        var destination_lng = $('#destination_lng').val();
        var origin_text = $('#origin_text').val();
        var destination_text = $('#destination_text').val();

        if(origin_lat !== '' && origin_lng !== '' && destination_lat !== '' && destination_lng !== '') {

            // Se inicializa el mapa
            var shipment_road_map = new GMaps({
                el: '#shipment_road_map',
                lat: origin_lat,
                lng: origin_lng
            });

            if(origin_lat !== destination_lat || origin_lng !== destination_lng){
                // Se agregan los marcadores de origen y destino.
                shipment_road_map.addMarker({
                    lat: origin_lat,
                    lng: origin_lng,
                    title: 'Origen',
                    infoWindow: {
                        content: '<p>Origen: ' + origin_text + '</p>'
                    },
                    click: function (e) {
                    }
                });

                shipment_road_map.addMarker({
                    lat: destination_lat,
                    lng: destination_lng,
                    title: 'Destino',
                    infoWindow: {
                        content: '<p>Destino: ' + destination_text + '</p>'
                    },
                    click: function (e) {
                    }
                });

                // Se ajusta la ubicación y el zoom del mapa para que se vean los dos marcadores.
                shipment_road_map.fitLatLngBounds([
                    new google.maps.LatLng(origin_lat, origin_lng),
                    new google.maps.LatLng(destination_lat, destination_lng)
                ]);
                
                draw_road_map(shipment_road_map, origin_lat, origin_lng, destination_lat, destination_lng, origin_text, destination_text);
            }else {
                draw_point_in_map(shipment_road_map, origin_lat, origin_lng, '');
            }
        }else {
            initDefaultMap();
        }
    }

    if($("#report_location_map").length) {
        var origin_lat = $('#origin_lat').val();
        var origin_lng = $('#origin_lng').val();
        var destination_lat = $('#destination_lat').val();
        var destination_lng = $('#destination_lng').val();
        var current_location_lat = $('#current_location_lat').val();
        var current_location_lng = $('#current_location_lng').val();

        // Se inicializa el mapa
        var shipment_road_map = new GMaps({
            el: '#report_location_map',
            lat: current_location_lat,
            lng: current_location_lng
        });
        
        // Ajustar a la ubicación de la posición actual
        shipment_road_map.fitLatLngBounds([
            new google.maps.LatLng(origin_lat, origin_lng),
            new google.maps.LatLng(destination_lat, destination_lng),
            new google.maps.LatLng(current_location_lat, current_location_lng)
        ]);
        
        draw_road_map(shipment_road_map, origin_lat, origin_lng, destination_lat, destination_lng);
        
        draw_point_in_map(shipment_road_map, current_location_lat, current_location_lng, 'Ubicación actual');
    }
    
    function draw_road_map(shipment_road_map, origin_lat, origin_lng, destination_lat, destination_lng) {
        // Se dibuja la ruta para conducir entre los dos puntos.
        shipment_road_map.drawRoute({
            origin: [origin_lat, origin_lng],
            destination: [destination_lat, destination_lng],
            travelMode: 'driving',
            strokeColor: '#0BA6F0',
            strokeOpacity: 0.9,
            strokeWeight: 6
        });
    }
    
    function draw_point_in_map(shipment_road_map, lat, lng, text) {
        // Si las coordenadas con iguales, se agrega un solo marcador indicando que es origen y destino.
        shipment_road_map.addMarker({
            lat: lat,
            lng: lng,
            title: '',
            infoWindow: {
                content: text
            },
            click: function (e) {
            }
        });
    }

    // En caso de faltar alguna coordenada (de origen o destino) se muestra la localización actual del usuario.
    // Si este no habilita la geolocalización o el navegador no lo soporta, se muestra una coordenada por defecto.
    function initDefaultMap() {
        // Se usan como coordenadas por defecto el centro geográfico de Argentina (a ojo: -34.913317, -64.760654)
        var map = new google.maps.Map(document.getElementById('shipment_road_map'), {
            center: {lat: -34.913317, lng: -64.760654},
            zoom: 3
        });
        var infoWindow = new google.maps.InfoWindow({map: map});

        // Try HTML5 geolocation.
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var pos = {
                    lat: position.coords.latitude,
                    lng: position.coords.longitude
                };

                infoWindow.setPosition(pos);
                infoWindow.setContent('No se cuenta con la localización de origen y destino de este viaje.');
                map.setCenter(pos);
            }, function() {
                handleLocationError(true, infoWindow, map.getCenter());
            });
        } else {
            // Browser doesn't support Geolocation
            handleLocationError(false, infoWindow, map.getCenter());
        }
    }

    function handleLocationError(browserHasGeolocation, infoWindow, pos) {
        infoWindow.setPosition(pos);
        infoWindow.setContent('No se cuenta con la localización de origen y destino de este viaje.');
        // Esto es en caso de que se quiera mostrar otro tipo de mensaje de error.
        /*infoWindow.setContent(browserHasGeolocation ?
         'Error: El servicio de geolocalización falló.' :
         'Error: Su navegador no soporta geolocalización.');*/
    }

    //Evento click de los botones del modal de creación y edición de bids.
    $('body').on('click', '#new-bid-modal .slow-job-button', function(e){
        $('.loading').css("display", "block");
        var target = e.target;
        if(target.id == 'submit-bid-form'){
            $('bid-form').submit();
            e.stopPropagation();
        }
    });

    $('.mark-items-as-delivered-button').click(function () {
        $('.loading').css("display", "block");
    });

    /**
     * FIN PANTALLA MOSTRAR PUBLICACION DE ENVIO DESDE UN TRANSPORTISTA
     * */

    /**
     * MODAL COMENTARIOS
     * */

    $('body').on('click', '#messages-modal .slow-job-button', function(e){
        if($('#body-input').val()) {

            $('.loading').css("display", "block");
            var target = e.target;

            if (target.id == 'submit-conversation') {
                $('conversation-form').submit();
                e.stopPropagation();
            }

            if (target.id == 'submit-message') {
                $('message-form').submit();
                e.stopPropagation();
            }
        }else{
            $(this).blur();
            e.preventDefault();
            e.stopPropagation();
        }
    });

    /**
     * FIN MODAL COMENTARIOS
     */

    if ($(".datepicker").length) {
        //Set locale
        $.datepicker.regional['es'] = {
            closeText: 'Cerrar',
            prevText: '<Ant',
            nextText: 'Sig>',
            currentText: 'Hoy',
            monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
            monthNamesShort: ['Ene','Feb','Mar','Abr', 'May','Jun','Jul','Ago','Sep', 'Oct','Nov','Dic'],
            dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
            dayNamesShort: ['Dom','Lun','Mar','Mié','Juv','Vie','Sáb'],
            dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','Sá'],
            weekHeader: 'Sm',
            dateFormat: 'dd/mm/yy',
            firstDay: 1,
            isRTL: false,
            showMonthAfterYear: false,
            yearSuffix: ''
        };
        $.datepicker.setDefaults($.datepicker.regional['es']);

        $(".datepicker-with-limit").datepicker({
                showButtonPanel: true,
                showOtherMonths: true,
                selectOtherMonths: true,
                minDate: 0
            }
        );

        $(".datepicker-without-limit").datepicker({
                showButtonPanel: true,
                showOtherMonths: true,
                selectOtherMonths: true
            }
        );
    }

});