class CreatePlayersToSeasons < ActiveRecord::Migration
  def change
    create_table :players_to_seasons do |t|
      t.string :status
      t.string :player_id
      t.string :season_id

      t.timestamps
    end
  end
end
