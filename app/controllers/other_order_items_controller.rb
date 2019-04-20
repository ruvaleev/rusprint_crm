class OtherOrderItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :order_item
  before_action :order_item_params

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
    @order_item = OtherOrderItem.find params[:id]
  end

  def order_item_params
    @order_item_params = params.require(:other_order_item).permit(:body)
  end
end
