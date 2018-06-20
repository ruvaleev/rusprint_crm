class UsersController < ApplicationController
  before_action :authenticate_user!

  def set_email
    @user = current_user
  end

  def update
    current_user.update(email: params[:user][:email])
    redirect_to root_path
  end

end