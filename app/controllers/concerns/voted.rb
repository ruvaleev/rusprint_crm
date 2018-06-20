module Voted
  extend ActiveSupport::Concern

  def create_vote
    @object = controller_name.classify.constantize.find(params[:id])
    @vote = @object.vote(current_user, params[:value])
    respond_to do |format|
      format.json { render json: { vote: @vote, rating: @object.rating } }
    end
  end

end