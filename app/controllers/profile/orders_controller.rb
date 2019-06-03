class Profile::OrdersController < ApplicationController
  before_action :require_reguser

  def index
    @user = current_user
    @orders = current_user.orders
  end

  def show
    if session[:update]
      @order = Order.find(session[:update])
      @address = Location.find(@order.ship_location_id)
    else
      @order = Order.find(params[:id])
      if @order.ship_location_id
        @address = Location.find(@order.ship_location_id)
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.user == current_user
      @order.order_items.where(fulfilled: true).each do |oi|
        item = Item.find(oi.item_id)
        item.inventory += oi.quantity
        item.save
        oi.fulfilled = false
        oi.save
      end

      @order.status = :cancelled
      @order.save

      redirect_to profile_orders_path
    else
      render file: 'public/404', status: 404
    end
  end

  def create
    if current_user != nil && current_user.locations.empty?
      flash[:danger] = "You need to add shipping location to your profile."
      redirect_to new_profile_location_path
    elsif current_user != nil && current_user.ship_location_id.nil?
      flash[:danger] = "Please select shipping location for your order."
      redirect_to profile_path
    else
      order = Order.create(user: current_user, status: :pending, ship_location_id: session[:ship_location_id])
      cart.items.each do |item, quantity|
        order.order_items.create(item: item, quantity: quantity, price: item.price)
      end
      session.delete(:cart)
      flash[:success] = "Your order has been created!"
      redirect_to profile_orders_path
    end
  end

  def edit
    @user = current_user
    @order = params[:id]
  end
end
