FactoryBot.define do
  factory :access_token do
    # token is generated after initialzation
    association :user
  end
end
