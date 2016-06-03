FactoryGirl.define do
  factory :authorization do
    user
    provider 'twitter'
    uid "12345678"
    confirmed false
    confirmation_hash Devise.friendly_token[0, 20]
  end
end
