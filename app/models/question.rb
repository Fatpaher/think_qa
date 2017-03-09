class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :user

  has_many :answers, -> { with_best_answer }, dependent: :destroy

  has_one :best_answer, -> { where(best_answer: true) }, class_name: 'Answer'

  validates :title, :body, presence: true

  scope :ordered, -> { order(created_at: :desc) }

end
