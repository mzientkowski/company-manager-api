describe CompanyCsvBuilder do
  let(:row1) do
    {
      city: "New York",
      country: "USA",
      name: "Example Co",
      postal_code: "10001",
      registration_number: "123456789",
      street: "123 Main St"
    }
  end

  let(:row2) do
    {
      city: "Los Angeles",
      country: "USA",
      name: "Example Co",
      postal_code: "90001",
      registration_number: "123456789",
      street: "456 Elm St"
    }
  end

  let(:row3) do
    {
      city: "Chicago",
      country: "USA",
      name: "Another Co",
      postal_code: "60601",
      registration_number: "987654321",
      street: "789 Oak St"
    }
  end

  describe '#add_row' do
    let(:builder) { described_class.new }

    context 'when the first row is added' do
      it 'creates a new company and sets it as the current company' do
        builder.add_row(row1, 2) { }

        expect(builder.company).to be_a(CompanyCsv)
        expect(builder.company.addresses.size).to eq(1)

        expect(builder.company.csv_row_index).to eq(2)
      end
    end

    context 'when a row for the same company is added' do
      it 'adds the address to the current company' do
        builder.add_row(row1, 2) { }
        builder.add_row(row2, 3) { }

        expect(builder.company).to be_a(CompanyCsv)
        expect(builder.company.addresses.size).to eq(2)
      end
    end

    context 'when a row for a different company is added' do
      it 'yields the current company and sets a new current company' do
        yielded_companies = []
        [ row1, row2, row3 ].each_with_index do |row, i|
          builder.add_row(row, i) do |company|
            yielded_companies << company
          end
        end

        expect(yielded_companies.size).to eq(1)
        expect(yielded_companies.first).to be_a(CompanyCsv)
        expect(builder.company).not_to equal(yielded_companies.first)
      end
    end
  end
end
