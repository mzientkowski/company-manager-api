class ImportCompaniesJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    FileImporter.new(CompanyCsvParser.new(file_path)).import
  end
end
