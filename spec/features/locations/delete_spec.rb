require 'rails_helper'

RSpec.describe 'Delete shipping location,', type: :feature do
  before :each do
    @user = create(:user)
    @location_1 = create(:location, user: @user)
    @location_2 = create(:location, user: @user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it "user can delete shipping location" do
    visit profile_path

    within("#location-#{@location_2.id}") do
      click_link "Delete"
    end

    expect(current_path).to eq(profile_path)
    expect(page).to have_content(@location_1.nickname)
    expect(page).to_not have_content(@location_2.nickname)
  end
end
