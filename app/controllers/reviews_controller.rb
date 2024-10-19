class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_movie
  before_action :set_review, only: [:destroy]
  before_action :authorize_user!, only: [:destroy]

  def index
    @reviews = Review.all.includes(:movie, :user)
  end

  def create
    @review = @movie.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @movie, notice: 'Review was successfully created.'
    else
      flash.now[:alert] = 'There was a problem adding your review.'

      @reviews = @movie.reviews.includes(:user)
      
      render 'movies/show', status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to @movie, notice: 'Your review was successfully deleted.'
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def set_review
    @review = @movie.reviews.find(params[:id])
  end

  def authorize_user!
    unless @review.user == current_user
      redirect_to @movie, alert: 'You are not authorized to delete this review.'
    end
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
