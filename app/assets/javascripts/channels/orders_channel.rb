class OrdersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "orders_for_#{data['master_id']}"
  end
end
