BestInPlaceEditor.defaults.purrErrorContainer = "<span class='bip-flash-error'></span>";
BestInPlaceEditor.defaults.purrSuccessContainer = "<span class='bip-flash-success'></span>";

//edited this binding to stop showing 'Error Object object'
jQuery(document).on('best_in_place:error', function (event, request, error) {
    'use strict';
    // Display all error messages from server side validation
    jQuery.each(jQuery.parseJSON(request.responseText), function (index, value) {
        if (typeof value === "object") {value = index + " " + value.toString(); }
        var container = jQuery(BestInPlaceEditor.defaults.purrErrorContainer).html(value);
        container.purr();
    });
});

//added this binding for success messages:
jQuery(document).on('best_in_place:success', function (event, request, error) {
    'use strict';
    console.log(request);
    jQuery.each(jQuery.parseJSON(request), function (index, value) {
        if (typeof value === "object") {value = index + " " + value.toString(); }
        var container = jQuery(BestInPlaceEditor.defaults.purrErrorContainer).html(value);
        container.purr();
    });
});