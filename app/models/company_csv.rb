# == Schema Information
#
# Table name: companies
#
#  id                  :bigint           not null, primary key
#  name                :string           not null
#  registration_number :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  import_id           :string
#
# Indexes
#
#  index_companies_on_import_id            (import_id)
#  index_companies_on_registration_number  (registration_number) UNIQUE
#
class CompanyCsv < Company
  attr_accessor :csv_row_index

  after_validation :add_csv_position_error, if: -> { errors.present? }

  def add_csv_position_error
    errors.add(:csv, "invalid data for company starting at row: #{csv_row_index}")
  end
end
