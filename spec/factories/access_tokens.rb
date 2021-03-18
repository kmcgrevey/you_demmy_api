FactoryBot.define do
  factory :access_token do
    token { "thisisatesttoken" }
    user { nil }
  end
end
