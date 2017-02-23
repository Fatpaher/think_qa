class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, -> { with_best_answer }, dependent: :destroy
  has_many :attachments,
           as: :attachable,
           dependent: :destroy,
           inverse_of: :attachable

  has_one :best_answer, -> { where(best_answer: true) }, class_name: 'Answer'

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank
end
