class OrdersController < ApplicationController
  # before_action :authenticate_user!

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:printer_service_guide_id)
  end
end