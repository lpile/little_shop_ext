require 'rails_helper'

RSpec.describe 'Delete shipping location,', type: :feature do
  before :each do
    @user = create(:user)
    @location_1 = create(:location, user: @user)
    @location_2 = create(:location, user: @user)
    @location_3 = create(:location, user: @user)
    @user.update(ship_location_id: @location_1.id)

    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @inventory_level = 20
    @purchased_amount = 5
    @item_1 = create(:item, user: @merchant_1)
    @item_2 = create(:item, user: @merchant_2, inventory: @inventory_level)

    @order_1 = create(:order, user: @user, created_at: 1.day.ago, ship_location_id: @location_1.id)
    @oi_1 = create(:order_item, order: @order_1, item: @item_1, price: 1, quantity: 1, created_at: 1.day.ago)

    @order_2 = create(:packaged_order, user: @user, created_at: 1.day.ago, ship_location_id: @location_2.id)
    @oi_1 = create(:order_item, order: @order_2, item: @item_1, price: 1, quantity: 1, created_at: 1.day.ago)
    @oi_2 = create(:fulfilled_order_item, order: @order_2, item: @item_2, price: 2, quantity: @purchased_amount, created_at: 1.day.ago, updated_at: 2.hours.ago)

    @order_3 = create(:shipped_order, user: @user, created_at: 1.day.ago, ship_location_id: @location_3.id)
    @oi_1 = create(:fulfilled_order_item, order: @order_3, item: @item_1, price: 1, quantity: 1, created_at: 1.day.ago, updated_at: 5.hours.ago)
    @oi_2 = create(:fulfilled_order_item, order: @order_3, item: @item_2, price: 2, quantity: 1, created_at: 1.day.ago, updated_at: 2.hours.ago)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it "user can delete shipping location" do
    visit profile_path

    within("#location-#{@location_1.id}") do
      click_link "Delete"
    end

    expect(current_path).to eq(profile_path)
    expect(page).to_not have_content(@location_1.nickname)
    expect(page).to have_content("Your location has been deleted!")
    expect(page).to have_content(@location_2.nickname)
  end

  describe 'as a user trying to delete shipping address' do
    it 'should be successful if order status is pending' do
      visit profile_path

      within("#location-#{@location_1.id}") do
        click_on "Delete"
      end

      expect(page).to have_content("Your location has been deleted!")
      expect(current_path).to eq(profile_path)
      expect(page).to_not have_content(@location_1.nickname)
    end

    it 'should not be successful if order status is packaged' do
      visit profile_path

      within("#location-#{@location_2.id}") do
        click_on "Delete"
      end

      expect(page).to have_content("Your location cannot to be deleted for completed order!")
      expect(current_path).to eq(profile_path)
      expect(page).to have_content(@location_2.nickname)
    end

    it 'should not be successful if order status is shipped' do
      visit profile_path

      within("#location-#{@location_3.id}") do
        click_on "Delete"
      end

      expect(page).to have_content("Your location cannot to be deleted for completed order!")
      expect(current_path).to eq(profile_path)
      expect(page).to have_content(@location_3.nickname)
    end
  end
end
