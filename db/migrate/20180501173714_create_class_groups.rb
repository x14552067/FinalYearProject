class CreateClassGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :class_groups do |t|
      t.string :class_name
      t.string :course_name
      t.string :class_description
      t.integer :unique_id
      t.references :lecturer, foreign_key: true
      t.timestamps
    end
  end
end
