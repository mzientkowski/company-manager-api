class AddUniquenessIndexToAddresses < ActiveRecord::Migration[8.0]
  def change
    add_index :addresses, [ :company_id, :country, :city, :street ], unique: true
  end
end
