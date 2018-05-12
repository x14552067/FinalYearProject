class CreateQuestionmessages < ActiveRecord::Migration[5.1]
  def change
    create_table :questionmessages do |t|
      t.references :classsession, foreign_key: true
      t.references :student, foreign_key: true, null: true
      t.string :content
      t.boolean :is_anon
      t.timestamps
    end
  end
end