class Question < ApplicationRecord
  has_many :answers, -> { with_best_answer }, dependent: :destroy
  belongs_to :user
  has_one :best_answer, -> { where(best_answer: true) }, class_name: 'Answer'

  validates :title, :body, presence: true
end
