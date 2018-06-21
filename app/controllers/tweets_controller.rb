class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_tweet, except: :create
  after_action :publish_tweets

  def create
    @tweet = current_user.tweets.create(body: params[:tweet][:body])
  end

 
  def update
    @tweet.update(body: params[:tweet][:body])
  end

  def edit
  end

  private

  def find_tweet
    @tweet = Tweet.find(params[:id])
  end

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