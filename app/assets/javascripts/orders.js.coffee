$ ->
  $('#order_customer_id').on 'click', (e) ->

    url = '/orders/' + $(this).val() + '/get_drop_down_printers'
    $.get url, (data) -> 
      $('#order_printers').html(data)
      $('#order_printers').removeAttr('disabled')

$(document).on('turbolinks:load', ready)