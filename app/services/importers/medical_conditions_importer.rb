require "csv"

module Importers
  class MedicalConditionsImporter
    PATH = File.join(Rails.root, "lib", "medical_conditions_list.csv")
    HEADERS = %w(order_number icd10_code is_not_header short_description long_description dsm_code is_dsm)

    def self.perform
      # table = CSV.table(PATH)
      # headers = table.headers

      # if headers != HEADERS
      #   fail "CSV headers improperly formed. Expected #{HEADERS}, got #{headers}"
      # end

      CSV.foreach(PATH, headers: true) do |row|
        attributes = row.to_hash
        attributes["is_not_header"] = attributes["is_not_header"] == "1"
        attributes["is_dsm"] = attributes["is_dsm"] == "true"
        MedicalCondition.create(attributes)
        puts "Creating Code #{row['icd10_code']}"
      end
    end
  end
end
