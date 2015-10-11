class MoviesController < ApplicationController

  # See Section 4.5: Strong Parameters below for an explanation of this method:
  # http://guides.rubyonrails.org/action_controller_overview.html
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    rating = params[:rating]
    @movie = Movie.find(id) # look up movie by unique ID
    @movie = Movie.find(rating)
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    #@all_ratings = Movie.all_ratings
    
    #highlight code from dr. verdicchio, haml.html code from dr. v also
    @sort = params[:sort]
    if @sort == 'title'
        @title_hilite = 'hilite'
    elsif @sort == "release_date"
        @date_hilite = 'hilite'
    end
    
    
    #rating = params[:rating]
    #@movies = Movie.all
    #http://railscasts.com/episodes/228-sortable-table-columns?view=asciicast
    #@movies = Movie.order(params[:sort])
    #we need to sort this instead of returning everything using .where
    #@movies = Movie.where(rating: @selected_ratings)
    @movies = Movie.where(rating: 'G')
    #need to use hash to deal with multiple boxes checked
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
