ready = ->
  App.cable.subscriptions.create('TweetsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      console.log data
      tweet = JSON.parse(data.tweet)
      user = JSON.parse(data.user)
      unless @userIsCurrentUser(tweet.user_id)
        $('.tweets').append(JST['tweet'](
            tweet: tweet
            user: user
          )) 
    userIsCurrentUser: (user_id) ->
      user_id is gon.current_user.id
    
  })
$(document).on('turbolinks:load', ready)