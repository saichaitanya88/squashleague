class UsersController < ApplicationController
  def login
  end
  
  def signup
	  @user = User.new
  end
  
	def create
    @user = User.new(user_params)
    @user.role = "standard"
    if @user.save
      # Handle a successful save.
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to controller: 'home', action: 'index'
    else
	    @errors = @user.errors.full_messages
      render 'signup'
    end
  end
  
  def dashboard_main
  
  end
  
	def get_user
		user =  User.find(params[:id])
		player = Player.find_by_user_id(user.id)
	  user_player = User_Player.new(user, player)
	  
	  # null non-required fields for security	using .for_display
  	render json: user_player.for_display
	end
  
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

  
end
