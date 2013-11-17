class MatchController < ApplicationController
  def show
  	match_id = params[:id]
  	success = true
  	
  	begin
  			@match = Match.find(match_id)
  			@games = Game.where(:match_id => match_id)
  			@user = SessionsHelper.get_current_user(cookies[:remember_token])
  	rescue Exception=> e
  			flash.keep[:error].push("Match not found")
  			success = false
  	end
  	  	
  	if !success
  		redirect_to root_path
  	end
  	
  end

  def edit
  	#debugger
  	match = Match.find(params[:id])
  	flash.keep[:error] = Array.new
		success = true
		if match.nil?
			success = false
			flash.keep[:error].push("This match cannot be found")
		end
		
		current_user = SessionsHelper.get_current_user(cookies[:remember_token])
  	if success
			if current_user.nil?
				success = false
				flash.keep[:error].push("Please log in to update score")
			end
  	end
  	
  	# if user's player is not player1 or player2, do not allow. unless user is admin
  	if success
			if current_user.role != "admin"
				if SessionsHelper.get_current_user(cookies[:remember_token]).id != Player.find(match.player1_id).user_id && SessionsHelper.get_current_user(cookies[:remember_token]).id != Player.find(match.player2_id).user_id
					success = false
					flash.keep[:error].push("You cannot update this match's scores")
				end
			end
  	end
  	
  	# if match.status is not scheduled, do not even bother
  	if success
			if !match.scheduled? && current_user.role != "admin"
				success = false
				flash.keep[:error].push("This match cannot be updated")
			end
  	end
  	
  	players_scores = Array.new
  	number_of_games = 0
  	if success
			(0..4).each do |i|  	
				player_score_pair = Player_Score_Pair.new(params[:game_p1_score][i.to_s], params[:game_p2_score][i.to_s])
				if player_score_pair.p1 != 0 && player_score_pair.p2 != 0
					number_of_games = number_of_games + 1
					players_scores.push(player_score_pair)
				end
			end
  	end
  
 	 	if success
  		if number_of_games < 3
  			success = false
				flash.keep[:error].push("Scores for three games must be submitted.")
  		end
  	end
  	
		p1_tally = 0
  	p2_tally = 0
  	if success
  		(0..4).each do |x|
  				p1_score = players_scores[x].p1.to_i
  				p2_score = players_scores[x].p2.to_i
  				
  				if p1_score == 0 && p2_score == 0
  					next 
  				end
 					if p1_score < 11 && p2_score < 11
	 					success = false
  					flash.keep[:error].push("Game scores: " + p1_score.to_s + " and " + p2_score.to_s + " are not valid scores")
  					break
 					end
 					if (p1_score >= 11 && p2_score >= 11)
 						if (p1_score - p2_score).abs != 2
							success = false
							flash.keep[:error].push("Game scores: " + p1_score.to_s + " and " + p2_score.to_s + " are not valid scores")
							break
						end
 					elsif p1_score >= 11 || p2_score >= 11
 					
 						if (p1_score > 11)
							if (p1_score - p2_score).abs != 2
								success = false
								flash.keep[:error].push( "Game scores: " + p1_score.to_s + " and " + p2_score.to_s + " are not valid scores")
								break
							end
						elsif (p2_score > 11)
							if (p1_score - p2_score).abs != 2
								success = false
								flash.keep[:error].push( "Game scores: " + p1_score.to_s + " and " + p2_score.to_s + " are not valid scores")
								break
							end
 						end
 					
						if (p1_score - p2_score).abs < 2
							success = false
							flash.keep[:error].push( "Game scores: " + p1_score.to_s + " and " + p2_score.to_s + " are not valid scores")
							break
						end
					else
						success = false
						flash.keep[:error].push("Game scores: " + p1_score.to_s + " and " + p2_score.to_s + " are not valid scores")
						break
 					end
 					
  				if (p1_score > p2_score)
	  				p1_tally = p1_tally + 1
  				else
	  				p2_tally = p2_tally + 1
  				end
  		end
  	end
  	
		# p1 or p2 has to be == 3
  	# p1 - p2 (abs) should not be greater than 3
  	# p1 + p2 should be == 5 (max)
		
  	if (p1_tally == p2_tally)
  		success = false
 			flash.keep[:error].push("Incorrect entry: game tally is invalid")
 		elsif (p1_tally + p2_tally) > 5
  		success = false
 			flash.keep[:error].push("Incorrect entry: game tally is invalid")
  	elsif ((p1_tally - p2_tally).abs > 3)
  		success = false
 			flash.keep[:error].push("Incorrect entry: game tally is invalid")
 		elsif (p1_tally != 3 && p2_tally != 3)
  		success = false
 			flash.keep[:error].push("Incorrect entry: game tally is invalid")
  	end
  	
  	game_number = 1
  	if success
  		(0..4).each do |x|
			 		#if a 4 game match was entered and a 3 game match was re-entered this will fix any additional games left over in the database
	  			if !match.games[x].nil?
		  			game_db = match.games[x]
		  			game_db.destroy 
	  			end
  				game = Game.new
	  			p1_score = players_scores[x].p1.to_i
  				p2_score = players_scores[x].p2.to_i
	  			game.player1_score = p1_score
	  			game.player2_score = p2_score
	  			if p1_score > p2_score
	  				game.game_winner_id = match.player1_id
	  			else
	  				game.game_winner_id = match.player2_id
	  			end
	  			game.game_number = game_number
	  			game.match_id = match.id
	  			game.status = "completed"
	  			
	  			if game.player1_score != 0 && game.player2_score != 0
		  			game.save
	  			end
	  			
	  			game_number = game_number + 1
  		end
  		
  		if (p1_tally > p2_tally)
  			match.winner_id = match.player1_id
  		else
  			match.winner_id = match.player2_id
  		end
  		match.status = "completed"
  		match.save
  	end
  	
  	if flash.keep[:error].length == 0
  		flash.clear
  	end
  	
  	if !success
  		redirect_to "/match/show?id=#{params[:id]}"
  	else
  	
  		season_id = RoundsToSeason.find_by_round_id(MatchesToRound.find_by_match_id(match.id).round_id).season_id
  		redirect_to "/league/schedule?sid=#{season_id}"
  	end
  end
end
