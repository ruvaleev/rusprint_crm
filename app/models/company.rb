class Company < ApplicationRecord
  acts_as_paranoid
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id', optional: true, inverse_of: :customers

  has_many :orders, as: :customer
  has_many :employees, class_name: 'User', foreign_key: 'employer_id', dependent: :nullify
  has_many :printers
  has_many :archive_companies, dependent: :destroy

  validates :name, :adress, :telephone, presence: true

  before_save :increment_version  # обновляем текущую версию
  after_save :save_archive        # сохраняем архивную копию

  protected

  def increment_version
    return if Rails.env.test?

    version.nil? ? self.version = 1 : self.version += 1
  end

  def save_archive
    return if Rails.env.test?

    attributes = self.attributes.delete_if { |key, _value| %w[id manager_id].include?(key) }
    archive = archive_companies.new(attributes)
    archive.user = User.current
    archive.save
  end
end
