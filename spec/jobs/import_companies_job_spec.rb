describe ImportCompaniesJob do
  let(:file_path) { 'spec/fixtures/files/companies.csv' }
  let(:parser) { instance_double(CompanyCsvParser) }
  let(:importer) { instance_double(FileImporter) }

  subject(:job) { described_class.perform_later(file_path) }

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(file_path)
      .on_queue("default")
  end

  it 'executes perform' do
    expect(CompanyCsvParser).to receive(:new).with(file_path).and_return(parser)
    expect(FileImporter).to receive(:new).with(parser).and_return(importer)

    expect(importer).to receive(:import)
    perform_enqueued_jobs { job }
  end
end
