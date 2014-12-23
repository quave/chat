FactoryGirl.define do
  factory :user, aliases: [:creator] do
    confirmed_at Time.now
    sequence(:name) { |n| "user #{n}" }
    sequence(:email) { |n| "person#{n}@example.com" }
    password '123456789'
  end
end