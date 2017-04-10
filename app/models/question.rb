class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :user

  has_many :answers, -> { with_best_answer }, dependent: :destroy

  has_many :subscriptions, dependent: :destroy

  has_one :best_answer, -> { where(best_answer: true) }, class_name: 'Answer'

  validates :title, :body, presence: true

  after_create :subscribe_author

  scope :ordered, -> { order(created_at: :desc) }

  private

  def subscribe_author
    subscriptions.create(user: user)
  end
end
