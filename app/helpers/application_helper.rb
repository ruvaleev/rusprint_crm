module ApplicationHelper
  def order_item(order_item)
    case order_item.item_type
    when 'CartridgeServiceGuide'
      render 'orders/order_item_cell', order_item: order_item
    when 'OtherOrderItem'
      render 'orders/other_order_item_cell', order_item: order_item
    end
  end

  def price_value(price)
    format('%0.2f', price / 100) + ' руб'
  end
end
