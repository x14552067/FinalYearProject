class CreateEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :enrollments do |t|
      t.integer :enrollment_key
      t.timestamps
    end
  end
end
