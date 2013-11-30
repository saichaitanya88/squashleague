require 'io/console'

class Schedule_Helper
	
	def initialize 
	end
	
	def generate_schedule (players, number_of_repeats, grace_period, season_start_date, season_name, division_id)
		# number of repeats determines how many "legs" the league tournament has
		# serves as a limit for number of rounds
		number_of_rounds = ((players.count - 1) * number_of_repeats) + grace_period
		
		legs = number_of_repeats
		puts "Generating matches_list_master"
		matches_list_master = generate_matches_prelim(players, number_of_repeats)
		puts "DONE Generating matches_list_master"
		
		puts "Generating all_rounds"
		all_rounds = generate_rounds(matches_list_master)
		puts "DONE Generating all_rounds"
		puts JSON.pretty_generate(all_rounds)
		
		compressed_rounds = compress_rounds(all_rounds, number_of_rounds)
		puts "Round Compression Complete"
		puts JSON.pretty_generate(compressed_rounds)
		puts "Randomized Compressed Rounds"
		complete_compressed_rounds = generate_complete_rounds(compressed_rounds, number_of_repeats)
		create_database_entries(complete_compressed_rounds, season_start_date, number_of_rounds, number_of_repeats,season_name, division_id, players)
		
	end
	
	def generate_complete_rounds(compressed_rounds, number_of_repeats)
		complete_compressed_rounds = Array.new
		(0..number_of_repeats-1).each do |rep|
			shuffled_rounds = compressed_rounds.shuffle
			shuffled_rounds.each do |cr|
				complete_compressed_rounds.push(cr)
			end
		end
		return complete_compressed_rounds
	end
	
	def create_database_entries(compressed_rounds, season_start_date, number_of_rounds, number_of_repeats, season_name, division_id, players)
	
		db_season = Season.new
		db_season.season_start = season_start_date
		db_season.season_end = season_start_date + weeks_to_seconds(number_of_rounds)
		db_season.matches_per_player_pair = number_of_repeats
		db_season.season_name = season_name
		db_season.season_status = "active"
		db_season.save
		
		puts "players to season"
		
		players.each do |player|
			pts = PlayersToSeason.new
			pts.status = "active"
			pts.season_id = db_season.id
			#debugger
			pts.player_id = player.id
			pts.save
		end
		
		
		puts "Create Season"
		
		db_season_to_division = SeasonsToDivision.new
		db_season_to_division.division_id = division_id
		db_season_to_division.season_id = db_season.id
		db_season_to_division.save
		
		r = 1
		m = 1
		
		compressed_rounds.each do |round|

			db_round = Round.new
			db_round.round_name = "Round #{r}"
			db_round.round_order = r
			db_round.round_start = season_start_date  + weeks_to_seconds(r-1)
			db_round.round_end = season_start_date  + weeks_to_seconds(r)
			db_round.status = "scheduled"
			db_round.save
			puts "Create round: #{r}"
			
			db_rounds_to_season = RoundsToSeason.new
			db_rounds_to_season.round_id = db_round.id
			db_rounds_to_season.season_id = db_season.id
			db_rounds_to_season.status = "active"
			db_rounds_to_season.save
			puts "Create RoundsToSeason entry for round #{r} and season #{db_season.id}"
			
			round.each do |match|
				db_match = Match.new
				db_match.player1_id = match.player1
				db_match.player2_id = match.player2
				db_match.status = "scheduled"
				db_match.save
				puts "Create Match #{m} for #{match.player1} and #{match.player2}"
				
				db_match_to_round = MatchesToRound.new
				db_match_to_round.match_id = db_match.id
				db_match_to_round.round_id = db_round.id
				db_match_to_round.status = "active"
				db_match_to_round.save
				puts "Create MatchesToRound entry for round #{r} and match #{m}"
				m = m + 1
			end
			r = r + 1
		end
	
	end
	
	def compress_rounds(all_rounds, number_of_rounds)

		if (all_rounds.count < number_of_rounds)
			return all_rounds
		end

		#slice rounds into number_of_rounds length, add them in a loop to compress_rounds
		sliced_rounds = all_rounds.each_slice(number_of_rounds)
		compressed_rounds = Array.new
		puts "STARTED Adding sliced rounds"

		compressed_hash = Hash.new
		
		(0..number_of_rounds-1).each do |i|
			matches_in_round = Array.new
			sliced_rounds.each do |f_rounds|
				rounds = f_rounds.to_a[i]
				if rounds
				puts "printing rounds"
				puts JSON.pretty_generate(rounds)	
					rounds.each do |match|
						matches_in_round.push(match)
					end
				end
			end
			puts "printing matches"
			puts JSON.pretty_generate(matches_in_round)	
			compressed_rounds.push(matches_in_round)
		end
		
		puts "DONE Adding sliced rounds"
		puts JSON.pretty_generate(compressed_rounds)	
		return compressed_rounds
	end
	
	def generate_matches_prelim(players, repeats)
		matches_list_master = Array.new
		matches_generated = 0
		(0..repeats-1).each do |i|
			matches_list = Array.new
			(0..players.count-1).each do |p|
				(p+1..players.count-1).each do |px|
					matches_list.push(Player_Pair.new( players[p].id, players[p].id, players[px].id))
					matches_generated = matches_generated + 1
					puts "Generating Match #{matches_generated} for players #{p+1} and #{px+1}"
				end
			end
			matches_list_master.push(matches_list)
		end
		#puts JSON.pretty_generate(matches_list_master)
		return matches_list_master
	end
	
	def generate_rounds(matches_list_master)
		# matches_list_master is an ARRAY of an ARRAY of Player_Pair

		if (matches_list_master.count <= 0)
			return Array.new
		end
		
		matches_master = matches_list_master.first
		puts "started loop"
		rounds = Array.new
		round = Array.new
		rounds.push(round)
		keys = get_keys(matches_master)
		matches = matches_master
		while true do
		 	#debugger ###
			if matches.count == 0
				#debugger
		 		break
			end
		 	rounds.each do |r|
			 	if matches.count == 0
					#debugger
			 		break
				end
			 	rounds = insert_match_into_round(matches.first, rounds)
			 	matches = matches.drop(1)

			 	#puts "ROUNDS"
			 	#puts JSON.pretty_generate(rounds)
			 	#puts "MATCHES"
			 	#puts JSON.pretty_generate(matches)
			end
		end
		
		#debugger
		#puts "DONE"
		#puts "HERE ARE ALL THE ROUNDS"
		#puts JSON.pretty_generate(rounds)
		
		
		return rounds
	end
	
	def insert_match_into_round(match, rounds)
		must_insert_new_round_for_match = true
		rounds.each do |round|
			if !round_contains(match.player1, match.player2, round)
				round.push(match)
				must_insert_new_round_for_match = false
				break
			end
		end
		
		if must_insert_new_round_for_match
			#create a new round into rounds
			round = Array.new
			round.push(match)
			rounds.push(round)
		end
		
		return rounds
	end
	
	def round_contains(p1, p2, round)
		begin
			round.each do |match|
				if (match.player1 == p1 || match.player2 == p1 || match.player1 == p2 || match.player2 == p2)
					return true
				end
			end
			return false
		rescue
			#debugger
			return false
		end
	end
		
	def get_keys(matches)
		keys = Array.new
		matches.each do |m|
			if !keys.include? m.key
				keys.push(m.key)
			end			
		end
		return keys
	end

	def weeks_to_seconds(number_of_rounds)
		return (number_of_rounds*7*24*60*60)
	end
	
end
