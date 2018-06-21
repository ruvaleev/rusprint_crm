class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def update
    current_user.update(name: params[:user][:name], second_name: params[:user][:second_name], email: params[:user][:email])
    redirect_to root_path
  end

end