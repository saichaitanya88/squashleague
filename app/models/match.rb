class Match < ActiveRecord::Base

	has_many :games

	def player_full_name(_id)
		if _id.nil?
			return ""
		end
		player = Player.find(_id)
		return player.full_name_abbr
	end
	
	def round_name
		mtr = MatchesToRound.find_by_match_id(id)
		round = Round.find(mtr.round_id)
		return round.round_name
	end
	
	def scheduled?
		if status == "scheduled"
			return true
		end
		return false
	end
	
	def match_players
		return Player.find(player1_id).full_name_abbr + " vs. " + Player.find(player2_id).full_name_abbr
	end
	
	def get_winner_full_name
		if (winner_id.nil?)
			return ""
		else
			return Player.find(winner_id).full_name_abbr
		end
	end
	
end
