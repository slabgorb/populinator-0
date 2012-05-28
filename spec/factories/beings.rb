# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :being do
    after_create do |t|
      settlement = FactoryGirl.create(:settlement)
    end
  end
end
