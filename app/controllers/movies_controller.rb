class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings()
    collection = []
    
    if(params[:ratings] != nil)
      rating_values = params[:ratings].keys
      
      Movie.ratings.each do |rating|
        session[rating] = 0
      end
      
      rating_values.each do |rating|
        session[rating] = 1
      end
    end
    
    Movie.ratings().each do |rating|
      if(session[rating] == 1)
        collection += Movie.find(:all, :conditions => ['rating = ?', rating])
      end
    end
    
    if(params[:format] == 'release_date' || params[:format] == 'title')
      session[:sort] = params[:format]
    end
    
    if(session[:sort] != nil)
      @movies = collection.sort_by {|mov| mov[session[:sort]]}
    else
      @movies = collection
    end
  end

  def new
    # default: render 'new' template
  end
  
  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
