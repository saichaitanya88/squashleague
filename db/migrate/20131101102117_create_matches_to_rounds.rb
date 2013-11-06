class CreateMatchesToRounds < ActiveRecord::Migration
  def change
    create_table :matches_to_rounds do |t|
      t.integer :match_id
      t.integer :round_id
      t.string :status

      t.timestamps
    end
  end
end
