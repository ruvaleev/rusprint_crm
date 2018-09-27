class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.all
    @customers = Company.all
  end

  def create
    @order = Order.create(order_params)
    if @order.errors.any?
      @message = @order.errors.messages
    else
      @message = "Заказ #{@order.id} успешно внесен"
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def get_drop_down_printers
    customer = Company.find(params[:id])
    @options = []
    customer.printers.each { |x| @options << [x.printer_service_guide.model, x.id] }
  end
  
  private

  def order_params
    params.require(:order).permit(:printers, :cartridges, :revenue, :date_of_complete, :date_of_order, 
                                  :suitable_time, :additional_data, :customer_id, 
                                  printers_attributes: [:printer_service_guide_id], 
                                  cartridges_attributes: [:cartridge_service_guide_id])
  end
end