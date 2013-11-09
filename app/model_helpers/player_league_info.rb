class PlayerLeagueInfo

	def initialize(player_id)
		@league_points_for = 0
		@league_points_against = 0
		@matches_played = 0
		@player_id = player_id
	end

	def player_id
		return @player_id
	end

	def league_points_for
		return @league_points_for
	end

	def league_points_against
		return @league_points_against
	end
	
	def set_matches_played (mp)
		@matches_played = mp
	end
	
	def set_league_points_for (lpf)
		@league_points_for = lpf
	end
	
	def	set_league_points_against (lpa)
		@league_points_against = lpa
	end
	
	def matches_played
		return @matches_played
	end
	
end
