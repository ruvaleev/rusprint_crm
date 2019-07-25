class Log < ApplicationRecord
  belongs_to :user
  belongs_to :registerable, polymorphic: true, optional: true

  validates :body, presence: true
end
