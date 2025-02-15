describe Import, type: :model do
  subject(:import) { build(:import) }

  describe 'associations' do
    it { should have_one_attached(:file) }
  end

  describe 'validations' do
    it { should validate_presence_of(:imported_count) }
    it { should validate_numericality_of(:imported_count).only_integer }
    it { should validate_numericality_of(:imported_count).is_greater_than_or_equal_to(0) }

    context 'file attachment validation' do
      it 'is invalid without an attached file' do
        import.file.purge
        expect(import).not_to be_valid
      end

      it 'is valid with an attached file' do
        expect(import.file).to be_attached
        expect(import).to be_valid
      end
    end
  end

  describe 'status enum' do
    it 'has valid status values' do
      expect(Import.statuses.keys).to match_array(%w[pending running completed failed])
    end
  end

  describe 'database constraints' do
    it { should have_db_column(:status).of_type(:enum).with_options(null: false, default: 'pending') }
    it { should have_db_column(:imported_count).of_type(:integer).with_options(null: false, default: 0) }
    it { should have_db_column(:validation_errors).of_type(:jsonb).with_options(null: false, default: {}) }
    it { should have_db_column(:started_at).of_type(:datetime) }
    it { should have_db_column(:completed_at).of_type(:datetime) }
    it { should have_db_index(:status) }
  end
end
