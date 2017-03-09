class FixAttachmetsForeignKeys < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :attachments, :questions
  end
end
