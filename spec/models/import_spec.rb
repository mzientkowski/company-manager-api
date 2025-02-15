describe Import, type: :model do
  subject(:import) { build(:import) }

  describe 'associations' do
    it { should have_one_attached(:file) }
  end

  describe 'validations' do
    %i[total_count imported_count failed_count].each do |field|
      it { should validate_presence_of(field) }
      it { should validate_numericality_of(field).only_integer }
      it { should validate_numericality_of(field).is_greater_than_or_equal_to(0) }
    end

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

    %i[total_count imported_count failed_count].each do |field|
      it { should have_db_column(field).of_type(:integer).with_options(null: false, default: 0) }
    end

    it { should have_db_column(:error_log).of_type(:text).with_options(array: true, default: []) }
    it { should have_db_column(:started_at).of_type(:datetime) }
    it { should have_db_column(:completed_at).of_type(:datetime) }
    it { should have_db_index(:status) }
  end
end
