$(document).on('turbolinks:load', function() {
    $(document).on('ajax:beforeSend', '.subscription-btn', function() {
        $('.main').find('.alert-danger').remove();
    }).on('ajax:success', '.subscription-btn', function() {
       console.log('success');
    }).on('ajax:error', '.subscription-btn', function(e, xhr) {
        $('.main').prepend(JST["templates/errors"](xhr.responseJSON));
    });
});
