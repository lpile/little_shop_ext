require "rails_helper"

RSpec.describe "add shipping location," do
  before :each do
    @user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it "user can add shipping location" do
    visit new_profile_location_path

    fill_in :location_nickname, with: "New Home"
    fill_in :location_address, with: "123 New Street"
    fill_in :location_city, with: "New City"
    fill_in :location_state, with: "New State"
    fill_in :location_zip, with: "12345"

    click_on "Create Shipping Location"

    expect(current_path).to eq(profile_path)

    within '#shipping-locations' do
      expect(page).to have_content("New Home")
      expect(page).to have_content("123 New Street")
      expect(page).to have_content("New City")
      expect(page).to have_content("New State")
      expect(page).to have_content("12345")
    end
  end
end
