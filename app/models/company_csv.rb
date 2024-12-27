class CompanyCsv < Company
  attr_accessor :csv_row_index

  after_validation :add_csv_position_error, if: -> { errors.present? }

  def add_csv_position_error
    errors.add(:csv, "invalid data for company starting at row: #{csv_row_index}")
  end
end
