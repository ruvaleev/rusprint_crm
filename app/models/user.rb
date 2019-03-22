class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, #:confirmable,
         :omniauthable, omniauth_providers: [:facebook]

  belongs_to :employer, class_name: 'Company', foreign_key: 'employer_id', optional: true, inverse_of: :employees
  belongs_to :role

  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy, inverse_of: :sender
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id',
                               dependent: :destroy, inverse_of: :receiver

  has_many :customers, class_name: 'Company', foreign_key: 'manager_id', dependent: :nullify, inverse_of: :manager
  has_many :orders, as: :master, dependent: :nullify, inverse_of: :master
  has_many :orders, as: :manager, dependent: :nullify, inverse_of: :manager

  has_many :logs, dependent: :destroy

  has_many :authorizations, dependent: :destroy

  before_validation :set_default_role

  scope :masters, -> { where(role: Role.find_by(name: 'master')) }
  scope :managers, -> { where(role: Role.find_by(name: 'manager')) }

  # validates :name, presence: true
  # validates :telephone, presence: true

  # validates :name, presence: true
  # validates :telephone, presence: true
  # has_many :friendships, dependent: :destroy
  # has_many :friends, :through => :friendships
  # has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  # has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    password = Devise.friendly_token[0, 20]
    if auth.info[:email]
      email = auth.info[:email]
      name = auth.info[:name]
      telephone = auth.info[:telephone]
      user = User.find_by(email: email) || User.create!(email: email, password: password,
                                                        password_confirmation: password,
                                                        role: Role.find_by(name: 'customer'),
                                                        telephone: telephone, name: name)
    else
      user = User.create!(email: "temporary_email_#{User.last.id.to_s unless User.all.empty?}@mail.ru",
                          password: password, password_confirmation: password)
    end
    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def author_of?(resource)
    id == resource.user_id
  end

  def admin?
    role.name == 'admin'
  end

  def master?
    role.name == 'master'
  end

  def manager?
    role.name == 'manager'
  end

  def customer?
    role.name == 'customer'
  end

  def can_update?(class_name, attribute)
    class_name.prohibited_params(self).exclude?(attribute)
  end

  # Выносим current_user на уровень модели

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  private

  def set_default_role
    self.role ||= Role.find_by(name: 'customer')
  end
end
