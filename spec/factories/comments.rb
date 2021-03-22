FactoryBot.define do
  factory :comment do
    content { "My factory comment" }
    
    association :article
    association :user
  end
end
