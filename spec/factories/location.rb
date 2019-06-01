FactoryBot.define do
  factory :location do
    user
    sequence(:nickname) { |n| "Nickname #{n}" }
    sequence(:address) { |n| "Address #{n}" }
    sequence(:city) { |n| "City #{n}" }
    sequence(:state) { |n| "State #{n}" }
    sequence(:zip) { |n| "Zip #{n}" }
  end
end
