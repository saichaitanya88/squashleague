class SessionsController < ApplicationController
	def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
		  # Sign the user in and redirect to the user's show page.
		  sign_in user
      redirect_to controller: 'home', action: 'index'
		else
		  flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
		end
  end

  def destroy
    sign_out (cookies[:remember_token])
    redirect_to root_url
  end
  
end
