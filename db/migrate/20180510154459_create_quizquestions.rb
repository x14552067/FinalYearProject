class CreateQuizquestions < ActiveRecord::Migration[5.1]
  def change
    create_table :quizquestions do |t|
      t.string :question_text
      t.string :question_answer
      t.references :quiz, foreign_key: true
      t.timestamps
    end
  end
end
