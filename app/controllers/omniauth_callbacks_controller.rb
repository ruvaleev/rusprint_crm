class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :find_user
  skip_authorization_check

  def facebook
    sign_in_new_user('facebook') if @user.persisted?
  end

# Если понадобятся другие операторы, 
# то их можно будет добавить вот так
  
  # def vkontakte
  #   sign_in_new_user('vkontakte') if @user.persisted?
  # end

  # def twitter
  #   sign_in_new_user('twitter') if @user.persisted?
  # end

  private

  def find_user
    @user = User.find_for_oauth(request.env['omniauth.auth'])
  end

  def sign_in_new_user(provider)
    if @user.email.include?('temporary')
      sign_in @user
      redirect_to set_email_user_path(@user)
      set_flash_message(:notice, :recommend_change_email)
    else
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    end
  end

end