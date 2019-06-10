FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@gmail.com" }
    password { "12345678" }
  end

  factory :product do
    name { FFaker::Product.product }
    description { FFaker::Lorem.paragraph }
    price { rand(1..20) }
  end


end