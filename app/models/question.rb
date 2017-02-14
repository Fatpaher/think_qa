class Question < ApplicationRecord
  has_many :answers,  -> { ordered }, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
end
