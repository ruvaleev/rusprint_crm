class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer
  after_action :publish_comment

  def create
    @comment = @answer.comments.create(user: current_user, body: params[:comment][:body])
    gon.answer = @answer
  end

  private

  def load_answer
    @answer = Answer.find(params[:answer_id])
  end

  def publish_comment
    return if @comment.errors.any?
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, { "HTTP_HOST"=>"localhost:3000",  
                                            "HTTPS"=>"off",   
                                            "REQUEST_METHOD"=>"GET",   
                                            "SCRIPT_NAME"=>"",   
                                            "warden" => warden })
    ActionCable.server.broadcast(
      "comments_for_#{@answer.question.id}", @comment.to_json
    )
  end

end
