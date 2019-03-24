class OrdersController < ApplicationController
  before_action :authenticate_user!
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
    params_for_order = order_params
    if params[:new_client_flag] == 'true'
      @company = Company.create(company_params)
      params_for_order[:customer_id] = @company.id
    end
    @order = Order.create(params_for_order.merge(qnt: @shopping_cart.total_unique_items))

    if @order.errors.any?
      @message = @order.errors.messages
    else
      gon.order = @order
      @shopping_cart.shopping_cart_items.update(order_id: @order.id)
      @message = "Заказ #{@order.id} успешно внесен"
    end
  end

  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
    gon.order = @order
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def find_shopping_cart
    @shopping_cart = ShoppingCart.find(session[:shopping_cart_id]) if session[:shopping_cart_id]
  end

  def clear_shopping_cart
    session.delete(:shopping_cart_id)
  end

  def order_params
    parameters = params.require(:order).permit(:printers, :cartridges, :revenue, :expense, :date_of_complete,
                                               :date_of_order, :suitable_time_start, :suitable_time_end,
                                               :additional_data, :customer_id, :status, :paid, :master_id,
                                               :provider, printers_attributes: [:printer_service_guide_id],
                                                          cartridges_attributes: [:cartridge_service_guide_id])
    # Оставляем только те параметры, которые позволено редактировать для данного пользователя
    parameters.delete_if { |key, _value| Order.prohibited_params(current_user).include?(key) }
  end

  def company_params
    params.require(:company).permit(:name, :adress, :telephone, :email)
  end

  def orders_collection
    if current_user.master?
      Order.where(master: current_user).order(date_of_complete: :desc, status: :desc).page(params[:page])
    elsif current_user.manager? || current_user.admin?
      Order.all.order(date_of_complete: :desc, status: :desc).page(params[:page])
    else
      []
    end
  end

  def complete_orders_collection
    if current_user.master?
      Order.completed.where(master: current_user).order(date_of_complete: :desc, status: :desc).page(params[:page])
    elsif current_user.manager? || current_user.admin?
      Order.completed.order(date_of_complete: :desc, status: :desc).page(params[:page])
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
