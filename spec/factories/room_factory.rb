FactoryGirl.define do
  factory :room do
    sequence(:name) { |n| "room #{n}" }
    game
  end
end