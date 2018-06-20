ready = ->

  $('.answers, .questions, #best').bind 'ajax:success', '.rating', (e) ->
    vote_id = e.detail[0].vote.object_id
    rating = e.detail[0].rating
    $("#tr#{vote_id} .rating").hide()
    $("#tr#{vote_id} .rating .point").html(rating)
    $("#tr#{vote_id} .rating").fadeIn()
  $('.answers, .questions, #best').on 'click', '.plus-minus', (e) ->
    $(this).toggleClass('disactive')
      

$(document).on('turbolinks:load', ready)