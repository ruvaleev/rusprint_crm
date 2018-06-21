class TweetsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_tweets

  def create
    @tweet = current_user.tweets.create(body: params[:tweet][:body])
  end

 
  def update
    @tweet = Tweet.find(params[:id]).update(body: params[:body])
  end

  private

  def publish_tweets
    return if @tweet.errors.any?
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, { "HTTP_HOST"=>"localhost:3000",  
                                            "HTTPS"=>"off",   
                                            "REQUEST_METHOD"=>"GET",   
                                            "SCRIPT_NAME"=>"",   
                                            "warden" => warden })
    ActionCable.server.broadcast(
      "tweets", {
        tweet: @tweet.to_json,
        user: @tweet.user.to_json
      }
    )
  end

end