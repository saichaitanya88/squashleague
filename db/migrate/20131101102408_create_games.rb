class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :status
      t.integer :player1_score
      t.integer :player2_score
      t.integer :game_winner_id
      t.integer :game_number
      t.integer :match_id

      t.timestamps
    end
  end
end
