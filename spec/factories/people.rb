# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person do
    sequence(:gender){ |n| Person.random_gender }
    sequence(:name) { |n| Person.random_name(Person.random_gender) }
    sequence(:age){ |n|  Person.random_age }
  end
end
