$ ->
  
  $('#new_client_tab, #choose_client').on 'click', (e) ->
    value = $(this).attr('value_for_new_client_flag')
    $('#new_client_flag').val(value)

  $('.order_customer_select').select2({
    width: '300px'
  })

  $('#order_customer_id').on 'change', (e) ->
    url = '/orders/' + $(this).val() + '/get_printers'
    $.get url, (data) ->
    changeCustomer()

  $('#vendor').on 'change', (e) ->
    url = '/orders/' + $(this).val() + '/get_models'
    $.get url, (data) ->

  $('.customers_printers_list').on 'click', '.plus_printer', (e) ->
    model = $(this).data('model')
    goal_elem = "#order_printers"
    fillField(model, 1, goal_elem)
    $('.cancel_printers').fadeIn()

  $('.customers_printers_list').on 'click', '.plus_possible_cartridge', (e) ->
    id = $(this).data('id')
    qnt = $("#qnt_cartridges_#{id}").val() || 1
    plusCartridge(id, qnt)
    $("#qnt_cartridges_#{id}").val('')

  $('.customers_printers_list').on 'keypress', '.qnt_input', (e) ->
    if (e.which == 13)
      id = $(this).data('id')
      qnt = $("#qnt_cartridges_#{id}").val() || 1
      plusCartridge(id, qnt)
      $(this).val('')
      return false
  
  $('.customers_printers_list').on 'click', '.minus_possible_cartridge', (e) ->
    id = $(this).data('id')
    qnt = $("#qnt_cartridges_#{id}").val() || 1
    minusCartridge(id, qnt, 'CartridgeServiceGuide')

  $('.cancel_printers').on 'click', (e) ->
    $('#order_printers').val('')

  $('.cancel_cartridges').on 'click', (e) ->
    $.ajax
      url: '/shopping_carts/0/clear',
      type: 'POST',
      beforeSend: (xhr) -> 
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      success: (response) -> 
        console.log 'очистили корзину'
    $('#order_cartridges').val('')
    $('#order_revenue').val('')

  $(".customers_printers_list").on("ajax:success", "#new_printer_form", (event) ->
    [data, status, xhr] = event.detail
    $("#new_printer_form").append xhr.responseText
  ).on "ajax:error", (event) ->
    $("#new_printer_form").append "<p>ERROR</p>"

  $('#add_other_order_item').on 'click', (e) ->
    e.preventDefault()
    body = $('#other_order_item_body').val()
    price = $('#other_order_item_price').val()
    $.ajax
      url: '/shopping_carts',
      type: 'POST',
      beforeSend: (xhr) -> 
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      data: { 
        body: body, 
        quantity: 1,
        price: price 
      }
      success: (response) -> 
        console.log 'добавили'

  $('.other_order_item').on 'click', '.cancel_other_items', (e) ->
    id = $(this).data('id')
    minusCartridge(id, 1, 'OtherOrderItem')



  fillField = (model, qnt, goal_elem) ->
    searched_string = "#{model}"
    value_of_field = $(goal_elem).val()

    if value_of_field == ''
      $(goal_elem).val("#{model} - #{qnt} шт")
    else
      search_result = value_of_field.match(searched_string)
      if search_result == null
        $(goal_elem).val("#{value_of_field}, #{model} - #{qnt} шт")
      else
        changeQuantity(goal_elem, searched_string, qnt, '+')

  changeQuantity = (goal_elem, searched_string, qnt, method) ->
    value_of_field = $(goal_elem).val()
    goal_index = value_of_field.indexOf(searched_string) + searched_string.length
    goal = value_of_field.slice(goal_index, goal_index + 6)
    old_qnt = goal.match(/\d+/)[0]
    if method == '+'
      new_qnt = Number(old_qnt) + Number(qnt)
    else
      new_qnt = Number(old_qnt) - Number(qnt)
    if new_qnt > 0
      new_value_of_field = value_of_field.replace(searched_string.concat(" - #{old_qnt}"), searched_string.concat(" - #{new_qnt}"))
    else
      new_value_of_field = value_of_field.replace(searched_string.concat(" - #{old_qnt} шт"), '')
    new_value_of_field = new_value_of_field.replace(', ,', ',')
    if new_value_of_field.slice(0,2) == ', '
      new_value_of_field = new_value_of_field.substr(2)
    if new_value_of_field.slice(-2) == ', '
      new_value_of_field = new_value_of_field.substr(0, new_value_of_field.length - 2)
    $(goal_elem).val(new_value_of_field)

  changeCustomer = () ->
    customer = $('#order_customer_id option:selected').text()
    customer_id = $('#order_customer_id option:selected').val()
    $('.add_to_customer').html("Добавить принтер клиенту " + customer)
    $('.company_id_input').val(customer_id)

  plusCartridge = (id, qnt) ->
    $.ajax
      url: '/shopping_carts',
      type: 'POST',
      beforeSend: (xhr) -> 
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      data: { 
        product_id:  id, 
        quantity: qnt,
        item_type: 'CartridgeServiceGuide' 
      }
      success: (response) -> 
        console.log 'добавили'

  minusCartridge = (id, qnt, item_type) ->
    $.ajax
      url: '/shopping_carts/0',
      type: 'DELETE',
      beforeSend: (xhr) -> 
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      data: { 
        item_type: item_type,
        product_id:  id,
        quantity: qnt 
      }
      success: (response) -> 
        console.log 'удалили картриджи'

$(document).on('turbolinks:load', ready)