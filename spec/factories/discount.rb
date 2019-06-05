FactoryBot.define do
  factory :discount do
    user
    sequence(:qualifier) { |n| ("#{n}".to_i+4) }
    sequence(:percentage) { |n| ("#{n}".to_i+1) }
  end
end
