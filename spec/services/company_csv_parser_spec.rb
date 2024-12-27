describe CompanyCsvParser do
  let(:valid_csv_path) { file_fixture('companies.csv') }
  let(:invalid_header_csv_path) { file_fixture('invalid_header_companies.csv') }

  describe '#valid?' do
    context 'when the CSV header is valid' do
      it 'returns true' do
        parser = described_class.new(valid_csv_path)
        expect(parser.valid?).to eq(true)
      end
    end

    context 'when the CSV header is invalid' do
      it 'returns false and populates errors' do
        parser = described_class.new(invalid_header_csv_path)
        expect(parser.valid?).to eq(false)
        expect(parser.errors).to include(/Invalid csv header/)
      end
    end
  end

  describe '#each' do
    let(:company_builder) { instance_double('CompanyCsvBuilder') }

    before do
      expect(CompanyCsvBuilder).to receive(:new).and_return(company_builder)
      expect(company_builder).to receive(:company).and_return(:company)
    end

    context 'when the CSV is valid' do
      it 'yields companies' do
        parser = described_class.new(valid_csv_path)

        expect(company_builder).to receive(:add_row)
                                     .with({ city: "New York",
                                             country: "USA",
                                             name: "Example Co",
                                             postal_code: "10001",
                                             registration_number: "123456789",
                                             street: "123 Main St"
                                           }, 2)

        expect(company_builder).to receive(:add_row)
                                     .with({ city: "Los Angeles",
                                             country: "USA",
                                             name: "Example Co",
                                             postal_code: "90001",
                                             registration_number: "123456789",
                                             street: "456 Elm St"
                                           }, 3).and_yield(:company)

        expect(company_builder).to receive(:add_row)
                                     .with({ city: "Chicago",
                                             country: "USA",
                                             name: "Another Co",
                                             postal_code: "60601",
                                             registration_number: "987654321",
                                             street: "789 Oak St"
                                           }, 4)

        companies = parser.to_a
        expect(companies.size).to eq(2)
      end
    end
  end
end
