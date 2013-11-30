module LeagueHelper

	def generate_player_league_info(season_id)
		players_league_info_array = Array.new
		pts = PlayersToSeason.where(:season_id => season_id)
	
		pts.each do |p|
			player = Player.find(p.player_id)
			player_league_info = PlayerLeagueInfo.new(player.id)
	  	matches_p1 = Match.where(player1_id: player.id).where(status: "completed")
	  	matches_p2 = Match.where(player2_id: player.id).where(status: "completed")
			matches_p = Object.new
			if matches_p1.nil? == false and matches_p2.nil? == false
		  	matches_p = matches_p1 + matches_p2
			elsif matches_p1.nil? == false and matches_p2.nil? == true
		  	matches_p = matches_p1
			else
		  	matches_p = matches_p2
			end

	  	matches_p.each do |match|
	  		#only want correct season

				if match.round.season.id.to_i != p.season_id.to_i
		  		next
	  		end
	  		mtr = MatchesToRound.find_by_match_id(match.id)
	  		rts = RoundsToSeason.find_by_round_id(mtr.round_id)
	  		season = Season.find(rts.season_id)
				player_league_info.set_matches_played(player_league_info.matches_played + 1)
	  		if (season.id.to_s != season_id)
		  		next
	  		end

	  		match.games.each do |game|
					if game.game_winner_id == player.id
						player_league_info.set_league_points_for(player_league_info.league_points_for + 1)
					else
						player_league_info.set_league_points_against(player_league_info.league_points_against + 1)
					end
					puts player_league_info.to_json
	  		end
	  	end

	  	players_league_info_array.push(player_league_info)
  	end

		return players_league_info_array
	end


	def generate_round_league_info(sid)
		rounds_league_info_array = Array.new
		rts = RoundsToSeason.where(:season_id => sid)
		rts.each do |r|
			matches_info_array = Array.new
			round = Round.find(r.round_id)
			mtrs = MatchesToRound.where(round_id: round.id)

			mtrs.each do |mtr|
				match = Match.find(mtr.match_id)
				m = MatchLeagueInfo.new(round.id, match.id, match, round.round_name)
				matches_info_array.push(m)
			end
			rounds_league_info_array.push(matches_info_array)
		end
		
		return rounds_league_info_array
	end

end
