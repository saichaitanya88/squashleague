class LeagueController < ApplicationController
  def home
		@current_seasons = Season.where(:season_status => "active")
		sid = params[:sid]
		@active_s = Hash.new
		if !(sid.nil? || sid.empty?)
			@player_info = generate_player_league_info(sid)
			@active_s[sid.to_i] = "active"
			@division_name = Season.find(sid).division.division_level
		else
			@player_info = Array.new
			@division_name = ""
		end
  end

  def players
  	
  end

  def schedule
  	@current_seasons = Season.where(:season_status => "active")
  	sid = params[:sid]
		@active_ri = Hash.new
		@active_s = Hash.new
		@round_info = Array.new
		@user = SessionsHelper.get_current_user(cookies[:remember_token])
		if !(sid.nil? || sid.empty?)
			@round_info = generate_round_league_info(sid)
			@active_s[sid.to_i] = "active"
			begin
				@active_ri[@round_info.first.first.round_id] = "active"
			rescue
			end
		end
  end

  def player_history
  end

  def history
  end
end
