require 'benchmark'
class Creator < Thor
  require './config/environment'
  method_option :name, default: Settlement.random_name
  method_option :population, default: rand * 100, type: :numeric
  desc "settlement", "create a new settlement"
  def settlement
    puts "Making a new settlement."
    Benchmark.measure do
      settlement = Settlement.create(name:options[:name])
      settlement.populate options[:population].to_i
      settlement.seed!
      puts "Created new settlement #{settlement} with a population of #{settlement.population}."
    end
  end
end
