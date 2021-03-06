$ ->

# Функция, чтобы по клику на модальное окно скролл был по модальному окну, а не по фону
  $('.modal-body, .modal-header').on 'click', (e) ->
    $("body").addClass("modal-open")

# Функция, чтобы по клику по фону, оставшемуся после закрытия модального окна, он исчезал
  $('body').on 'click', '.modal-backdrop', (e) ->
    $(this).fadeOut()

# Подгружаем нового клиента в заказ 
  $('.table-orders').on 'change', "[name='update_customer']", (e) ->
    order_id = $(this).data('id')
    customer_id = $(this).val()
    $.ajax
      url: '/orders/' + order_id + '/update_customer',
      type: 'PUT',
      beforeSend: (xhr) -> 
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      data: {
        order: {
          customer_id: customer_id
        }
      }
      success: (response) -> 
        console.log 'обновили клиента в заказе'

  $('#new_client_tab, #choose_client').on 'click', (e) ->
    value = $(this).attr('value_for_new_client_flag')
    $('#new_client_flag').val(value)

  $('.order_customer_select').select2({
    width: '300px'
  })

  $('#order_customer_id').on 'change', (e) ->
    url = '/companies/' + $(this).val()
    $.get url, (data) ->
    chooseAnotherCustomer()

  $('.customers_printers_list').on 'click', '.plus_printer', (e) ->
    model = $(this).data('model')
    goal_elem = "#order_printers"
    fillField(model, 1, goal_elem)
    $('.cancel_printers').fadeIn()

# Нажатие на минус, вычитываем картриджи из заказа
  $('.customer').on 'click', '.minus_possible_cartridge', (e) ->
    id = $(this).data('id')
    shopping_cart_id = $(this).data('shopping-cart-id')
    qnt = $("#qnt_field_#{id}_for_#{shopping_cart_id}").val() || 1
    minusCartridge(id, qnt, 'CartridgeServiceGuide')
    $("#qnt_field_#{id}_for_#{shopping_cart_id}").val('')

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

# Выполняем поиск внутри формы заказа
  $('#new_printer_model_search').on 'submit', (e) ->
    e.preventDefault()
    model_like = $("#new_printer_model_search #printer_model_search_model_like").val()
    $.ajax
      url: '/get_models',
      type: 'GET',
      beforeSend: (xhr) -> 
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      data: {
        printer_model_search: { model_like: model_like }
      }
      success: (response) -> 
        console.log 'запрос прошел успешно'

# Создаем принтер внутри формы заказа
  $('#new_printer_service_guide_for_order_').on 'submit', (e) ->
    e.preventDefault()
    model = $("#new_printer_service_guide_for_order_ #printer_service_guide_model").val()
    fuser_life_count = $('#new_printer_service_guide_for_order_ #printer_service_guide_fuser_life_count').val()
    sheet_size = $('#new_printer_service_guide_for_order_ #printer_service_guide_sheet_size').val()
    color = $('#new_printer_service_guide_for_order_ #printer_service_guide_color').is(':checked')
    type_of_system = $('#new_printer_service_guide_for_order_ #type_of_system').val()
    vendor = $('#new_printer_service_guide_for_order_ #printer_service_guide_vendor').val()
    order_id = $('#new_printer_service_guide_for_order_ #order_id').val()
    company_id = $('#new_printer_service_guide_for_order_ #company_id').val()

    $.ajax
      url: '/printer_service_guides',
      type: 'POST',
      beforeSend: (xhr) -> 
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      data: {
        printer_service_guide: { 
          model: model,
          fuser_life_count: fuser_life_count,
          sheet_size: sheet_size,
          color: color,
          type_of_system: type_of_system,
          vendor: vendor
        },
        order_id: order_id,
        company_id: company_id
      }
      success: (response) -> 
        console.log 'запрос прошел успешно'

# Добавляем найденный принтер клиенту
  $('.new_printers_for_new_order, .new_printer_for_').on 'submit', '#new_printer', (e) ->
    e.preventDefault()
    printer_service_guide_id = $(this).data('printer-service-guide-id')
    additional_data = $(this).find('#printer_additional_data').val()
    serial_number = $(this).find('#printer_serial_number').val()
    fuser_life_count = $(this).find('#printer_fuser_life_count').val()
    company_id = $('#order_customer_id option:selected').val()
    order_id = $(this).data('order-id')
    $.ajax
      url: '/printers',
      type: 'POST',
      beforeSend: (xhr) -> 
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      data: {
        printer: {
          additional_data: additional_data,
          serial_number: serial_number,
          fuser_life_count: fuser_life_count,
          company_id: company_id,
          order_id: order_id,
          printer_service_guide_id: printer_service_guide_id
        }
      }
      success: (response) -> 
        console.log 'добавили'

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

# Нужно, чтобы когда меняешь клиента в новом заказе, изменялись необходимые данные в формах добавления нового принтера
  chooseAnotherCustomer = () ->
    customer = $('#order_customer_id option:selected').text()
    customer_id = $('#order_customer_id option:selected').val()
    $('.add_to_customer').html("Добавить принтер клиенту " + customer)
    $('#new_order_form #printer_company_id').val(customer_id)

  #App.cable.subscriptions.create('OrdersChannel', {
  #  connected: ->
  #    @perform 'follow', master_id: gon.order.master_id
  #  ,
#
  #  received: (data) ->
  #    order = JSON.parse(data)
      
  #    unless @userIsCurrentUser(order.master_id)
  #      $('#row_head').after(JST['order'](
  #        order: order
  #      )) 
#
  #  userIsCurrentUser: (user_id) ->
  #    user_id is gon.current_user.id    
 # })







