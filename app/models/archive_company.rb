class ArchiveCompany < ApplicationRecord
  acts_as_paranoid
  belongs_to :company
  belongs_to :user
end
