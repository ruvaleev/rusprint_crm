class Answer < ApplicationRecord
  include Ratable
  include Commentable
  
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable
  
  validates :body, presence: true

  scope :best, -> { where(award: true) }

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attr| attr['file'].nil? }

  def make_best
    Answer.transaction do
      question.answers.update_all(award: false)
      update!(award: true)
    end
  end

end
