class CreateJoinTableStudentsClasssessions < ActiveRecord::Migration[5.1]
  def change
    create_join_table :students, :classsessions do |t|
      t.index [:student_id, :classsession_id]
      t.index [:classsession_id, :student_id]
    end
  end
end
