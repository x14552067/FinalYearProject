class CreateClassGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :classgroups do |t|
      t.string :class_name
      t.string :course_name
      t.string :class_description
      t.integer :enrollment_key
      t.integer :image_id
      t.references :lecturer, foreign_key: true
      t.timestamps
    end
  end
end
