require 'league_helper.rb'

class ScheduledTasksHelper
include LeagueHelper

# (ScheduledTasksHelper.new).league_round_update
	def initialize
	end
	# for each division
	# 	for each active season
	# 		for each round in season
	#				If round.round_start == today
	#					Send email to all player(users) with 
	def league_round_update	
		time = Date.parse("2013-12-09") #(Time.now.strftime('%Y-%m-%d'))
		active_seasons = Season.where(:season_status => "active")
		active_seasons.each do |season|
			rounds = season.get_rounds_in_season
			next_round = nil
			all_past_rounds = Array.new
			past_round = nil
			rounds.each do |round|
				if round.round_start == time
					next_round = round.clone
				end
				if round.round_end == time
					past_round = round.clone
				end
				if round.round_end <= time
					all_past_rounds.push(round.clone)
				end
			end
			
			if next_round.nil? && past_round.nil?
				next
			end
		
			#else, there is something worth reporting in the notification email.
			puts "all_past_rounds: \n" + all_past_rounds.to_json
			puts "next_rounds: \n" + next_round.to_json
			puts "past_round: \n" + past_round.to_json
			
			email_addresses = Array.new
			players_in_season = PlayersToSeason.where(:season_id => season.id)		
		
			players_in_season.each do |ps|
				player = Player.find(ps.player_id)
				if !player.user.email.to_s.empty?
					email_addresses.push(player.user.email.to_s)
				end
			end
			
			incomplete_matches = Array.new
			all_past_rounds.each do |round|
				round.incomplete_matches.each do |match|
					incomplete_matches.push(match)
				end
			end
			
			puts "incomplete_matches: \n" + incomplete_matches.to_json
			
			players_league_info_array = generate_player_league_info(season.id)
			puts "players_league_info_array: \n" + players_league_info_array.to_json
			
			if players_league_info_array.count == 0 
				players_league_info_array = nil
			end
			
			UserMailer.weekly_update_email(all_past_rounds, incomplete_matches, past_round, next_round, players_league_info_array, email_addresses).deliver
		end
	end
	
	
	##Backup


end
