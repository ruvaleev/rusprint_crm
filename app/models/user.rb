class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, #:confirmable,
         :omniauthable, omniauth_providers: [ :facebook ]

  belongs_to :employer, class_name: "Company", foreign_key: "employer_id", optional: true
  belongs_to :role

  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id"
  has_many :received_messages, class_name: "Message", foreign_key: "receiver_id"


  has_many :customers, class_name: "Company", foreign_key: "manager_id", dependent: :nullify
  has_many :orders, as: :master
  has_many :orders, as: :manager

  has_many :logs

  has_many :authorizations, dependent: :destroy

  before_create :set_default_role

  # validates :name, presence: true
  # validates :telephone, presence: true
  
  # validates :name, presence: true
  # validates :telephone, presence: true
  # has_many :friendships, dependent: :destroy
  # has_many :friends, :through => :friendships
  # has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  # has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    password = Devise.friendly_token[0, 20]
    if auth.info[:email]
      email = auth.info[:email] 
      # name = auth.info[:name]
      telephone = auth.info[:telephone]
      user = User.where(email: email).first || User.create!(email: email, password: password, password_confirmation: password)
    else
      user = User.create!(email: "temporary_email_#{User.last.id.to_s unless User.all.empty?}@mail.ru", password: password, password_confirmation: password)
    end
      user.create_authorization(auth)
      user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def make_friend(friend)
    Friendship.create(user: self, friend: friend)
  end

  def all_friends
    friends = User.find(Friendship.where(user:self).pluck(:friend_id))|
              User.find(Friendship.where(friend:self).pluck(:user_id))
  end

  def author_of?(resource)
    self.id == resource.user_id
  end

  def friend_of?(user)
    all_friends.include?(user)
  end

  def admin?
    self.role.name == 'admin'
  end

  def master?
    self.role.name == 'master'
  end

  def manager?
    self.role.name == 'manager'
  end

  private

  def set_default_role
    self.role ||= Role.find_by_name('customer')
  end

end
