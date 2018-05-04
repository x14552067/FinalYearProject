class CreateJoinTableStudentsClassgroups < ActiveRecord::Migration[5.1]
  def change
    create_join_table :students, :classgroups do |t|
      t.index [:student_id, :classgroup_id]
      t.index [:classgroup_id, :student_id]
    end
  end
end