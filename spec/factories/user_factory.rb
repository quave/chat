FactoryGirl.define do
  factory :user, aliases: [:creator] do
    sequence(:name) { |n| "profile #{n}" }
    sequence(:email) { |n| "person#{n}@example.com" }
    password '123456789'
  end
end