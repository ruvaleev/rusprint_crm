class Question < ApplicationRecord
  include Ratable
  
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  
  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attr| attr['file'].nil? }

  def not_awarded_answers
    answers.where(award: false)
  end

end
