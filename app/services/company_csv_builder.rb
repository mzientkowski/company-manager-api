class CompanyCsvBuilder

  def initialize
    @company = nil
  end

  attr_reader :company

  def add_row(row, idx, &block)
    if company.nil? || !is_same_company?(row)
      block.call(company) if company
      self.company = build_company(row, idx)
    end

    company_add_address(company, row)
    true
  end

  private

  attr_writer :company

  def is_same_company?(row)
    company.registration_number == row[:registration_number].to_i && company.name == row[:name].to_s
  end

  def build_company(row, idx)
    CompanyCsv.new(
      registration_number: row[:registration_number],
      name: row[:name],
      csv_row_index: idx
    )
  end

  def company_add_address(company, row)
    company.addresses.build(row.slice(*%i[street city postal_code country]))
  end
end
