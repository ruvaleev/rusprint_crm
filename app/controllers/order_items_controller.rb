class OrderItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :order_item
  before_action :order_item_params
  before_action :find_order
  before_action :serialize_price_cents, only: :update
  after_action :actualize_order, only: :update

  load_and_authorize_resource

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
    @order_item = OrderItem.find params[:id]
  end

  def order_item_params
    @order_item_params = params.require(:order_item).permit(:quantity, :price_cents)
  end

  def find_order
    @order       = @order_item.order
    @order_items = @order.order_items
  end

  def serialize_price_cents
    return if @order_item_params[:price_cents].blank?

    @order_item_params[:price_cents] = @order_item_params[:price_cents].to_f * 100
  end

  def actualize_order
    order_params = {}
    order_params[:revenue] = @order_item.owner.subtotal if @order_item
    order_params[:qnt] = @order_item.owner.total_unique_items if params[:order_item][:quantity]
    @order.update(order_params)
  end
end
