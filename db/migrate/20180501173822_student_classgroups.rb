class StudentClassgroups < ActiveRecord::Migration[5.1]
  def change
    create_table :student_classgroups, id: false do |t|
      t.belongs_to :student, index: true
      t.belongs_to :classgroup, index: true
    end
  end
end
