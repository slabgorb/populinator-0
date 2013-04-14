FactoryGirl.define do
  factory :being do
    name'Bob Being'
    alive true
    age 1
    gender 'male'
  end
  
  factory :being_with_settlement, :parent => :being do
    after_create do |t|
      settlement = FactoryGirl.create(:settlement)
    end
  end
end
