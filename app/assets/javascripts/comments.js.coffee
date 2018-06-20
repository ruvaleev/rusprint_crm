# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.comment-answer-link').click (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId');
    $('#comment-answer-' + answer_id).fadeIn();

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'follow', question_id: gon.question.id
    ,

    received: (data) ->
      comment = JSON.parse(data)
      
      unless @userIsCurrentUser(comment.user_id)
        $('#comments_for_answer_' + comment.commentable_id).append(JST['comment'](
          comment: comment
        )) 

    userIsCurrentUser: (user_id) ->
      user_id is gon.current_user.id    
  })

$(document).on('turbolinks:load', ready)