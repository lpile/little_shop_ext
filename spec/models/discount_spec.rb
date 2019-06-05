require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'validations' do
    it { should validate_presence_of :qualifier }
    it { should validate_presence_of :percentage }
  end

  describe 'relationships' do
    it { should belong_to :user }
  end
end
