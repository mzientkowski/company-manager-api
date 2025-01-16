describe Company do
  subject(:company) { build(:company) }

  describe 'associations' do
    it { should have_many(:addresses).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(256) }
    it { should validate_presence_of(:registration_number) }
    it { should validate_uniqueness_of(:registration_number) }
    it { should validate_numericality_of(:registration_number).only_integer }
    it { should validate_numericality_of(:registration_number).is_greater_than(0) }

    context 'addresses validation' do
      it 'is invalid without at least one address' do
        company.addresses = []
        expect(company).to_not be_valid
        expect(company.errors[:addresses]).to include("must have at least one")
      end

      it 'is valid with at least one address' do
        company.addresses.build(attributes_for(:address))
        expect(company).to be_valid
      end
    end
  end

  describe 'database constraints' do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:registration_number).of_type(:integer).with_options(null: false) }
    it { should have_db_index(:registration_number).unique(true) }
  end
end
