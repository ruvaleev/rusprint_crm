class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, except: :update

  def show
  end

  def update
    current_user.update(name: params[:user][:name], second_name: params[:user][:second_name], email: params[:user][:email])
    redirect_to root_path
  end

  def make_friend
    current_user.make_friend(@user)
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end