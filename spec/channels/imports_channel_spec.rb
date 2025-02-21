describe ImportsChannel do
  it "subscribes to a stream" do
    subscribe

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("imports")
  end
end
