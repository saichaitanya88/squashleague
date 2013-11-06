class User_Player
	def initialize (user, player)
		@user = user
		@player = player
	end

	def for_display
		user_d = @user
		user_d.password_digest = nil
		user_d.remember_token = nil
		user_d.role = nil

		player_d = @player	
		if (player_d) #continue if not nil
			player_d.primary_image_id = nil
		end
		user_player_for_display = User_Player.new(user_d,player_d)
			  
	  return user_player_for_display
	end

end
