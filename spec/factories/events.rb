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
