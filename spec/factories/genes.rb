FactoryGirl.define do
  factory :gene do |s|
    s.code  Chromosome.rand_hex
  end
end
