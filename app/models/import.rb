class Import < ApplicationRecord
  enum :status, { pending: "pending", running: "running", completed: "completed", failed: "failed" }

  has_one_attached :file, dependent: :destroy

  validates :total_count, :imported_count, :failed_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :check_file_presence

  def check_file_presence
    errors.add(:file, "no file") unless file.attached?
  end
end
