class CreateUnderstandingResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :understanding_responses do |t|
      t.boolean :understood
      t.references :understanding_poll
      t.references :student
      t.timestamps
    end
  end
end
