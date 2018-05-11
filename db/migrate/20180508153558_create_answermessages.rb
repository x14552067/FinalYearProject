class CreateAnswermessages < ActiveRecord::Migration[5.1]
  def change
    create_table :answermessages do |t|
      t.references :classsession, foreign_key: true
      t.references :lecturer, foreign_key: true, null: true
      t.references :questionmessage, foreign_key: true, null: true
      t.string :content
      t.timestamps
    end
  end
end
