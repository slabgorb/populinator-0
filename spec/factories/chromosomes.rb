
FactoryGirl.define do
  factory :chromosome do 
    after_create do |s|
      10.times do 
        s.genes << Gene.new(:code => Chromosome.rand_hex ) 
      end
    end
  end
  factory :labrat, :parent => :chromosome do 
    after_create do |s|
      s.genes << Gene.new(:code => '01020304A') 
      s.genes << Gene.new(:code => '01CCCCCCC') 
    end
  end
end
