ready = ->
  App.cable.subscriptions.create('MessagesChannel', {
    connected: ->
      @perform 'follow', receiver_id: gon.receiver.id
      console.log 'connected'
    ,

    received: (data) ->
      console.log data
      message = JSON.parse(data.message)
      receiver = JSON.parse(data.receiver)
      console.log message
      $('#talk-' + message.sender_id).append(JST['talk'](
          message: message
          receiver: receiver
        )) 
    
  })
$(document).on('turbolinks:load', ready)