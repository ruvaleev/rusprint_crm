class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, #:confirmable,
         :omniauthable, omniauth_providers: [ :facebook ]
  has_many :messages, as: :author, dependent: :destroy
  has_many :messages, as: :recipient
  has_many :tweets, as: :author, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :friendships
  has_many :users, :through => :friendships

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    password = Devise.friendly_token[0, 20]
    if auth.info[:email]
      email = auth.info[:email] 
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

end
