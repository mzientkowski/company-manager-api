describe FileImporter do
  let(:import) { instance_double('Import', id: 'uuid') }
  let(:valid_file_parser) { double('FileParser', valid?: true, each: nil) }
  let(:invalid_file_parser) { double('FileParser', valid?: false, errors: [ 'Invalid header' ]) }

  describe '#import' do
    context 'when the file parser is invalid' do
      it 'does not import and returns false' do
        importer = described_class.new(import, invalid_file_parser)

        expect(importer.import).to eq(false)
        expect(importer.errors).to include('Invalid header')
        expect(importer.imported_objects).to be_empty
      end
    end

    context 'when the file parser is valid' do
      let(:file_parser) { valid_file_parser }
      let(:object1) { double(save: true) }
      let(:object2) { double(save: true) }

      before do
        allow(file_parser).to receive(:each).and_yield(object1).and_yield(object2)
      end

      it 'imports objects and returns true' do
        importer = described_class.new(import, file_parser)

        expect(object1).to receive(:import_id=).with(import.id)
        expect(object2).to receive(:import_id=).with(import.id)

        result = importer.import

        expect(result).to eq(true)
        expect(importer.errors).to be_empty
        expect(importer.imported_objects).to match_array([ object1, object2 ])
      end

      context 'when an object fails to save' do
        let(:invalid_object) { double(save: false, errors: [ 'Invalid data' ]) }

        before do
          allow(file_parser).to receive(:each).and_yield(object1).and_yield(invalid_object).and_yield(object2)
          allow(invalid_object).to receive(:import_id=).with(import.id)
        end

        it 'rolls back the transaction, records errors, and returns false' do
          importer = described_class.new(import, file_parser)

          expect(object1).to receive(:import_id=).with(import.id)

          result = importer.import

          expect(result).to eq(false)
          expect(importer.errors).to include([ 'Invalid data' ])
          expect(importer.imported_objects).to be_empty
        end
      end
    end
  end
end
