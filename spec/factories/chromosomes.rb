
FactoryGirl.define do
  factory :chromosome do 
    after_build do |s|
      10.times do 
        s <<  Chromosome.rand_hex 
      end
    end
  end
  factory :labrat, :parent => :chromosome do 
    after_build do |s|
      s.genes << '01020304A'
      s.genes << '01CCCCCCC'
    end
  end
end
