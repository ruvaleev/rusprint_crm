# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    id = $(this).data('id');
    $('#tr' + id).hide();
    $('#edit-question-' + id).fadeIn();

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      question = JSON.parse(data)
      $('.questions').append(JST['question'](
        question: question
        current_user: gon.current_user
      ))
  })

$(document).on('turbolinks:load', ready)