class CreateLecturers < ActiveRecord::Migration[5.1]
  def change
    create_table :lecturers do |t|
      t.string :first_name
      t.string :last_name
      t.string :institute
      t.references :user
      t.timestamps
    end
  end
end
