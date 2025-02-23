class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
    # breweries = Brewery.all
    @top_breweries = Brewery.top 3
    @top_beers = Beer.top 3
    @top_styles = Style.top 3
    @recent_ratings = Rating.recent
    @active_users = User.most_active 5
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    # otetaan luotu reittaus muuttujaan
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    # talletetaan tehty reittaus sessioon
    @rating.user = current_user
    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
