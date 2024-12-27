describe CompanySerializer do
  let(:address1) { build(:address, street: '123 Main St', city: 'New York', postal_code: '10001', country: 'USA') }
  let(:address2) { build(:address, street: '456 Elm St', city: 'Los Angeles', postal_code: '90001', country: 'USA') }
  let(:company) { build(:company, name: 'Test Company', registration_number: 123456789, addresses: [address1, address2]) }

  describe '.list' do
    it 'serializes a collection of companies' do
      result = described_class.list([company])

      expect(result).to match_snapshot('serializers/company/companies')
    end
  end

  describe '#as_json' do
    it 'serializes a single company' do
      result = described_class.new(company).as_json

      expect(result).to match_snapshot('serializers/company/company')
    end
  end
end
