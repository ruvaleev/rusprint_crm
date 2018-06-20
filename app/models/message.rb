class Message < ApplicationRecord
  belongs_to :author
  belongs_to :recipient
  
  validates :body, presence: true

end
