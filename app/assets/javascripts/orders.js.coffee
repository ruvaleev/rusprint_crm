$ ->
  $('#order_customer_id').on 'click', (e) ->
    url = '/orders/' + $(this).val() + '/get_printers'
    $.get url, (data) ->

  $('.customers_printers_list').on 'click', '.plus_printer', (e) ->
    model = $(this).data('model')
    goal_elem = "#order_printers"
    fillField(model, 1, goal_elem)

  $('.customers_printers_list').on 'click', '.plus_possible_cartridge', (e) ->
    id = $(this).data('id')
    model = $(this).data('model')
    qnt = $("#qnt_cartridges_#{id}").val() || 1
    goal_elem = "#order_cartridges"
    fillField(model, qnt, goal_elem)
    $(this).val('')

  $('.customers_printers_list').on 'keypress', '.qnt_input', (e) ->
    if (e.which == 13)
      id = $(this).data('id')
      model = $(this).data('model')
      qnt = $("#qnt_cartridges_#{id}").val() || 1
      goal_elem = "#order_cartridges"
      fillField(model, qnt, goal_elem)
      $(this).val('')
      return false
  
  $('.customers_printers_list').on 'click', '.minus_possible_cartridge', (e) ->
    id = $(this).data('id')
    model = $(this).data('model')
    qnt = $("#qnt_cartridges_#{id}").val() || 1
    goal_elem = "#order_cartridges"
    searched_string = "#{model}"
    changeQuantity(goal_elem, searched_string, qnt, '-')

  fillField = (model, qnt, goal_elem) ->
    searched_string = "#{model}"
    value_of_field = $(goal_elem).val()

    if value_of_field == ''
      $(goal_elem).append("#{model} - #{qnt} шт")
    else
      search_result = value_of_field.match(searched_string)
      if search_result == null
        $(goal_elem).append(", #{model} - #{qnt} шт")
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
    $(goal_elem).html(new_value_of_field)

$(document).on('turbolinks:load', ready)