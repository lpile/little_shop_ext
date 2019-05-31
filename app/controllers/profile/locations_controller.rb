class Profile::LocationsController < ApplicationController
  def new
    @location = Location.new
    @user = current_user
  end

  def create
    user = current_user
    location = user.locations.create(location_params)
    if location.save
      flash[:success] = "Shipping location successfully added!"
      redirect_to profile_path
    else
      flash.now[:danger] = user.errors.full_messages
      render :new
    end
  end

  def edit
    redirect_to profile_path
  end

  def update
    redirect_to profile_path
  end

  def destroy
    redirect_to profile_path
  end

  private

  def location_params
    params.require(:location).permit(:nickname, :address, :city, :state, :zip)
  end
end
