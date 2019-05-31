class LocationsController < ApplicationController
  def new
    @location = Location.new
    @user = User.find(params[:user_id])
  end

  def create
    user = User.find(params[:user_id])
    location = user.locations.create(location_params)
    redirect_to profile_path
  end

  private

  def location_params
    params.require(:location).permit(:nickname, :address, :city, :state, :zip)
  end
end
