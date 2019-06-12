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

  factory :cart do
  end

  factory :order do
    sn { Time.now.to_i + user.id } 
    name { user.email.split("@").first }
    address { FFaker::AddressUS.street_address }
    phone { FFaker::PhoneNumber.short_phone_number }
    user
  end
end