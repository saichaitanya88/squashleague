module MatchHelper

	def self.do_stuff
		get_match_post_content(Player.find(1), Player.find(9), Match.find(1))
	end

	def self.get_match_post_content(player1, player2, match)
		winner = Player.find(match.winner_id)
		if player1.id == winner.id
			loser = player2
		else
			loser = player1
		end
		s1 = "#{winner.full_name_abbr} beats #{loser.full_name_abbr} in #{match.games.count} games: "
		s2 = ""
		match.games.each do |game|
			s2 = s2 + "#{game.player1_score}-#{game.player2_score},"
		end
		
		s2 = s2.chop
		
		player_table = generate_player_league_info(RoundsToSeason.find_by_round_id(MatchesToRound.find_by_match_id(match.id).round_id).season_id)
		sorted_player_table = player_table.sort { |x,y| y.league_points_for <=> x.league_points_for }

		winner_player = sorted_player_table.find { |s| s.player_id == winner.id }
		winner_position = sorted_player_table.index(winner_player) + 1
		loser_player = sorted_player_table.find { |s| s.player_id == loser.id }
		loser_position = sorted_player_table.index(loser_player) + 1
		
		s3 = ". With this victory, #{winner.first_name} moves to #{winner_position.ordinalize} place with #{winner_player.league_points_for} points. Having lost the game #{loser.first_name} moves to #{loser_position.ordinalize} place with #{loser_player.league_points_for} points."
		
		content = s1 + s2 + s3
		
		return content
	end
	
	def self.get_player_points_and_position(player, match)
		#figure out season
		season_id = RoundsToSeason.find_by_round_id(MatchesToRound.find_by_match_id(1).round_id).season_id
		#figure out position
		players_league_info_array = generate_player_league_info(season_id)
		puts players_league_info_array.to_json
		# sort based on points per player
		#  array.sort { |x,y| x.league_points_for <=> y.league_points_for }
		
		# return player_position;player_points
		
	end
	
	def self.generate_player_league_info(season_id)
		players_league_info_array = Array.new
		pts = PlayersToSeason.where(:season_id => season_id)

		#puts "ALL PLAYERS IN SEASON " + pts.to_json

		pts.each do |p|
			player = Player.find(p.player_id)
			#puts "PLAYER " + player.to_json
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
				
	  		if (season.id.to_s != season_id.to_s)
		  		next
	  		end
				#puts "MATCHES " + match.games.to_json
	  		match.games.each do |game|
					if game.game_winner_id == player.id
						player_league_info.set_league_points_for(player_league_info.league_points_for + 1)
					else
						player_league_info.set_league_points_against(player_league_info.league_points_against + 1)
					end					
	  		end
	  	end
			#puts "PLAYER LEAGUE INFO " + player_league_info.to_json
	  	players_league_info_array.push(player_league_info)
  	end

		return players_league_info_array
	end
	
end
