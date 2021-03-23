FactoryBot.define do
  factory :article do
    title { Faker::Book.title }
    content { Faker::Quote.yoda }
    sequence(:slug) { |n| "slug-#{Faker::Lorem.word + n.to_s}" }

    association :user
  end
end
