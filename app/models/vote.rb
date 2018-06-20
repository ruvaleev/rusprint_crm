class Vote < ApplicationRecord
  belongs_to :object, polymorphic: true, optional: true
  belongs_to :user
  validate :author_cannot_vote_for_himself
  validates :user_id, uniqueness: { scope: [:object_id, :object_type, :value] }

  def author_cannot_vote_for_himself
    errors.add(:authorship, "You can't vote for own #{self.object_type}") if self.user.author_of?(self.object)
  end

end
