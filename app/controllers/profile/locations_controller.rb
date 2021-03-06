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
    @user = current_user
    @location = Location.find(params[:id])
    unless @user.check_pending_orders?(@location)
      flash[:danger] = "Your location cannot to be edited for completed order!"
      redirect_to profile_path
    end
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
    @location = Location.find(params[:id])
    if @user.check_pending_orders?(@location)
      @user.locations.delete(@location)
      flash[:success] = "Your location has been deleted!"
    else
      flash[:danger] = "Your location cannot to be deleted for completed order!"
    end
    redirect_to profile_path
  end

  def change
    @order = Order.find(params[:id])
    @user = current_user
    if @order.status == 'pending'
      @order.update(ship_location_id: params[:location_id])
      @user.update(ship_location_id: params[:location_id])
      session[:update] = @order.id
      flash[:success] = "Shipping location has successfully changed."
    end
    redirect_to profile_order_path(@order)
  end

  private

  def location_params
    lp = params.require(:location).permit(:nickname, :address, :city, :state, :zip)
    lp.delete(:nickname) if lp[:nickname].empty?
    lp
  end
end
