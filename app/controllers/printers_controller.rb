class PrintersController < ApplicationController
  load_and_authorize_resource

  def create
    @printer = Printer.create(printer_params)
    @company_id = printer_params[:company_id]
    @shopping_cart = ShoppingCart.find_by(id: params[:shopping_cart_id])
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
end
