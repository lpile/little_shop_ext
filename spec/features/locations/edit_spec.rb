require 'rails_helper'

RSpec.describe 'Edit shipping location,', type: :feature do
  before :each do
    @user = create(:user)
    @location = create(:location, user: @user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  describe "happy path" do
    it "has a form prepopulated with the shipping location data" do
      visit edit_profile_location_path(@location)

      expect(page).to have_css("[@value='#{@location.address}']")
      expect(page).to have_css("[@value='#{@location.city}']")
      expect(page).to have_css("[@value='#{@location.state}']")
      expect(page).to have_css("[@value='#{@location.zip}']")
    end

    it "can edit a shipping location" do
      visit edit_profile_location_path(@location)

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
      visit edit_profile_location_path(@location)

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
