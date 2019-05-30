class PrintersController < ApplicationController
  load_and_authorize_resource

  def create
    @printer = Printer.create(printer_params)
    @company_id = printer_params[:company_id]
    @printers_list = Company.find(printer_params[:company_id]).printers
    return unless params[:order_id]

    @order_id = params[:order_id]
    @shopping_cart_id = Order.find(params[:order_id]).shopping_cart_id
  end

  def get_models
    @search     = PrinterModelSearch.new(search_params)
    @models     = @search.results
    @company_id = params[:company_id]
    @order_id   = params[:order_id]
  end

  def update
    @printer = Printer.find(params[:id])
    message = ''
    if @printer.update(printer_params)
      printer_params.each { |key| message << "Успешно обновили #{key.humanize} \n" }
      status = 200
    else
      @printer.errors.messages.each { |key, value| message << "#{key.to_s.humanize} - #{value} \n" }
      status = 400
    end
    respond_to do |format|
      format.json { render json: { message: message }, status: status }
      format.html
    end
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
