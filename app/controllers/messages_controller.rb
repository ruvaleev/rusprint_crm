class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_ready, except: :create
  after_action :publish_message, only: :create
  load_and_authorize_resource
  def create
    gon.receiver = User.find(params[:message][:receiver_id])
    @message = current_user.sent_messages.create(message_params) if current_user.friend_of?(gon.receiver)
  end

  def show
    redirect_to new_user_session_path unless current_user
  end

  def talk
    @friend = User.find(params[:id])
    @messages = current_user.sent_messages.where(receiver_id: params[:id]) |
                current_user.received_messages.where(sender_id: params[:id])
  end

  private

  def get_ready
    @friends = current_user.all_friends || false
    @message = current_user.sent_messages.new || false
    @tweets = Tweet.all
    @tweet = current_user.tweets.new
    gon.current_user = current_user || false
    gon.receiver = current_user || false
  end

  def publish_message
    return if @message.errors.any?

    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, 'HTTP_HOST' => 'localhost:3000',
                                          'HTTPS' => 'off',
                                          'REQUEST_METHOD' => 'GET',
                                          'SCRIPT_NAME' => '',
                                          'warden' => warden)
    ActionCable.server.broadcast(
      "messages_for_#{params[:message][:receiver_id]}",
      message: @message.to_json,
      sender: @message.sender.to_json
    )
  end

  def message_params
    params.require(:message).permit(:body, :receiver_id)
  end
end
