class MatchController < ApplicationController
  def show
  	match_id = params[:id]
  	success = true
  	
  	begin
  			@match = Match.find(match_id)
  			@games = Game.where(:match_id => match_id)
  	rescue Exception=> e
  			flash[:error] = "Match not found"
  			success = false
  	end
  	  	
  	if !success
  		redirect_to root_path
  	end
  	
  end

  def edit
  	#debugger
  	match = Match.find(params[:id])
		success = true
		
		if match.nil?
			success = false
			flash[:error] = "This match cannot be found"
		end
		
  	# if match.status is not scheduled, do not even bother
  	if success
			if !match.scheduled?
				success = false
				flash[:error] = "This match cannot be updated"
			end
  	end
  	
  	if success
			if SessionsHelper.get_current_user(cookies[:remember_token]).nil?
				success = false
				flash[:error] = "Please log in to update score"
			end
  	end
  	
  	# if user's player is not player1 or player2, do not allow. unless user is admin
  	if success
			if !SessionsHelper.is_admin?
				if SessionsHelper.current_user.id != Player.find(match.player1_id).user_id || SessionsHelper.current_user.id != Player.find(match.player2_id).user_id
					success = false
					flash[:error] = "You cannot update this match's scores"
				end
			end
  	end
  	
  	# check if all games exist in series. eg. Games 1 2 and 4 cannot exist without game 3 being checked.
  	games_selected = Array.new
  	players_scores = Array.new
  	number_of_games = 0
  	
  	if params[:game_selected].nil?
  		success = false
  		flash[:error] = "Scores for three games must be submitted."
  	end
  	
  	if success
			(0..4).each do |i|  	
				game_selected = params[:game_selected][(i).to_s]
				player_score_pair = Player_Score_Pair.new(params[:game_p1_score][i.to_s], params[:game_p2_score][i.to_s])
				if !game_selected.nil?
					number_of_games = number_of_games + 1
				end
				games_selected.push(game_selected)
				players_scores.push(player_score_pair)
			end
  	end
  	if success
  		if number_of_games < 3
  			success = false
				flash[:error] = "Scores for three games must be submitted."
  		end
  	end
  	
  	if success
			(1..4).to_a.reverse.each do |x|
				if (games_selected[x] == "on" && games_selected[x-1] == nil)
					success = false
					flash[:error] = "Please ensure that all checkboxes are added correctly."
				end
			end
  	end
  	
  	# game score rules: 
  	# 	if both games are greater than 10, the difference between two games must be 2 exactly.
  	# 	if 1 game has a score greater than 11, then the second game has to be atleast 10.
  	# 	1 game has to be atleast equal to 11 
  	#	if all are true, then allow games to be saved.
  	
  	if success
  		(0..4).each do |x|
  			if games_selected[x] == "on"
  				p1_score = players_scores[x].p1.to_i
  				p2_score = players_scores[x].p2.to_i
  				if (p1_score - p2_score).abs > 2
  					if !(p1_score == 11 || p2_score == 11)
  						success = false
  						flash[:error] = "Game scores: " + p1_score.to_s + " and " + p2_score.to_s + " are not valid scores"
  						break
  					end
  				elsif (p1_score - p2_score).abs == 2
  					if !(p1_score >= 10 || p2_score >= 10)
  						success = false
  						flash[:error] = "Game scores: " + p1_score.to_s + " and " + p2_score.to_s + " are not valid scores"
  						break
  					end
  				else	
  					success = false
 						flash[:error] = "Game scores: " + p1_score.to_s + " and " + p2_score.to_s + " are not valid scores"
 						break
  				end
  			end
  		end
  	end
  	
  	game_number = 1
  	if success
  		(0..4).each do |x|
	  		if games_selected[x] == "on"
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
	  			game.save
	  			game_number = game_number + 1
	  		end
  		end
  		
  		match.status = "completed"
  	end
  	
  	redirect_to "/match/show?id=3"
  end
end
