class CompanySerializer
  def self.list(companies)
    companies.map { |company| new(company).as_json }
  end

  def initialize(company)
    @object = company
  end

  def as_json(*args)
    object.as_json(
      only: %i[id name registration_number],
      include: {
        addresses: {
          only: %i[id street city postal_code country]
        }
      }
    )
  end

  private

  attr_reader :object
end
