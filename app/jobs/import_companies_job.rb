class ImportCompaniesJob < ApplicationJob
  queue_as :default

  def perform(import_id)
    Import.find(import_id).run!
  end
end
