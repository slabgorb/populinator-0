# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :being do
    name Being.random_name
  end
  
  factory :being_with_settlement, :parent => :being do
    after_create do |t|
      settlement = FactoryGirl.create(:settlement)
    end
  end
end
