module SessionsHelper

	def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
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
    @current_user ||= User.find_by(remember_token: remember_token)
  end

	def sign_out
		self.current_user = nil
    cookies.delete(:remember_token)
	end

	def is_admin?
		@current_user.role == "admin"
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

end
