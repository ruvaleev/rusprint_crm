class PrinterServiceGuidesController < ApplicationController
  load_and_authorize_resource

  def create
    @printer_service_guide = PrinterServiceGuide.create(create_params)
    @order_id = params[:order_id]
    @company_id = params[:company_id]
  end

  private

  def create_params
    params.require(:printer_service_guide).permit!
  end
end
