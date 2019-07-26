class PricesController < ApplicationController
  load_and_authorize_resource
  def create
    price = Price.create(price_params)
    price.parse
    @message = if price.errors.any?
                 "При загрузке произошли следующие ошибки: #{price.errors.messages}"
               else
                 "Прайс #{price.file.filename} успешно загружен"
               end
    redirect_to :root
  end

  private

  def price_params
    params.require(:price).permit(:file)
  end
end
