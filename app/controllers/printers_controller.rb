class PrintersController < ApplicationController
  load_and_authorize_resource

  def create
    @printer = Printer.create(printer_params)
    @company_id = params[:company_id]
    @printers_list = Company.find(params[:company_id]).printers
  end

  def get_models
    @search     = PrinterModelSearch.new(search_params)
    @models     = @search.results
    @company_id = params[:company_id]
    @order_id   = params[:order_id]
  end

  private

  def printer_params
    printer_params = params.require(:printer).permit(:serial_number, :fuser_life_count, :additional_data,
                                                     :masters_note)
    printer_params[:company_id]               = params[:company_id]
    printer_params[:printer_service_guide_id] = params[:printer_service_guide_id]
    printer_params
  end

  def search_params
    params.require(:printer_model_search)
  end
end
