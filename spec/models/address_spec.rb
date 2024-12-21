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
  end

  describe 'database constraints' do
    it { should have_db_column(:street).of_type(:string).with_options(null: false) }
    it { should have_db_column(:city).of_type(:string).with_options(null: false) }
    it { should have_db_column(:postal_code).of_type(:string).with_options(null: true) }
    it { should have_db_column(:country).of_type(:string).with_options(null: false) }
    it { should have_db_index(:company_id) }
  end
end
