
FactoryGirl.define do
  factory :chromosome do 
    after_create do |s|
      10.times do 
        s.genes << Gene.new(:code => Chromosome.rand_hex ) 
      end
    end
  end
end
