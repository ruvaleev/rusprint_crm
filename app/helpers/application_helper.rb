module ApplicationHelper
  def price_value(price)
    format('%0.2f', price / 100) + ' руб'
  end

  def order_statuses
    collection = Hash.new(0)

    collection['pending'] = 'Не распределен'
    collection['signed'] = 'Мастер назначен'
    collection['completed'] = 'Заказ выполнен'
    collection['closed'] = 'Заказ закрыт'
    collection['canceled'] = 'Заказ отменен'

    collection
  end
end
