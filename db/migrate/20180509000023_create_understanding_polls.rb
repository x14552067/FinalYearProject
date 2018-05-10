class CreateUnderstandingPolls < ActiveRecord::Migration[5.1]
  def change
    create_table :understanding_polls do |t|
      t.references :classsession, foreign_key: true
      t.timestamps
    end
  end
end
