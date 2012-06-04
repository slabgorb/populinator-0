
FactoryGirl.define do
  factory :chromosome do 
    after_build do |s|
      10.times do 
        s << Gene.new(:code => Chromosome.rand_hex ) 
      end
    end
  end
  factory :labrat, :parent => :chromosome do 
    after_build do |s|
      s.genes << Gene.new(:code => '01020304A') 
      s.genes << Gene.new(:code => '01CCCCCCC') 
    end
  end
end
