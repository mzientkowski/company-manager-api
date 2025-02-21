class ImportsChannel < ApplicationCable::Channel
  def subscribed
    stream_from("imports")
  end

  def self.notify(data)
    ActionCable.server.broadcast("imports", data)
  end
end
