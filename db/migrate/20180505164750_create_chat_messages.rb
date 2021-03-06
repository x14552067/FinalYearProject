class CreateChatMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :chatmessages do |t|
      t.references :classsession, foreign_key: true
      t.references :student, foreign_key: true, null: true
      t.references :lecturer, foreign_key: true, null: true
      t.string :content
      t.boolean :is_anon
      t.timestamps
    end
  end
end
