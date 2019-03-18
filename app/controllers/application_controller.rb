require 'application_responder'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  check_authorization unless: :devise_controller?
  before_action :set_current_user
  before_action :configure_permitted_parameters, if: :devise_controller?

  self.responder = ApplicationResponder
  respond_to :html

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end
  # Чтоб приложение всегда видело текущего пользователя, и ошибки валидации не срабатывали при изменениии Заказов,
  # Надо в консоли прописать User.current
  def set_current_user
    User.current = current_user
  end

  def configure_permitted_parameters
    update_attrs = %i[name second_name email password password_confirmation current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  private

  def do_not_check_authorization?
    respond_to?(:devise_controller?)
  end
end
