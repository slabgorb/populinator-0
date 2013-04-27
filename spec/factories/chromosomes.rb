
FactoryGirl.define do
  factory :chromosome do
    genes {
      (Array(lambda{ Chromosome.rand_hex }) * 10).map(&:call)
    }
  end
  factory :labrat, :parent => :chromosome do
    genes {
      ['01020304A', '01CCCCCCC']
    }
  end
end
