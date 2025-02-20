describe Address do
  subject(:address) { build(:address) }

  describe 'associations' do
    it { should belong_to(:company) }
  end

  describe 'validations' do
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:country) }
    it { should allow_value(nil).for(:postal_code) }
    it { should validate_uniqueness_of(:street).scoped_to(%i[company_id country city]) }
  end

  describe 'database constraints' do
    it { should have_db_column(:street).of_type(:string).with_options(null: false) }
    it { should have_db_column(:city).of_type(:string).with_options(null: false) }
    it { should have_db_column(:postal_code).of_type(:string).with_options(null: true) }
    it { should have_db_column(:country).of_type(:string).with_options(null: false) }
    it { should have_db_index(:company_id) }
    it { should have_db_index(%i[company_id country city street]).unique(true) }
  end

  describe '#uniq_hash' do
    it 'returns a unique hash based on company_id, country, city, and street' do
      address = build(:address, company_id: 1, street: '123 St', city: 'New York', country: 'USA')
      expect(address.uniq_hash).to eq('a5eea05c5e20fa0f25ab0f7eec6d92bd')
    end
  end
end
