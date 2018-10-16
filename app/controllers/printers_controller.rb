class PrintersController < ApplicationController

  def create
    @printer = Printer.create(printer_params)
  end

  def get_models
    @search = PrinterModelSearch.new(search_params)
    @models = @search.results
  end

  private

  def printer_params
    params.require(:printer).permit(  :serial_number, :fuser_life_count, :additional_data, 
                                      :masters_note, :printer_service_guide, :company  )
  end

  def search_params
    params.require(:printer_model_search)
  end
         
end