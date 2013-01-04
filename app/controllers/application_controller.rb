class ApplicationController < ActionController::Base  
  protect_from_forgery with: :exception

   def auth_hash
    request.env['omniauth.auth']
  end
end
