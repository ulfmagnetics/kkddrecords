# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :band do |b|
    b.name { Faker::Company.name }
  end
end
