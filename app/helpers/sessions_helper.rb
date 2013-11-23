module SessionsHelper

	def sign_in(user)
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

	def signed_in?
    !current_user.nil?
  end

	def current_user=(user)
    @current_user = user
  end

	def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

	def get_current_user(remember_token)
    remember_token = User.encrypt(remember_token)
    #@current_user ||=
    user_to_return = User.find_by(remember_token: remember_token)
    if (user_to_return != nil)
    	return user_to_return.reload
    end
    return user_to_return
  end

	def sign_out (remember_token)
		self.current_user = nil
		remember_token = User.encrypt(cookies[:remember_token])
		user = User.find_by(remember_token: remember_token)
		user.update_attribute(:remember_token, "")
    cookies.delete(:remember_token)
	end

	def is_admin?
		@current_user.role == "admin"
	end

	def cu_is_admin?
		current_user.role == "admin"
	end

	def is_admin(remember_token)
	
		remember_token = User.encrypt(remember_token)
		current_user ||= User.find_by(remember_token: remember_token)
		if current_user
	    return	current_user.role == "admin"	
		else
			return false
		end
	end

	def user_exists(remember_token)
		remember_token = User.encrypt(remember_token)
		current_user ||= User.find_by(remember_token: remember_token)
		return !current_user.nil?
	end
	
	def user_can_edit_match(match_id, user)
			
		if user.nil?
			return false
		end
			
		if user.role == "admin"
			return true
		end
		
		match = Match.find(match_id)
		if (Match.find(match_id).status != "scheduled")
			return false
		end
	
		player = Player.find_by_user_id(user.id)
		if player.nil? 
			return false
		end
		
		if player.id == match.player1_id || player.id == match.player2_id
			return true
		end
		
		return false
		
	end

end
