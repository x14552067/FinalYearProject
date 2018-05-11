class CreateJoinTableClasssessionQuiz < ActiveRecord::Migration[5.1]
  def change
    create_join_table :quizzes, :classsessions do |t|
      t.index [:quiz_id, :classsession_id]
      t.index [:classsession_id, :quiz_id]
    end
  end
end
