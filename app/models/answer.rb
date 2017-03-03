class Answer < ApplicationRecord
  include Attachable
  include Votable

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :ordered, -> { order(created_at: :asc) }
  scope :with_best_answer, -> { order(best_answer: :desc).ordered }


  def select_best
    ActiveRecord::Base.transaction do
      self.question.answers.where.not(id: self.id).update_all(best_answer: false)
      self.update!(best_answer: true)
    end
  end
end
