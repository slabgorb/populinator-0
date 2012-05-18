# Read about factories at https://github.com/thoughtbot/factory_girl
# {:category => 'life',:name =>'marriage',:description => 'was married', :effect => '{|a,b| a.marry b }'},

FactoryGirl.define do
  factory :event do
    name "nothing"
    category "personal"
    description ""
    effect '{|a,b| a,b }'
  end
  
  factory :marriage, :parent => :event do
    name "marriage"
    effect '{|a,b| a.marry b }'
  end
  
end
