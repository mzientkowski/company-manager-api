require "csv"

class CompanyCsvParser
  VALID_CSV_HEADER = "name,registration_number,street,city,postal_code,country".freeze
  CSV_OPTIONS = { headers: true, header_converters: :symbol }.freeze
  include Enumerable

  def initialize(file_path)
    @file_path = file_path
    @company_builder = CompanyCsvBuilder.new
  end

  def valid?
    validate_csv_header

    @errors.nil?
  end

  def errors
    @errors ||= []
  end

  def each
    return enum_for(__method__) unless block_given?
    CSV.foreach(file_path, **CSV_OPTIONS).with_index(2) do |row, idx|
      company_builder.add_row(row.to_h, idx) do |company|
        yield company
      end
    end

    yield company_builder.company
  end

  private

  attr_reader :file_path, :company_builder

  def validate_csv_header
    header = File.open(file_path, &:readline).chomp("\n")

    if VALID_CSV_HEADER != header
      errors << "Invalid csv header expected: #{VALID_CSV_HEADER} instead of: #{header}"
    end
  end
end
