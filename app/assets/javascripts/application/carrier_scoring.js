$(function () {
    $(".quality-service-input").change(function(e){
        var value_selected = this.value;

        $("#quality-service-stars input[type=radio]").each(function(){
            if(this.value <= value_selected) {
                $('#quality-service-icon-' + this.value).css('background', 'gold');
            } else {
                $('#quality-service-icon-' + this.value).css('background', '');
            }
        });
    });

    $(".delivery-time-input").change(function(e){
        var value_selected = this.value;

        $("#delivery-time-stars input[type=radio]").each(function(){
            if(this.value <= value_selected) {
                $('#delivery-time-icon-' + this.value).css('background', 'gold');
            } else {
                $('#delivery-time-icon-' + this.value).css('background', '');
            }
        });
    });

    $('#not-recommended-input').change(function () {
        $('#thumbs-up-icon').removeAttr('style');
        $('#thumbs-down-icon').effect( "size", {
            to: { width: 36, height: 42 }
        }, 300);
    });

    $('#recommended-input').change(function () {
        $('#thumbs-down-icon').removeAttr('style');
        $('#thumbs-up-icon').effect( "size", {
            to: { width: 36, height: 42 }
        }, 300);
    });
});