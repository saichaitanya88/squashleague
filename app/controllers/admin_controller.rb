class AdminController < ApplicationController

	# main view for admin
	def admin_dashboard
		not_admin(cookies[:remember_token])
	end
	
	# allows user to generate a new season
	# allows user to close current season 
	# and start a new one.
	def new_season
		not_admin(cookies[:remember_token])
		@players = Player.where(:status=>"active")
		@season = Season.new
		@divisions = Division.all
	end
	
	def create_season	
		# validate Season parameters. Season name cannot be empty or duplicate. Season start cannot be in the past. 
		
		success = true
		
		grace_period = params[:grace_period]
		season_name = params[:season][:season_name]
		division_id = params[:division_id]
		matches_per_player_pair = params[:season][:matches_per_player_pair]
		
		if success
			if season_name.empty?
				success = false
				flash[:error] = "Season name cannot be nothing"
			end
		end
			
		if success
			if division_id.empty?
				success = false
				flash[:error] = "Please select a division"
			end
		end
		
		if success		
			if grace_period.empty?
				success = false
				flash[:error] = "Please enter season grace period"
			end
		end
		
		if success
			if matches_per_player_pair.empty? 
				success = false
				flash[:error] = "Please enter the number of matches per player pair"
			end
		end
		
		t = params[:season][:season_start]
		if success
			if t.empty?
				success = false
				flash[:error] = "Please select when the season starts"
			end
		end
		
		t_split = t.split('/')
		if success
			if t_split.count != 3
				success = false
				flash[:error] = "Season start date is invalid"
			end
		end
		
		if success
			season_start = Time.new(t_split[2], t_split[0], t_split[1])
			players = Array.new
		end
		
		if success
			if params[:player_id].nil? == true
				flash[:error] = "Please select at least two players"
				success = false
			end
		end
		
		if success
			params[:player_id].each do |p|
				players.push(Player.find(p[0]))
			end
		end
		
		if success
			if (players.count < 2)
				flash[:error] = "Please select at least two players"
				success = false
			end
		end
		
		if success
			if Season.find_by_season_name(season_name)
				flash[:error] = "A Season with this name already exists."
			end
			debugger
			sh = (Schedule_Helper.new).generate_schedule(players, matches_per_player_pair.to_i, grace_period.to_i, season_start, season_name, division_id.to_i)
			flash[:success] = "New Season Created!"		
		end
		
		if success
			redirect_to "/admin/admin_dashboard"
		else
			redirect_to  "/admin/new_season"	
		end
	end
	
	def manage_seasons
		not_admin(cookies[:remember_token])
		@seasons = Season.all.reverse
	end
	
	# allows user to create players (regardless of season, searchable by name)
	def new_player
		not_admin(cookies[:remember_token])
	end
	
	def create_player
		not_admin(cookies[:remember_token])
		player = Player.new(player_params)
		player.status = "active"
		success = false
		if (validate_player(player))
			if (player.save)
				flash[:success] = "Player: " + player.first_name + " " + player.last_name + " created!"
				success = true
			else
				flash[:error] = player.errors.full_messages
			end
		else
			flash[:error] = "Unable to create player! Player already exists."
		end
		
		if (success)
			redirect_to "/admin/admin_dashboard"		
		else
			redirect_to "/admin/new_player" 		
		end
	end

	def manage_players
		not_admin(cookies[:remember_token])
		@players = Player.all
	end
	
	def manage_player
		not_admin(cookies[:remember_token])
		player_update = Player.new(player_params)
		player_in_db = Player.find(params[:player][:id])
		#overwrite
		player_in_db.first_name = player_update.first_name
		player_in_db.last_name = player_update.last_name
		success = false
		
		if (player_in_db.save)
			flash[:success] = "Player: " + player_in_db.first_name + " " + player_in_db.last_name + " updated!"
			success = true
		else
			flash[:error] = player_in_db.errors.full_messages
		end
				
		if (success)
			redirect_to "/admin/admin_dashboard"		
		else
			redirect_to "/admin/new_player" 		
		end
	end
	
	
	# create or manage users
	def new_user
		not_admin(cookies[:remember_token])
		#if new user successful? - UserMailer.registration_confirmation(@user).deliver
		@user = User.new
	end
	
	def create_user
		not_admin(cookies[:remember_token])
		user = User.new(user_params)
		success = false;
		user.role = "standard"
		generated_password = (0...12).map { (65 + rand(26)).chr }.join
		user.password = generated_password
		user.password_confirmation = generated_password
		if (user.save)
			UserMailer.registration_confirmation(user, generated_password).deliver
			flash[:success] = "User: " + user.name + " Created!"
			success = true
		else
			flash[:error] = user.errors.full_messages
		end

		redirect_to "/admin/admin_dashboard"
	end
	
	def manage_users
		not_admin(cookies[:remember_token])
		@users = User.where(:role => "standard")
		@players = Player.all
	end
	
	def manage_user
		not_admin(cookies[:remember_token])
		player_in_db = Player.find(params[:user_player])
		debugger
		user = User.find(params[:user][:id])
		success = false
		# if both are not nil
		if player_in_db && user 
			if !player_in_db.user_id.nil? #if user already has a player associated with user
				flash[:error] = "Player is already associated with the user"
			else
				player_in_db.user_id = user.id
				if(player_in_db.save)
					flash[:success] = "User is linked to player"
					success = true
				else
					flash[:error] = player_in_db.errors.full_messages
				end
			end
		end
		
		redirect_to "/admin/manage_users"
		
	end

	# allows user to modify match scores (regardless of season, searchable by players and date-range)
	def match_controls
		not_admin(cookies[:remember_token])
		season_id = params[:sid]
		@season = Season.find(season_id)
		@rounds = RoundsToSeason.where(:season_id => @season.id)
		success = true
		@matches = Array.new
		if @rounds.empty?
			success = false
			flash[:error] = "No rounds exist for this season"
		end
		if success
			@rounds.each do |round|
				@matchesToRounds = MatchesToRound.where(:round_id => round.id)
				if !@matchesToRounds.empty?
					@matchesToRounds.each do |mir|
						@matches.push(Match.find(mir.match_id))
					end
				end
			end
		end
	end
	
	# allows user to modify game scores (regardless of season, searchable by players and date-range)
	# if possible use only match controls
	def game_controls
		not_admin(cookies[:remember_token])
	end

end
