# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :settlement do |s|
    s.name Settlement.random_name
    s.after_build do |t|
      100.times { t.residents << FactoryGirl.create(:person, 
                                                 alive: true,
                                                 surname:%w|Green Red Blue|.shuffle.first, 
                                                 given_name:%w|Pat Bobby Shawn|.shuffle.first, 
                                                 gender:['male','female'].shuffle.first) }
      t.residents << FactoryGirl.create(:ruler)
    end
  end
end
