class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:spotify]

  #this method checks to see if provider and uid strings exist in the database. if they don't itll create them with a random password
  def self.from_omniauth(auth)
  	where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  		user.provider = auth.provider
  		user.uid = auth.uid
  		user.email = auth.info.email
  		user.password = Devise.friendly_token[0,20]
  	end
  end

  #copies info from spotify to createa a new user with session
  def self.new_with_session(params,session)
  	super.tap do |user|
  		if data = session["devise.spotify_data"] && session["devise.spotify_data"]["extra"]["raw_info"]
  			user.email = data["email"]	if user.email.blank?
  		end
  	end
  end

end
