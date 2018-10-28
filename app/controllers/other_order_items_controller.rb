class OtherOrderItemsController < ApplicationController

  def destroy
    order_item = OtherOrderItem.find(params[:id])
    order_item.destroy
  end

end