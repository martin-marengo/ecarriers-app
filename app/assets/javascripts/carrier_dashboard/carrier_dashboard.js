//Hide loading screen if user click on 'Cancel' when is asked if he want to delete the Bid
$(document).on('confirm:complete', function (e, answer) {
    if (answer == false) {
        $('.loading').css("display", "none");
    }
});