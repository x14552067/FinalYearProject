class CreateStudentResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :student_responses do |t|
      t.references :students, foreign_key: true
      t.timestamps
    end
  end
end
