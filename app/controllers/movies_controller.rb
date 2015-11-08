class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings()
    
    
    
    if params[:sortby] == nil then
      @sortby = session[:sortby]
      @redirect = true
    else
      @sortby = params[:sortby]
    end
    
    if !(params[:ratings] == nil) then
      @rating = params[:ratings].keys
    elsif session[:ratings] == nil then
      @rating = @all_ratings
      @redirect = true
    else
      @rating = session[:ratings]
      @redirect = true
    end
    
    if @redirect then 
      flash.keep
      @rating_array = Hash.new
      @rating.each { |item| @rating_array[item]=1 }
      redirect_to movies_path(:sortby => @sortby, :ratings => @rating_array)
    end
    
    @movies = Movie.order(@sortby).where rating:(@rating)
    
    session[:ratings] = @rating
    session[:sortby] = @sortby
    


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

end
