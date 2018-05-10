class CreateJoinSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :joinsessions do |t|
      t.integer :session_key
      t.timestamps
    end
  end
end
