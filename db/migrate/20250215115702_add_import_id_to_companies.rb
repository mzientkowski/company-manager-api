class AddImportIdToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :import_id, :string
    add_index :companies, :import_id
  end
end
