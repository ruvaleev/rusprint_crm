ready = ->
  App.cable.subscriptions.create('MessagesChannel', {
    connected: ->
      @perform 'follow', receiver_id: gon.receiver.id
      console.log 'connected'
    ,

    received: (data) ->
      console.log data
      message = JSON.parse(data.message)
      sender = JSON.parse(data.sender)
      console.log message
      $('#talk-' + message.sender_id).append(JST['message'](
          message: message
          sender: sender
        )) 
    
  })
$(document).on('turbolinks:load', ready)