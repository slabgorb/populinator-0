require "#{Rails.root}/app/helpers/beings_helper"
include BeingsHelper
namespace :export do
  desc 'export'
  task :settlements => :environment do
    require 'csv'
    Settlement.all.each do |settlement|
      csv = CSV.open("#{settlement.name}.csv", 'wb') do |csv|
        csv << ['Family Name', 'Given Name', 'Age', 'Gender', 'Spouse', 'Description']
        settlement.residents.each do |resident|
          csv << [resident.surname, resident.name, resident.age, resident.gender, resident.spouse, describe_paragraph(resident)] 
        end
      end
    end
  end
end
