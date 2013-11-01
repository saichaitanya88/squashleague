class UsersController < ApplicationController
  def login
  end
  
  def signup
	  @user = User.new
  end
  
	def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
      flash[:success] = "Welcome to the Sample App!"
      redirect_to controller: 'home', action: 'index'
    else
	    @errors = @user.errors.full_messages
      render 'signup'
    end
  end
  
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

  
end
