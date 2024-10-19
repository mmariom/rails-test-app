class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    @reviews = Review.all.includes(:movie, :user)
  end

  def create
    
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.build(review_params)
    @review.user = current_user
  
    if @review.save
      redirect_to @movie, notice: 'Review was successfully created.'
    else
      flash.now[:alert] = 'There was a problem adding your review.'
      render 'movies/show'
    end
  end
  

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
