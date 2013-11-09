class Player < ActiveRecord::Base
	validates :first_name, presence: true
	validates :last_name, presence: true
	
	def full_name
		return self.first_name + " " + self.last_name
	end
	
	# takes the current season Id as input, returns the player_league information
	def season_score
	
	end
	
end
