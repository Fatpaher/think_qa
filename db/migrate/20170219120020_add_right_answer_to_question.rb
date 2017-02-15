class AddRightAnswerToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :right_answer, references: :answers
    add_foreign_key :questions, :answers, column: :right_answer_id
  end
end
