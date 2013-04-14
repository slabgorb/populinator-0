require "#{Rails.root}/app/helpers/beings_helper"
include BeingsHelper
namespace :export do
  desc 'export'
  task :settlements => :environment do
    require 'csv'
    Settlement.all.each do |settlement|
      csv = CSV.open("#{settlement.name}.csv", 'wb') do |csv|
        csv << ['Family Name', 'Given Name', 'Age', 'Gender', 'Spouse', 'Description']
        settlement.residents.sort{ |a,b| a.surname + a.name <=> b.surname + b.name }.each do |resident|
          csv << [resident.surname, resident.name, resident.age, resident.gender, resident.spouse, describe_paragraph(resident)] 
        end
      end
    end
    Settlement.all.each do |settlement|
      File.open("#{settlement.name}.html", 'wb') do |file|
        file << "<h1>#{settlement.name}</h1>"
        residents =  settlement.residents.sort{ |a,b| a.surname + a.name <=> b.surname + b.name }
        file << "<ul style='list-style-type:none'>\n"
        residents.each do |resident|
          file << "\t<li><a href='##{resident.slug}}'>#{resident.to_s}</a></li>\n"
          if resident.spouse
            file << "\t<ul style='list-style-type:none'><li>#{resident.spouse.to_s}</li></ul>"
          end
          if resident.children
            file << "\t<ul style='list-style-type:none'>\n"
            resident.children.each do |child|
              file << "\t\t<li>#{child.to_s}</li>\n"
            end
            file << "</ul>"
          end
        end
        file << "</ul>\n"
        residents.each do |resident|
          file << "<hr/>\n"
          file << "<h3><a name='resident.slug'>#{resident.to_s}</a></h3>\n"
          file << "<dl>\n"
          %w|name age spouse gender bio|.each do |func|
            begin
              file << "\t<dt><b>#{func.titlecase}</b></dt>"
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
