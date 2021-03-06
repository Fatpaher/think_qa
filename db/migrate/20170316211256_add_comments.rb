class AddComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :body
      t.references :commentable, polymorphic: true, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
