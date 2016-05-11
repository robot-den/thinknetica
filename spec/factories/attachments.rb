FactoryGirl.define do
  factory :attachment do
    file { File.open("#{Rails.root}/spec/rails_helper.rb") }
  end
end
