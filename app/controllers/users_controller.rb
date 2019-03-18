class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, except: :update
  load_and_authorize_resource
  def show; end

  def update
    if current_user.update(user_params)
      flash[:success] = 'Профиль обновлен'
      redirect_to root_path
    else
      flash[:error] = "Errors: #{current_user.errors.messages}"
      redirect_back fallback_location: root_path
    end
  end

  def make_friend
    current_user.make_friend(@user)
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :second_name, :email, :password, :password_confirmation)
  end
end
