$(function () {
    $("#pickup-condition").change(function(){
        var optionSelected = $("#pickup-condition").val();

        if (optionSelected == 'between') {
            $("#pickup-one-date").hide();
            $("#pickup-two-dates").show();
        } else {
            $("#pickup-one-date").show();
            $("#pickup-two-dates").hide();
        }
    });

    $("#delivery-condition").change(function(){
        var optionSelected = $("#delivery-condition").val();

        if (optionSelected == 'between') {
            $("#delivery-one-date").hide();
            $("#delivery-two-dates").show();
        } else {
            $("#delivery-one-date").show();
            $("#delivery-two-dates").hide();
        }
    });
});