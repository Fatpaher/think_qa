class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :attachments,
           as: :attachable,
           dependent: :destroy,
           inverse_of: :attachable

  validates :body, presence: true

  scope :ordered, -> { order(created_at: :asc) }
  scope :with_best_answer, -> { order(best_answer: :desc).ordered }

  accepts_nested_attributes_for :attachments, allow_destoy: true, reject_if: :all_blank

  def select_best
    ActiveRecord::Base.transaction do
      self.question.answers.where.not(id: self.id).update_all(best_answer: false)
      self.update!(best_answer: true)
    end
  end
end
