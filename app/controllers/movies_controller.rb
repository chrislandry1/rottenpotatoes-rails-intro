class MoviesController < ApplicationController

  # See Section 4.5: Strong Parameters below for an explanation of this method:
  # http://guides.rubyonrails.org/action_controller_overview.html
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@all_ratings = ['G','PG','PG-13','R']
    @all_ratings = Movie.all_ratings
    
    #highlight code from dr. verdicchio, haml.html code from dr. v also
    @sort = params[:sort] || session[:sort]
    if @sort == 'title'
        @title_hilite = 'hilite'
        ordering = {:title => :asc}
    elsif @sort == "release_date"
        @date_hilite = 'hilite'
        ordering = {:release_date => :asc}
    end
    
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    
    #if {}, we need to create a fake ratings hash with everything "checked"
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    #if there are things in params set session to these params
    # else if params/session differ on :sort or :ratings
    if(params[:ratings] != session[:ratings]) || (params[:sort] != session[:sort])
    # store sort info into session[:sort]
    session[:sort] = @sort
    # store selected ratings into session[:ratings]
    session[:ratings] = @selected_ratings
    flash.keep
    # redirect_to index page after setting sort and ratings params
    redirect_to :sort => @sort, :ratings => @selected_ratings and return
    end
    #end
    
    #rating = params[:ratings]
    @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private :movie_params
  
end
