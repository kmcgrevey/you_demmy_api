FactoryBot.define do
  factory :article do
    title { Faker::Book.title }
    content { Faker::Quote.yoda }
    slug { "slug-#{Faker::Beer.unique.yeast}" }

    association :user
  end
end
