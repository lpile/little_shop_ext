class Profile::LocationsController < ApplicationController
  def new
    @location = Location.new
    @user = current_user
  end

  def create
    @user = current_user
    @location = Location.new(location_params)
    # Update user profile address
    if @user.locations.empty?
      @user.update(address: @location.address)
      @user.update(city: @location.city)
      @user.update(state: @location.state)
      @user.update(zip: @location.zip)
    end
    @user.locations << @location
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
    @user = current_user
    @user.locations.delete(Location.find(params[:id]))
    redirect_to profile_path
  end

  private

  def location_params
    lp = params.require(:location).permit(:nickname, :address, :city, :state, :zip)
    lp.delete(:nickname) if lp[:nickname].empty?
    lp
  end
end
