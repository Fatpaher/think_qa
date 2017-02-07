class CreateQuestionAndAnswerBasicModels < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.string :body, null: false

      t.timestamps null: false
    end

    create_table :answers do |t|
      t.string :body, null: false
      t.references :question, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
