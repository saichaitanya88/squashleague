class MatchLeagueInfo

	def initialize(round_id, match_id, match, round_name)

		@round_id = round_id
		@match_id = match_id
		@round_name = round_name
		@players = "#{Player.find(match.player1_id).full_name_abbr} vs. #{Player.find(match.player2_id).full_name_abbr}"
		@results = ""
		if match.games.count == 0
			@results = "LINK "
		end
		
		match.games.each do |game|
			@results = @results + "#{game.player1_score}-#{game.player2_score}" + ","
		end
		@results = @results.chop
		
#		return self
	end

	def match_id
		return @match_id
	end

	def round_id
		return @round_id
	end

	def round_name
		return @round_name
	end

	def players
		return @players
	end

	def results
		return @results
	end
	
end
