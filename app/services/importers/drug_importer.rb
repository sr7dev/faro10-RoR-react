require "csv"

module Importers
  class DrugImporter
    PATH = File.join(Rails.root, "lib", "drug_list.csv")
    HEADERS = [:friendly_name, :scientific_name, :pharma_comp]

    def self.perform
      table = CSV.table(PATH)
      headers = table.headers

      if headers != HEADERS
        fail "CSV headers improperly formed. Expected #{HEADERS}, got #{headers}"
      end

      table.each do |row|
        drug = Drug.where("lower(friendly_name) = ?", row[:friendly_name].downcase).first || Drug.new

        drug.assign_attributes(
          friendly_name: row[:friendly_name],
          scientific_name: row[:scientific_name],
          pharma_comp: row[:pharma_comp]
        )

        if drug.changed?
          puts "Updating #{drug.friendly_name}..."
          drug.save
        end
      end
    end
  end
end
