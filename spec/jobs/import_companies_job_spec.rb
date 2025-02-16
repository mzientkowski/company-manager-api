describe ImportCompaniesJob do
  let(:import) { instance_double(Import, id: 'import_uuid') }

  subject(:job) { described_class.perform_later(import.id) }

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(import.id)
      .on_queue("default")
  end

  it 'executes perform' do
    expect(Import).to receive(:find).with(import.id).and_return(import)
    expect(import).to receive(:run!)

    perform_enqueued_jobs { job }
  end
end
