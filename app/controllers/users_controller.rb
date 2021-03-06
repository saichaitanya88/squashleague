class UsersController < ApplicationController
  def login
  end
  
  def signup
	  @user = User.new
  end
  
#	def create
#    @user = User.new(user_params)
#    @user.role = "standard"
#    if @user.save
#      # Handle a successful save.
#      sign_in @user
#      flash.keep[:success] = "Welcome to the Sample App!"
#      redirect_to controller: 'home', action: 'index'
#    else
#	    @errors = @user.errors.full_messages
#      render 'signup'
#    end
#  end
  
  def dashboard_main
  	user = SessionsHelper.get_current_user(cookies[:remember_token])
  	player = Player.find_by_user_id(user.id)
  	@players_matches = Array.new
  	if !player.nil? 
  		players_matches1 = Match.where(:player1_id => player.id).where(:status => "scheduled")
			players_matches2 = Match.where(:player2_id => player.id).where(:status => "scheduled")
			@players_matches = players_matches1 + players_matches2
		else
			flash.now[:warning] = "No matches found. If this information is incorrect, please contact the Admin."
  	end
  	
  end
  
	def get_user
		user =  User.find(params[:id])
		player = Player.find_by_user_id(user.id)
	  user_player = User_Player.new(user, player)
	  
	  # null non-required fields for security	using .for_display
  	render json: user_player.for_display
	end
  
  def settings
  	# allows users to change username, player name, bio, and image url
  	@user = SessionsHelper.get_current_user(cookies[:remember_token])
  	@player = Player.find_by_user_id(@user.id)

  	if @player.nil?
 	  	flash.now[:error] = "Player to User relationship does not exist. Please contact Admin."
  		@player = Player.new
  	end
  end
  
  def update_details
  	# take username, player first and last name. player image url, player bio and update.
  	
  	#username cannot be null, and must be unique
  	# first name cannot be null
  	# last name cannot be null
  	
  	@user = SessionsHelper.get_current_user(cookies[:remember_token])
  	username = params[:username]
  	player_first_name = params[:player_first_name]
  	player_last_name = params[:player_last_name]
  	player_image_url = params[:player_image_url]
  	player_bio = params[:player_bio]
  	pass = params[:password]
  	errors = Array.new
  	
  	@player = Player.find_by_user_id(@user.id)
  	
  	if @player.nil?
			errors.push("Player is not associated with the user")  	
  	else
			@player.first_name = player_first_name
			@player.last_name = player_last_name
			@player.player_image_url = player_image_url
			@player.bio = player_bio
			  	
			if !@player.save
				@player.errors.full_messages.each do |err|
					errors.push(err)
				end
			end
  	
  	end
  	
  	
  	if errors.length > 0
  		flash.keep[:error] = errors
  	else
	  	flash.keep[:success] = "Settings Changed"
  	end
  	
  	redirect_to "/users/settings"
  end
  
  def update_password
  	# take username, player first and last name. player image url, player bio and update.
  	
  	# username cannot be null, and must be unique
  	# first name cannot be null
  	# last name cannot be null
  	
  	user = SessionsHelper.get_current_user(cookies[:remember_token])
  	errors = Array.new
  	
  	if !user.authenticate(params[:password])
  		errors.push("Invalid Password")
  	end
  	
  	user.password = params[:new_password]
  	user.password_confirmation = params[:new_password_confirmation]
	  debugger
	  if !user.save
	  	user.errors.full_messages.each do |message|
	  		errors.push(message)
	  	end
	  end
	  
  	if errors.length > 0
  		flash.keep[:error] = errors
  	else
	  	flash.keep[:success] = "Your password has been changed"
  	end
  	
  	redirect_to "/users/settings"
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

  
end
