class HomeController < ApplicationController
  def login
    if auth_hash.extra.raw_info.login == (ENV['GITHUB_OWNER'] || 'sudhirj')
      session['authorized'] = true 
      render json: 'OK'
    else 
      reset_session
      render json: 'UNAUTHORIZED'
    end
  end

  def logout
    reset_session
  end

  def index
    
  end
end
