# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :settlement do |s|

    s.name Settlement.random_name
    s.after_build do |t|
      100.times { t.beings << FactoryGirl.create(:person) }
      t.rulers << FactoryGirl.create(:ruler)
    end
  
  end
end
