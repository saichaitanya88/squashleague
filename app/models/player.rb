class Player < ActiveRecord::Base
	validates :first_name, presence: true
	validates :last_name, presence: true
	
	def full_name_abbr
		return self.first_name + " " + self.last_name[0]	+ "."
	end
	
	def full_name_abs
		return self.first_name + " " + self.last_name
	end
	
	# takes the current season Id as input, returns the player_league information
	def season_score
	
	end
	
	def user
		if !user_id.nil?
			return User.find(user_id)
		end
		return User.new
	end
	
end
