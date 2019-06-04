require 'rails_helper'

RSpec.describe 'Edit shipping location,', type: :feature do
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

  describe 'as a user trying to edit shipping address' do
    it 'should be successful if order status is pending' do
      visit profile_path

      within("#location-#{@location_1.id}") do
        click_on "Edit"
      end

      expect(current_path).to eq(edit_profile_location_path(@location_1))
    end

    it 'should not be successful if order status is packaged' do
      visit profile_path

      within("#location-#{@location_2.id}") do
        click_on "Edit"
      end

      expect(page).to have_content("Your location cannot to be edited for completed order!")
      expect(current_path).to eq(profile_path)
      expect(page).to have_content(@location_2.nickname)
    end

    it 'should not be successful if order status is shipped' do
      visit profile_path

      within("#location-#{@location_3.id}") do
        click_on "Edit"
      end

      expect(page).to have_content("Your location cannot to be edited for completed order!")
      expect(current_path).to eq(profile_path)
      expect(page).to have_content(@location_3.nickname)
    end
  end

  describe "happy path" do
    it "has a form prepopulated with the shipping location data" do
      visit edit_profile_location_path(@location_1)

      expect(page).to have_css("[@value='#{@location_1.address}']")
      expect(page).to have_css("[@value='#{@location_1.city}']")
      expect(page).to have_css("[@value='#{@location_1.state}']")
      expect(page).to have_css("[@value='#{@location_1.zip}']")
    end

    it "can edit a shipping location" do
      visit edit_profile_location_path(@location_1)

      fill_in :location_nickname, with: "Edit Nickname"
      fill_in :location_address, with: "Edit Address"
      fill_in :location_city, with: "Edit City"
      fill_in :location_state, with: "Edit State"
      fill_in :location_zip, with: "Edit Zip"
      click_button "Update"

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Your location has been updated!")
      expect(page).to have_content("Edit Nickname")
      expect(page).to have_content("Edit Address")
      expect(page).to have_content("Edit City")
      expect(page).to have_content("Edit State")
      expect(page).to have_content("Edit Zip")
    end
  end

  describe "sad path" do
    it "cannot leave fields blank" do
      visit edit_profile_location_path(@location_1)

      fill_in :location_nickname, with: ""
      fill_in :location_address, with: ""
      fill_in :location_city, with: ""
      fill_in :location_state, with: ""
      fill_in :location_zip, with: ""
      click_button "Update"

      expect(page).to have_content("Address can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("State can't be blank")
      expect(page).to have_content("Zip can't be blank")
    end
  end
end
