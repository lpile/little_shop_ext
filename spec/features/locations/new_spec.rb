require 'rails_helper'

RSpec.describe 'Add shipping location,', type: :feature do
  before :each do
    @user = create(:user)
    @location_1 = create(:location, user: @user)
    @location_2 = create(:location, user: @user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it "user can see multiple shipping locations" do

    visit profile_path

    within '#shipping-locations' do
      expect(page).to have_content(@location_1.nickname)
      expect(page).to have_content(@location_2.nickname)
    end
  end

  it "user can add shipping location" do
    visit new_profile_location_path

    fill_in :location_nickname, with: "New Home"
    fill_in :location_address, with: "Address 1"
    fill_in :location_city, with: "City 1"
    fill_in :location_state, with: "State 1"
    fill_in :location_zip, with: "Zip 1"

    click_button "Submit"

    expect(current_path).to eq(profile_path)

    within '#shipping-locations' do
      expect(page).to have_content("New Home")
      expect(page).to have_content("Address 1")
      expect(page).to have_content("City 1")
      expect(page).to have_content("State 1")
      expect(page).to have_content("Zip 1")
    end
  end

  describe 'sad path' do
    it "should display error messages for each unfilled field" do
      visit new_profile_location_path

      click_button "Submit"

      expect(current_path).to eq(profile_locations_path)

      expect(page).to have_content("Address can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("State can't be blank")
      expect(page).to have_content("Zip can't be blank")
    end

    it "should display an error when a nickname is taken" do
      visit new_profile_location_path

      fill_in :location_nickname, with: "Nickname 1"
      fill_in :location_address, with: "Address 1"
      fill_in :location_city, with: "City 1"
      fill_in :location_state, with: "State 1"
      fill_in :location_zip, with: "Zip 1"

      click_button "Submit"

      expect(current_path).to eq(profile_locations_path)
      expect(page).to have_content("Nickname has already been taken")

      expect(page).to have_css("input[value='Address 1']")
      expect(page).to have_css("input[value='City 1']")
      expect(page).to have_css("input[value='State 1']")
      expect(page).to have_css("input[value='Zip 1']")
      expect(page).to_not have_css("input[value='Nickname 1']")
    end
  end
end
