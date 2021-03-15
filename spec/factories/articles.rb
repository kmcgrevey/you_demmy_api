FactoryBot.define do
  factory :article do
    title { Faker::Book.title }
    content { Faker::Quote.yoda }
    slug { "slug-#{Faker::Beer.unique.yeast}" }
  end
end
