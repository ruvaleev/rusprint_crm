class PricesController < ApplicationController
  
  def create
    price = Price.create(price_params)
    price.parse
    price.errors.any? ? @message = "При загрузке произошли следующие ошибки: #{price.errors.messages}" 
                      : @message = "Прайс #{price.file.filename} успешно загружен"
  end

  private

  def price_params
    params.require(:price).permit(:file)
  end


end