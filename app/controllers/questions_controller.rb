class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, except: [ :show, :index ]
  before_action :load_question, only: [ :show, :edit, :update, :destroy, :vote ]
  before_action :build_answer, only: :show

  after_action :publish_question, only: [ :create ]
  
  def index
    @vote = Vote.new
    gon.current_user = current_user || false
    respond_with(@questions = Question.all)
  end

  def show
    @best = @question.answers.best.first
    gon.current_user = current_user || false
    gon.question = @question
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
  	@question.update(question_params)
  end

  def destroy
    respond_with(@question.destroy, location: questions_path) if current_user.author_of?(@question)
  end

  private

  def load_question
  	@question = Question.find(params[:id])
  end

  def question_params
  	params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def publish_question
    return if @question.errors.any?
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, { "HTTP_HOST"=>"localhost:3000",  
                                            "HTTPS"=>"off",   
                                            "REQUEST_METHOD"=>"GET",   
                                            "SCRIPT_NAME"=>"",   
                                            "warden" => warden })
    ActionCable.server.broadcast(
      'questions', @question.to_json
    )
  end

  def build_answer
    @answer = @question.answers.new
  end

end