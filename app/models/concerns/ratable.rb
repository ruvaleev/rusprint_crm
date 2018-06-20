module Ratable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :object, dependent: :destroy
  end

  def rating
    votes.sum(:value)
  end

  def vote(user, value)
    if user.voted?(self, value)
      votes.where(user: user, value: value).first.destroy
    else
      votes.create(user: user, value: value)
    end
  end

end