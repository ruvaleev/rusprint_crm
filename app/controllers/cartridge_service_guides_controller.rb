class CartridgeServiceGuidesController < ApplicationController
  before_action :find_printer
  before_action :find_printer_service_guide
  after_action :transfer_variables
  load_and_authorize_resource

  def create
    @cartridge_service_guide = CartridgeServiceGuide.create(create_params)
    @printer_service_guide.cartridges.push(@cartridge_service_guide) if @cartridge_service_guide.persisted?
  end

  private

  def find_printer
    @printer = Printer.find_by(id: params[:printer_id])
  end

  def find_printer_service_guide
    @printer_service_guide = PrinterServiceGuide.find(params[:printer_service_guide_id])
  end

  def create_params
    params.require(:cartridge_service_guide).permit!
  end

  def transfer_variables
    @shopping_cart_id = params[:shopping_cart_id]
    @order_id = params[:order_id]
  end
end
