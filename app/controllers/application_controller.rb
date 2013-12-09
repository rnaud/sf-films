class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def home
  end


  def search
    if params[:q]
      @results = PgSearch.multisearch(params[:q]).map(&:searchable)
    else
      @results = Movie.all
      @results = @results + Producer.all
      @results = @results + Director.all
    end
    
    respond_to do |format|
      format.json
    end
  end
end
