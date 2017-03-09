class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(item)
    id == item&.user_id
  end

  def voted_for(votable)
    !!votable.votes.find_by(user_id: id)
  end
end
