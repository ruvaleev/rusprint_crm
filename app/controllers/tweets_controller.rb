class TweetsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_user, except: :show

  def create
    @tweet = @user.tweet.create(body: params[:body])
  end

  def show
    @tweets = Tweet.all
  end

  def update
    @tweet = Tweet.find(params[:id]).update(body: params[:body])
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

end