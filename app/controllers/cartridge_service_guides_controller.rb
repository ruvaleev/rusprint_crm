class CartridgeServiceGuidesController < ApplicationController
  load_and_authorize_resource

  def create
    @cartridge_service_guide = CartridgeServiceGuide.create(create_params)
    @shopping_cart_id = params[:shopping_cart_id]
    @printer = Printer.find_by(id: params[:printer_id])
    @order_id = params[:order_id]
  end

  private

  def create_params
    params.require(:cartridge_service_guide).permit!
  end
end
