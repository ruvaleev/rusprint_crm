module ApplicationHelper
  def price_value(price)
    format('%0.2f', price / 100) + ' руб'
  end
end
