class Round < ActiveRecord::Base
	def season
		rts = RoundsToSeason.find_by_round_id(id)
		s = Season.find(rts.season_id)
		return s
	end
	
	def matches
		mtrs = MatchesToRound.where(:round_id => id)
		m = Array.new
		mtrs.each do |mtr|
			match = Match.find(mtr.match_id)
			m.push(match)
		end
		return m
	end
	
	def incomplete_matches
		mtrs = MatchesToRound.where(:round_id => id)
		im = Array.new
		mtrs.each do |mtr|
			match = Match.find(mtr.match_id)
			if match.status == "scheduled"
				im.push(match)
			end
		end
		return im
	end
	
end
