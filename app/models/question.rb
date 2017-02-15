class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :right_answer, class_name: 'Answer', foreign_key: 'right_answer_id', optional: true

  validates :title, :body, presence: true

  def right_answer?(answer)
    right_answer == answer
  end

  def remove_right_answer(answer)
    if right_answer?(answer)
      self.right_answer_id = nil
      self.save
    end
  end
end
