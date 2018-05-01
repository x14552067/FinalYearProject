class CreateClassSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :class_sessions do |t|
      t.references :class_groups, foreign_key: true
      t.timestamps
    end
  end
end
