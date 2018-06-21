class MessagesChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "messages_for_#{data['receiver_id']}"
  end
end