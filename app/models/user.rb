class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, :confirmable,
         omniauth_providers: [:facebook, :twitter]

  def self.find_for_oauth(auth)
    authorization = Authorization.find_for_oauth(auth)
    return authorization.user if authorization

    email = auth['info']['email']
    user = User.where(email: email).first

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      return nil unless user.save
    end

    user.skip_confirmation! unless auth['unconfirm']
    user.authorizations.create(provider: auth['provider'], uid: auth['uid'])
    user
  end

  def author_of?(item)
    id == item&.user_id
  end

  def voted_for(votable)
    !!votable.votes.find_by(user_id: id)
  end
end
