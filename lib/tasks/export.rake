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
    Settlement.all.each do |settlement|
      File.open("#{settlement.name}.html", 'wb') do |file|
        file << "<h1>#{settlement.name}</h1>"
        settlement.residents.each do |resident|
          file << "<h3>#{resident.to_s}</h3>\n"
          %w|name age spouse gender bio|.each do |func|
            begin
              file << "\t<dt>#{func.titlecase}</dt>"
              file << "\n\t<dd>#{resident.send(func.to_sym)}</dd>\n"
            rescue
            end
          end
          file << "</dl>\n"
        end
      end
    end
    
  end
end
