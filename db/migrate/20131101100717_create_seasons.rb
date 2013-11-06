class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.string :season_name
      t.integer :season_winner
      t.string :season_status
      t.date :season_start
      t.date :season_end
      t.integer :matches_per_player_pair

      t.timestamps
    end
  end
end
