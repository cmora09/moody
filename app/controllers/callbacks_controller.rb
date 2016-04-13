class CallbacksController < ApplicationController
  def spotify
  	# this is grabbing the .from_omniauth method from our User model where it's self.from_omniauth
  	@user = User.from_omniauth(request.env["omniauth.auth"])
  	# checks to see if user exists in database.
  	if @user.persisted?
  		#if valid user is found itll sign in and redirect user
  		sign_in_and_redirect '/', :event => :authentication
  		set_flash_message(:notice, :success, :kind => "Spotify") if is_navigational_format?
  	else
  		#request.env["omniauth.auth"] grants info as a hash from spotify
  		session["devise.spotify_data"] = request.env["omniauth.auth"]
  		redirect_to new_user_registration_url
  	end
  end
  
  def failure
  	redirect_to root_path
  end
end
