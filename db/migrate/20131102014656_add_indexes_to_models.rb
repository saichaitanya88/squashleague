class AddIndexesToModels < ActiveRecord::Migration
  def change
  
  	add_index :roles, :level, :unique => true
  	
  	# add_index :rounds, :round_name, :unique => true
  	# add_index :rounds, :round_order, :unique => true
  	
  	add_index :seasons, :season_name, :unique => true
  	
  	add_index :awards, :award_name, :unique => true
  	
  	add_index :matches_to_rounds, :match_id, :unique => true
  	add_index :matches_to_rounds, :round_id, :unique => false
  	
  	#add_index :matches_to_rounds, [:match_id, :round_id], :unique => true
  	
  	#add_index :players, [:first_name, :last_name], :unique => true
  	
  	#add_index :awards_to_players, [:award_id, :player_id, :season_id], :unique => true
  	
  end
end
