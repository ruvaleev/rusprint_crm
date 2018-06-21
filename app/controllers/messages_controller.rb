class MessagesController < ApplicationController
  before_action :authenticate_user!
  
  respond_to :js, only: [ :create, :destroy ]


  def create 
    @message = current_user.sent_messages.create(body: params[:message][:body], receiver_id: params[:message][:receiver_id])
  end

  def show
    redirect_to new_user_session_path unless current_user
    @friends = current_user.all_friends
    @message = current_user.sent_messages.new
  end

  def talk
    @friend = User.find(params[:id])
    @message = current_user.sent_messages.new
    @messages = current_user.sent_messages.where(receiver_id: params[:id]).order(created_at: :asc)|
                current_user.received_messages.where(sender_id: params[:id]).order(created_at: :asc)
  end



  def award
    @answer.make_best if current_user.author_of?(@question)
  end

  def update
    @question = @answer.question
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    respond_with @answer.destroy if current_user.author_of?(@answer)
  end
  
private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def publish_answer
    return if @answer.errors.any?
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, { "HTTP_HOST"=>"localhost:3000",  
                                            "HTTPS"=>"off",   
                                            "REQUEST_METHOD"=>"GET",   
                                            "SCRIPT_NAME"=>"",   
                                            "warden" => warden })
    ActionCable.server.broadcast( "answers_#{@question.id}", {
      answer: @answer.to_json,
      attachments: @answer.attachments.to_json
    })
  end
end