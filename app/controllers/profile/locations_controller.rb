class Profile::LocationsController < ApplicationController
  def new
    @location = Location.new
    @user = current_user
  end

  def create
    @user = current_user
    @location = @user.locations.create(location_params)
    if @location.save
      flash[:success] = "Shipping location successfully added!"
      redirect_to profile_path
    else
      flash.now[:danger] = @location.errors.full_messages
      @location.update(nickname: "")
      render :new
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    @location.update(location_params)
    if @location.save
      flash[:success] = "Your location has been updated!"
      redirect_to profile_path
    else
      flash.now[:danger] = @location.errors.full_messages
      render :edit
    end
  end

  def destroy
    redirect_to profile_path
  end

  private

  def location_params
    params.require(:location).permit(:nickname, :address, :city, :state, :zip)
  end
end
