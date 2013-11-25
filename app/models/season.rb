class Season < ActiveRecord::Base

	def division_level
		season_to_division = SeasonsToDivision.find_by_season_id(id)
		if !season_to_division
			return "---"
		end
		
		division = Division.find(season_to_division.division_id)
		if division
			return division.division_level
		else
			return "---"
		end
	end
	
	def winner_name
		if season_winner.nil?
			return ""
		else
			return Player.find(season_winner).full_name
		end
	end
	
	def get_rounds_in_season
		rts = RoundsToSeason.where(:season_id => id).select(:id, :round_id)
		rounds = Array.new
		rts.each do |r|
			rounds.push(Round.find(r.round_id))
		end
		return rounds
	end
	
	def get_rounds_to_seasons
		rts = RoundsToSeason.where(:season_id => id).select(:id, :round_id)
		return rts
#		rts.each do |r|
#			round = Round.find(r.round_id)
#			time = Time.new
#			
#			if round.round_start == time.strftime("%Y-%m-%d")
#				puts "The email should be sent for this condition"
#			end
#		end
	end
	
end
