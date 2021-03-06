# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
# vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https:#github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#
#= require jquery3
#= require rails-ujs
#= require action_cable
#= require turbolinks
#= require cocoon
#= require skim
#= require bootstrap-datepicker
#= require bootstrap-datepicker/core
#= require select2
#= require select2-full
#= require best_in_place
#= require jquery-ui
#= require best_in_place.jquery-ui
#= require jquery.purr
#= require bip.purr
#= require_tree .

#App = App || {};
#App.cable = ActionCable.createConsumer();

$(document).ready ->
  
  $('.best_in_place').best_in_place()

  # Для мобильной версии это неудобно, отключим это
  # $.each $('.fixed-menu'), (index, element) ->
  #   $nav = $(element)
  #   $window = $(window)
  #   $h = $nav.offset().top
  #   $window.scroll ->
  #     if $window.scrollTop() > $h
  #       $nav.addClass('fixed')
  #     else
  #       $nav.removeClass('fixed')

# Функия, чтобы показывать корзину при создании заказа
  $('#new_order_modal').on 'shown.bs.modal', (e) ->
    if $('.shopping_cart_for_new_order').is(':hidden')
      $('#open_shopping_cart_index').click()
  
  $("#new_order_modal").on 'hidden.bs.modal', () ->
    $('#open_shopping_cart_index').fadeIn()
    $('.shopping_cart_for_new_order').hide()

  $('#open_shopping_cart_index').on 'click', (e) ->
    $('.shopping_cart_for_new_order').fadeIn()
    $(this).hide()

  $('#close_shopping_cart_index').on 'click', (e) ->
    $('#open_shopping_cart_index').fadeIn()
    $('.shopping_cart_for_new_order').hide()
    
# Реагируем на движение мышки над окном (прозрачнее, непрозрачнее делаем)
  $('.shopping_cart_for_new_order').on 'mousemove', (e) ->
    $(this).css('opacity', 1)
    $(this).css('overflow-y', 'auto')

  $('.shopping_cart_for_new_order').on 'mouseleave', (e) ->
    if $(this).is(':visible')
      $(this).fadeTo('fast', 0.5)

class Application
  constructor: (@$container) ->

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
