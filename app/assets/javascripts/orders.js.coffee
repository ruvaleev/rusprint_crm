$ ->
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
    model = $(this).data('model')
    qnt = $("#qnt_cartridges_#{id}").val() || 1
    goal_elem = "#order_cartridges"
    fillField(model, qnt, goal_elem)
    $("#qnt_cartridges_#{id}").val('')
    $('.cancel_cartridges').fadeIn()

  $('.customers_printers_list').on 'keypress', '.qnt_input', (e) ->
    if (e.which == 13)
      id = $(this).data('id')
      model = $(this).data('model')
      qnt = $("#qnt_cartridges_#{id}").val() || 1
      goal_elem = "#order_cartridges"
      fillField(model, qnt, goal_elem)
      $(this).val('')
      $('.cancel_cartridges').fadeIn()
      return false
  
  $('.customers_printers_list').on 'click', '.minus_possible_cartridge', (e) ->
    id = $(this).data('id')
    model = $(this).data('model')
    qnt = $("#qnt_cartridges_#{id}").val() || 1
    goal_elem = "#order_cartridges"
    searched_string = "#{model}"
    changeQuantity(goal_elem, searched_string, qnt, '-')
    $("#qnt_cartridges_#{id}").val('')
    if $(goal_elem).val() == ''
      $('.cancel_cartridges').fadeOut()

  $('.cancel_printers').on 'click', (e) ->
    $('#order_printers').val('')
    $(this).fadeOut()

  $('.cancel_cartridges').on 'click', (e) ->
    $('#order_cartridges').val('')
    $(this).fadeOut()

  $(".customers_printers_list").on("ajax:success", "#new_printer_form", (event) ->
    [data, status, xhr] = event.detail
    $("#new_printer_form").append xhr.responseText
  ).on "ajax:error", (event) ->
    $("#new_printer_form").append "<p>ERROR</p>"



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
    cusomter_id = $('#order_customer_id option:selected').val()
    $('.add_to_customer').html("Добавить принтер клиенту " + customer)
    $('.new_printers_table #printer_company').val(customer_id)
$(document).on('turbolinks:load', ready)