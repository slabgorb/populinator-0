# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person do
    name Person.random_name
    gender Person.random_gender
    age Person.random_age
  end
end
