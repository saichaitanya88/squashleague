include SessionsHelper

module AdminHelper

	def not_admin(remember_token)
		if !SessionsHelper.is_admin(remember_token)
			redirect_to root_path, alert: "Action not allowed"
		end
	end

	def validate_player(player)
		# Search should not return any players from the Database
		return Player.where(first_name: player.first_name, last_name: player.last_name).count == 0
	end

	def validate_user(user)
		# Might not be required, db validation and error messages are good enough		
	end

	private

    def player_params
      params.require(:player).permit(:first_name, :last_name)
    end
    
    def user_params
      params.require(:user).permit(:name, :email)
    end

end
