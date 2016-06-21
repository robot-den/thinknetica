class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  def self.find_or_create_authorization(auth)
    provider = auth[:provider]
    uid = auth[:uid].to_s
    authorization = Authorization.find_by(provider: provider, uid: uid)
    return authorization if authorization
    email = auth[:info][:email]
    return nil if email.nil?
    user = User.find_by(email: email)
    if !user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    user.authorizations.create!(provider: provider, uid: uid, confirmation_hash: Devise.friendly_token[0, 20])
  end
end
