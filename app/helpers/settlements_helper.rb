require 'csv'
module SettlementsHelper
  def settlement_csv_header
    ['Settlement', 'Id', 'Family Name', 'Given Name', 'Age', 'Gender', 'Spouse', 'Description']
  end

  def settlement_to_csv(settlement, solo=true)
    CSV.generate do |csv|
      csv << settlement_csv_helper if solo
      settlement.residents.sort{ |a,b| a.surname + a.name <=> b.surname + b.name }.each do |resident|
        csv << [settlement.name, settlement.id, resident.surname, resident.name, resident.age, resident.gender, resident.spouse, describe_paragraph(resident)]
      end
    end
  end
  def settlements_to_csv
    CSV.generate do |csv|
      csv << settlement_csv_helper
      Settlement.all.each do |settlement|
        csv << settlement_to_csv(settlement, false)
      end
    end
  end


end
