class Tweet < ApplicationRecord
  belongs_to :author
  
  validates :body, presence: true

end
