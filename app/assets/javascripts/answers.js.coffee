# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('#edit-answer-' + answer_id).fadeIn();

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      @perform 'follow', question_id: gon.question.id
    ,

    received: (data) ->
      answer = JSON.parse(data.answer)
      attachments = JSON.parse(data.attachments)
      unless @userIsCurrentUser(answer.user_id)
        $('.answers').append(JST['answer'](
          answer: answer,
          current_user: gon.current_user,
          question: gon.question,
          attachments: attachments
          )) 

    userIsCurrentUser: (user_id) ->
      user_id is gon.current_user.id    
  })

$(document).on('turbolinks:load', ready)