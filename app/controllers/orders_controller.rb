class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_shopping_cart, only: [ :create ]
  after_action :clear_shopping_cart, only: [ :create ]

  load_and_authorize_resource

  def index
    @orders = Order.all
    @customers = Company.all
  end

  def create
    params_for_order = order_params
    if params[:new_client_flag] == 'true'
      @company = Company.create(company_params)
      params_for_order[:customer_id] = @company.id
    end
    @order = Order.create(params_for_order.merge( { qnt: @shopping_cart.total_unique_items } ))
    
    if @order.errors.any?
      @message = @order.errors.messages
    else
      @shopping_cart.shopping_cart_items.update_all(order_id: @order.id)
      @message = "Заказ #{@order.id} успешно внесен"
    end
  end

  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
  end

  def show
    @order = Order.find(params[:id])
  end

  def get_printers
    customer    = Company.find(params[:id])
    @printers   = customer.printers
    @vendors    = Printer::VENDORS.map.with_index.to_a
  end
  
  private

  def find_shopping_cart
    @shopping_cart = ShoppingCart.find(session[:shopping_cart_id]) if session[:shopping_cart_id]
  end

  def clear_shopping_cart
    session.delete(:shopping_cart_id)
  end

  def order_params
    params.require(:order).permit(:printers, :cartridges, :revenue, :expense, :date_of_complete, :date_of_order, :suitable_time_start, :suitable_time_end, :additional_data, :customer_id, printers_attributes: [:printer_service_guide_id], cartridges_attributes: [:cartridge_service_guide_id])
  end

  def company_params
    params.require(:company).permit(:name, :adress, :telephone, :email)
  end
end