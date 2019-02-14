class Company < ApplicationRecord
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id', optional: true

  has_many :orders, as: :customer
  has_many :employees, class_name: 'User', foreign_key: 'employer_id', dependent: :nullify
  has_many :printers
  has_many :archive_companies

  validates :name, :adress, :telephone, presence: true

  before_save :increment_version  # обновляем текущую версию
  after_save :save_archive        # сохраняем архивную копию

  protected

  def increment_version
    self.version.nil? ? self.version = 1 : self.version += 1
  end

  def save_archive
    attributes = self.attributes.delete_if { |key, value| ['id', 'manager_id'].include?(key) }
    archive = self.archive_companies.new(attributes)
    archive.user = User.current
    archive.save
  end
end