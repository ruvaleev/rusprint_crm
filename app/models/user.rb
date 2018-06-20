class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, #:confirmable,
         :omniauthable, omniauth_providers: [ :vkontakte, :facebook, :twitter ]
  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes
  has_many :authorizations

  def author_of?(resource)
    self.id == resource.user_id
  end

  def voted?(object, value)
    self.votes.where(object: object, value: value).present?
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    if auth.info[:email]
      email = auth.info[:email] 
      user = User.where(email: email).first
      if user
        user.create_authorization(auth)
      else
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
        user.create_authorization(auth)
      end
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: "temporary_email_#{User.last.id.to_s unless User.all.empty?}@mail.ru", password: password, password_confirmation: password)
      user.create_authorization(auth)
    end
      user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

end
