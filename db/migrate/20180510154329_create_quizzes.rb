class CreateQuizzes < ActiveRecord::Migration[5.1]
  def change
    create_table :quizzes do |t|
      t.string :quiz_name
      t.references :classgroup, foreign_key: true
      t.references :classsession, foreign_key: true
      t.timestamps
    end
  end
end
