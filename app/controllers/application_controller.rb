require 'application_responder'

class ApplicationController < ActionController::Base
  before_action :set_current_user

  check_authorization

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

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
end
