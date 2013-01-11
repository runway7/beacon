class HomeController < ApplicationController
  def login
    if auth_hash.extra.raw_info.login == ENV['GITHUB_OWNER']
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
    @pages = Page.all    
  end

  def read 
    path = params[:path]

    @page = Page.find_by(url: path)
    return if @page.present?
    
    aliased_page = Page.where('? = ANY(aliases)', path).limit(1).to_a[0]
    redirect_to(read_url(aliased_page.url), status: 301) and return if aliased_page.present?
    
    @pages = Page.where('? = ANY(tags)', path).to_a
    render :index and return if @pages.present?

    redirect_to root_url
    
  end
end
