class CreateClassSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :classsessions do |t|
      t.references :classgroups, foreign_key: true
      t.references :students, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.string :description
      t.boolean :is_active
      t.timestamps
    end
  end
end
