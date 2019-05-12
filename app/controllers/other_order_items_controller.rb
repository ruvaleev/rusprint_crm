class OtherOrderItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :order_item, only: :update
  before_action :order_item_params

  load_and_authorize_resource

  def create
    other_order_item = OtherOrderItem.create(create_params)
    @order = Order.find(params[:order_id])
    shopping_cart = @order.shopping_cart
    order_item = shopping_cart.add(other_order_item, other_order_item.price, 1)
    order_item.update(order_id: @order.id)
    @order.update(revenue: shopping_cart.subtotal)
  end

  def update
    message = ''
    if @order_item.update(@order_item_params)
      order_item_params.each { |key| message << "Успешно обновили #{key.humanize} \n" }
      status = 200
    else
      @order_item.errors.messages.each { |key, value| message << "#{key.to_s.humanize} - #{value} \n" }
      status = 400
    end
    respond_to do |format|
      format.json { render json: { message: message }, status: status }
      format.html
    end
  end

  private

  def order_item
    @order_item = OtherOrderItem.find params[:id]
  end

  def order_item_params
    @order_item_params = params.require(:other_order_item).permit(:body, :price)
  end

  def create_params
    params.require(:other_order_item).permit(:body, :price)
  end
end
