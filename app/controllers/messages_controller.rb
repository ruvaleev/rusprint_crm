class MessagesController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_message, only: [ :create ]

  def create 
    gon.receiver = User.find(params[:message][:receiver_id])
    @message = current_user.sent_messages.create(body: params[:message][:body], receiver_id: params[:message][:receiver_id])
  end

  def show
    redirect_to new_user_session_path unless current_user
    @friends = current_user.all_friends
    @message = current_user.sent_messages.new
    @tweets = Tweet.all
    @tweet = current_user.tweets.new
    gon.current_user = current_user || false
    gon.receiver = current_user || false
  end

  def talk
    @friend = User.find(params[:id])
    @message = current_user.sent_messages.new
    @messages = current_user.sent_messages.where(receiver_id: params[:id])|
                current_user.received_messages.where(sender_id: params[:id])
  end


private

  def publish_message
    return if @message.errors.any?
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, { "HTTP_HOST"=>"localhost:3000",  
                                            "HTTPS"=>"off",   
                                            "REQUEST_METHOD"=>"GET",   
                                            "SCRIPT_NAME"=>"",   
                                            "warden" => warden })
    ActionCable.server.broadcast(
      "messages_for_#{params[:message][:receiver_id]}", {
      message: @message.to_json,
      sender: @message.sender.to_json
    }
    )
  end

end