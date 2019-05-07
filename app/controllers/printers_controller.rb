class PrintersController < ApplicationController
  load_and_authorize_resource

  def create
    @printer = Printer.create(printer_params)
    @company_id = printer_params[:company_id]
    @printers_list = Company.find(printer_params[:company_id]).printers
    @order_id = params[:order_id]
  end

  def get_models
    @search     = PrinterModelSearch.new(search_params)
    @models     = @search.results
    @company_id = params[:company_id]
    @order_id   = params[:order_id]
  end

  private

  def printer_params
    params.require(:printer).permit(:serial_number, :fuser_life_count, :additional_data,
                                    :masters_note, :company_id, :printer_service_guide_id)
  end

  def search_params
    params.require(:printer_model_search)
  end
end
