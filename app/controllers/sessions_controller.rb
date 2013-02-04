class SessionsController < ApplicationController
  def new
  end
  
  def create
    auth_hash = request.env['omniauth.auth']
    #render text: auth_hash.inspect  
    if auth_hash
      provider = auth_hash["provider"]
      uid = auth_hash["uid"]
      @authentication = Authentication.find_by_provider_and_uid(provider, uid)
      if provider == "facebook"
        email = auth_hash["info"]["email"] if auth_hash["info"]["email"]
        realname = auth_hash["info"]["name"] if auth_hash["info"]["name"]
        username = auth_hash["info"]["username"] if auth_hash["info"]["username"]
        location = auth_hash[:extra][:raw_info][:location][:name] if auth_hash[:extra][:raw_info][:location] 
      end
      if @authentication
        user = @authentication.user
      else
        user = User.find_by_email(email)
      end
      if user
        user.update_attributes(email: email,
                               realname: realname,
                               location: location)
      else
        user = User.create!(email: email,
                            username: username,
                            realname: realname,
                            location: location,
                            password: SecureRandom.urlsafe_base64)
        authentication = user.authentications.build(provider: provider,
                                                    uid: uid)
        authentication.save
      end
      log_in user
      redirect_back_or root_path      
    else
    	user = User.find_by_email(params[:session][:email])
    	if user && user.authenticate(params[:session][:password])
    	  log_in user
        redirect_back_or root_path
    	else
    	  flash.now[:error] = 'Invalid email/password combination'
    	  render 'new'
    	end
    end
  end

  def destroy
  	log_out
  	redirect_to root_path
  end
end
