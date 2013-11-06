class CreateAwardsToPlayers < ActiveRecord::Migration
  def change
    create_table :awards_to_players do |t|
      t.string :status
      t.integer :award_id
      t.integer :player_id
      t.integer :season_id

      t.timestamps
    end
  end
end
