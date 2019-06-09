class PrinterServiceGuidesController < ApplicationController
  load_and_authorize_resource

  def create
    @printer_service_guide = PrinterServiceGuide.create(create_params)
    @company_id = params[:company_id]
  end

  def search_models
    @search     = PrinterModelSearch.new(search_params)
    @models     = @search.results
    @company_id = params[:company_id]
    @shopping_cart_id = params[:shopping_cart_id]
  end

  private

  def create_params
    params.require(:printer_service_guide).permit!
  end

  def search_params
    params.require(:printer_model_search)
  end
end
