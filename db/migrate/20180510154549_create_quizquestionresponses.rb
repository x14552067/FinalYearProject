class CreateQuizquestionresponses < ActiveRecord::Migration[5.1]
  def change
    create_table :quizquestionresponses do |t|
      t.references :quizquestion, foreign_key: true
      t.references :student, foreign_key: true
      t.string :answer

      t.timestamps
    end
  end
end
