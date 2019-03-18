class PricesController < ApplicationController
  load_and_authorize_resource
  def create
    price = Price.create(price_params)
    price.parse
    @message = price.errors.any? ? "При загрузке произошли следующие ошибки: #{price.errors.messages}" : "Прайс #{price.file.filename} успешно загружен"
  end

  private

  def price_params
    params.require(:price).permit(:file)
  end
end
