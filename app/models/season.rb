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
end
