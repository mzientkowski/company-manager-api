describe CompanyCsv do
  subject(:company_csv) do
    CompanyCsv.new(**attributes_for(:company), addresses_attributes: [ attributes_for(:address) ], csv_row_index: 2)
  end

  it { expect(described_class).to be < Company }

  describe 'validations' do
    context 'add_csv_position_error' do
      it 'is valid' do
        expect(company_csv).to be_valid
        expect(company_csv.errors).to be_an_empty
      end

      it 'is invalid with csv position error' do
        company_csv.name = ''
        expect(company_csv).to_not be_valid
        expect(company_csv.errors[:csv]).to include("invalid data for company starting at row: 2")
      end
    end
  end
end
