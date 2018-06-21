class TweetsChannel < ApplicationCable::Channel
  def follow
    stream_from "tweets"
  end
end