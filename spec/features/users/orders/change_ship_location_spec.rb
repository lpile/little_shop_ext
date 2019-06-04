require 'rails_helper'

RSpec.describe 'User change shipping location', type: :feature do
  before :each do
    @user = create(:user)
    @location_1 = create(:location, user: @user)
    @location_2 = create(:location, user: @user)
    @user.update(ship_location_id: @location_1.id)

    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @inventory_level = 20
    @purchased_amount = 5
    @item_1 = create(:item, user: @merchant_1)
    @item_2 = create(:item, user: @merchant_2, inventory: @inventory_level)

    @order_1 = create(:order, user: @user, created_at: 1.day.ago, ship_location_id: @location_1.id)
    @oi_1 = create(:order_item, order: @order_1, item: @item_1, price: 1, quantity: 1, created_at: 1.day.ago)

    @order_2 = create(:packaged_order, user: @user, created_at: 1.day.ago, ship_location_id: @location_1.id)
    @oi_1 = create(:order_item, order: @order_2, item: @item_1, price: 1, quantity: 1, created_at: 1.day.ago)
    @oi_2 = create(:fulfilled_order_item, order: @order_2, item: @item_2, price: 2, quantity: @purchased_amount, created_at: 1.day.ago, updated_at: 2.hours.ago)

    @order_3 = create(:shipped_order, user: @user, created_at: 1.day.ago, ship_location_id: @location_1.id)
    @oi_1 = create(:fulfilled_order_item, order: @order_3, item: @item_1, price: 1, quantity: 1, created_at: 1.day.ago, updated_at: 5.hours.ago)
    @oi_2 = create(:fulfilled_order_item, order: @order_3, item: @item_2, price: 2, quantity: 1, created_at: 1.day.ago, updated_at: 2.hours.ago)
  end

  describe 'as a user trying to change orders shipping address' do
    it 'should be successful if status is pending' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_order_path(@order_1)
      expect(@order_1.ship_location_id).to eq(@location_1.id)
      expect(page).to have_link('Change Shipping Location')
      expect(page).to have_content(@location_1.nickname)
      expect(page).to_not have_content(@location_2.nickname)

      click_on 'Change Shipping Location'
      expect(current_path).to eq(edit_profile_order_path(@order_1))

      within("#location-#{@location_2.id}") do
        click_on "Select As New Shipping Location"
      end

      expect(page).to have_content(@location_2.nickname)
      expect(page).to_not have_content(@location_1.nickname)
    end

    it 'should not be successful if status is packaged' do
      login_as(@user)
      visit profile_order_path(@order_2)
      expect(@order_2.ship_location_id).to eq(@location_1.id)
      expect(page).to_not have_link('Change Shipping Location')
    end

    it 'should not be successful if status is shipped' do
      login_as(@user)
      visit profile_order_path(@order_3)
      expect(@order_3.ship_location_id).to eq(@location_1.id)
      expect(page).to_not have_link('Change Shipping Location')
    end
  end
end
