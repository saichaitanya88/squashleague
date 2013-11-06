class CreateRoundsToSeasons < ActiveRecord::Migration
  def change
    create_table :rounds_to_seasons do |t|
      t.integer :round_id
      t.integer :season_id
      t.string :status

      t.timestamps
    end
  end
end
