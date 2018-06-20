class Comment < ApplicationRecord
  
  belongs_to :commentable
  belongs_to :user
  
  validates :body, presence: true


end
