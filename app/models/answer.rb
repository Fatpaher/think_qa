class Answer < ApplicationRecord

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :ordered, -> { order(created_at: :asc) }
end
