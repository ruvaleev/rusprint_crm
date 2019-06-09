class OtherOrderItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :order_item, only: :update
  before_action :order_item_params

  load_and_authorize_resource

  def create
    other_order_item = OtherOrderItem.create(create_params)
    return unless other_order_item.persisted?

    @shopping_cart = ShoppingCart.find(params[:shopping_cart_id])
    order_item = @shopping_cart.add(other_order_item, other_order_item.price, 1)
    return unless @shopping_cart.order_id

    order_item.update(order_id: @shopping_cart.order_id)
    @shopping_cart.order.update(revenue: @shopping_cart.subtotal)
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
