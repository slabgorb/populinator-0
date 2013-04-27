# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :settlement do
    name Settlement.random_name
    residents {
      Array(1..100).map { FactoryGirl.create(:person,
                                     surname:%w|Green Red Blue|.shuffle.first,
                                     given_name:%w|Pat Bobby Shawn|.shuffle.first,
                                     gender:['male','female'].shuffle.first) } << FactoryGirl.create(:ruler)
    }
  end
end
