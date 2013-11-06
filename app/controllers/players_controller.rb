class PlayersController < ApplicationController
  def get_player
	  player =  Player.find(params[:id])
	  # null non-required fields for security
 
	  player.primary_image_id = nil
	  player.created_at = nil
	  player.updated_at = nil
	  
  	render json: player
  end
end
