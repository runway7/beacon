class HomeController < ApplicationController
  def login
    if auth_hash.extra.raw_info.login == Rails.application.secrets.github_owner
      session[:authorized] = true
      render json: 'OK'
    else
      reset_session
      render json: 'UNAUTHORIZED'
    end
  end

  def logout
    reset_session
    redirect_to root_url
  end

  def index
    @pages = Page.all
  end

  def read
    path = params[:path]

    @page = Page.find_by(url: path)

    if @page.present?
      @title = @page.title
      return
    end

    aliased_page = Page.where('? = ANY(aliases)', path).limit(1).to_a[0]
    redirect_to(read_url(aliased_page.url), status: 301) and return if aliased_page.present?

    @pages = Page.where('? = ANY(tags)', path).to_a
    render :index and return if @pages.present?

    redirect_to root_url

  end
end
