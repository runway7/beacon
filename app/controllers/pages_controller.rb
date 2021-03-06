class PagesController < ApplicationController
  before_filter :auth_check
  layout "admin"

  def auth_check
    if session[:authorized] != true
      render(text: 'BUGGER OFF.',  status: 403) and return
    end
  end

  def index
    @pages = Page.all
  end

  def new
    @page = Page.new
  end

  def create
    Page.create! page_params
    redirect_to :pages
  end

  def edit
    @page = Page.find_by id: params[:id]
    render :new
  end

  def update
    page = Page.find_by id: params[:id]
    page.update_attributes(page_params)    
    redirect_to :pages
  end
    
  private 

  def page_params
    params.require(:page).permit(:title, :url, :description, :source, :tags_display, :aliases_display)
  end
end
