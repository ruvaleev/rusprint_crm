class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_order, except: %i[index create]
  before_action :find_shopping_cart, only: [:create]
  after_action :clear_shopping_cart, only: [:create]
  # разблокировать, когда починим ActionCable фичу
  # after_action :publish_order, only: [ :create, :update ]

  load_and_authorize_resource

  def index
    @orders           = orders_collection
    @complete_orders  = complete_orders_collection
    @customers        = Company.all
    gon.current_user = current_user
  end

  def create
    @order = Order.create(order_params.merge(qnt: @shopping_cart.total_unique_items))

    if @order.errors.any?
      @message = @order.errors.messages
    else
      gon.order = @order
      @shopping_cart.shopping_cart_items.update(order_id: @order.id)
      @message = "Заказ #{@order.id} успешно внесен"
    end
    redirect_to :root
  end

  def update
    message = ''
    if @order.update(order_params)
      gon.order = @order
      order_params.each { |key| message << "Успешно обновили #{key.humanize} \n" }
      status = 200
    else
      @order.errors.messages.each { |key, value| message << "#{key.to_s.humanize} - #{value} \n" }
      status = 400
    end
    respond_to do |format|
      format.json { render json: { message: message }, status: status }
      format.html
    end
  end

  def show; end

  def update_customer
    @order.update(customer_id: params[:order][:customer_id])
  end

  private

  def find_order
    @order = Order.find(params[:id])
  end

  def check_and_create_company
    unless params[:new_client_flag] == 'true'
      flash[:error] = I18n.t 'orders.errors.order_have_no_customer'
      redirect_to :root and return
    end
    company = Company.create(company_params)
    company.id
  end

  def find_shopping_cart
    unless session[:shopping_cart_id]
      flash[:error] = I18n.t 'orders.errors.order_have_no_shopping_carts'
      redirect_to :root and return
    end

    @shopping_cart = ShoppingCart.find(session[:shopping_cart_id])
  end

  def clear_shopping_cart
    session.delete(:shopping_cart_id)
  end

  def order_params
    parameters = params.require(:order).permit(:printers, :cartridges, :revenue, :expense, :date_of_complete,
                                               :date_of_order, :suitable_time_start, :suitable_time_end,
                                               :additional_data, :customer_id, :status, :paid, :master_id,
                                               :manager_id, :provider, :qnt,
                                               printers_attributes: [:printer_service_guide_id],
                                               cartridges_attributes: [:cartridge_service_guide_id])

    if (action_name == 'create') && (parameters[:customer_id].blank? || params[:new_client_flag] == 'true')
      parameters[:customer_id] = check_and_create_company
    end

    # Оставляем только те параметры, которые позволено редактировать для данного пользователя
    parameters.delete_if { |key, _value| Order.prohibited_params(current_user).include?(key) }
  end

  def company_params
    params.require(:company).permit(:name, :adress, :telephone, :email)
  end

  def orders_collection
    if current_user.master?
      Order.where(master: current_user).order(date_of_complete: :desc, status: :desc).page(params[:page]).per(10)
    elsif current_user.manager? || current_user.admin?
      Order.all.order(date_of_complete: :desc, status: :desc).page(params[:page]).per(10)
    else
      []
    end
  end

  def complete_orders_collection
    if current_user.master?
      Order.completed.where(master: current_user).order(date_of_complete: :desc, status: :desc)
           .order(date_of_complete: :desc, status: :desc).page(params[:page]).per(10)
    elsif current_user.manager? || current_user.admin?
      Order.completed.order(date_of_complete: :desc, status: :desc).page(params[:page]).per(10)
    else
      []
    end
  end

  # def publish_order
  #   return if @order.errors.any?

  #   renderer = ApplicationController.renderer.new
  #   renderer.instance_variable_set(:@env, 'HTTP_HOST' => 'localhost:3000',
  #                                         'HTTPS' => 'off',
  #                                         'REQUEST_METHOD' => 'GET',
  #                                         'SCRIPT_NAME' => '',
  #                                         'warden' => warden)
  #   ActionCable.server.broadcast(
  #     "orders_for_#{@order.master_id}", @order.to_json
  #   )
  # end
end
