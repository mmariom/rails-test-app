class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
    @review = Review.new
    @reviews = @movie.reviews.includes(:user)
  end
  
  

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.find_by(title: movie_params[:title])
  
    unless @movie
      api_key = ENV['OMDB_API_KEY'] || 'fe715eef' 
      response = HTTParty.get("http://www.omdbapi.com/", query: { t: movie_params[:title], apikey: api_key })
      data = response.parsed_response
      Rails.logger.debug "OMDb API Response: #{data.inspect}"
  
      if data['Response'] == 'True'
        @movie = Movie.new(
          title: data['Title'],
          year: data['Year'],
          imdb_id: data['imdbID']
        )
        if @movie.save
          redirect_to @movie, notice: 'Movie was successfully added.'
        else
          flash.now[:alert] = 'There was a problem adding the movie.'
          render :new
        end
      else
        flash.now[:alert] = "Movie not found: #{data['Error']}"
        @movie = Movie.new
        render :new
      end
    else
      redirect_to @movie, notice: 'Movie already exists.'
    end
  end
  
  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def movie_params
    params.require(:movie).permit(:title)
  end
end
