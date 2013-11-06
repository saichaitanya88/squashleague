class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :round_name
      t.integer :round_order
      t.date :round_start
      t.date :round_end
      t.string :status

      t.timestamps
    end
  end
end
