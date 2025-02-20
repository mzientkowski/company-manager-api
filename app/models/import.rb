# == Schema Information
#
# Table name: imports
#
#  id             :uuid             not null, primary key
#  completed_at   :datetime
#  error_log      :text             default([]), is an Array
#  failed_count   :integer          default(0), not null
#  imported_count :integer          default(0), not null
#  started_at     :datetime
#  status         :enum             default("pending"), not null
#  total_count    :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_imports_on_status  (status)
#
class Import < ApplicationRecord
  enum :status, { pending: "pending", running: "running", completed: "completed", failed: "failed" }

  has_one_attached :file, dependent: :destroy

  after_commit -> { ImportsChannel.notify(self) }

  validates :total_count, :imported_count, :failed_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :check_file_presence

  def check_file_presence
    errors.add(:file, "no file") unless file.attached?
  end

  def file_download
    tmp_file = Tempfile.new.tap(&:binmode)
    file.download { |chunk| tmp_file.write(chunk) }
    tmp_file.tap(&:rewind)
  end

  def run!
    update!(status: Import.statuses[:running], started_at: Time.current)
    begin
      tmp_file = file_download
      file_importer = FileImporter.new(self, CompanyCsvParser.new(tmp_file.path))
      if file_importer.import
        update!(status: Import.statuses[:completed], imported_count: file_importer.imported_objects.size, completed_at: Time.current)
      else
        update!(status: Import.statuses[:failed], error_log: file_importer.errors.map(&:full_messages))
      end
    rescue => exception
      update!(status: Import.statuses[:failed], error_log: self.error_log << exception.message)
      raise
    ensure
      tmp_file.close
      tmp_file.unlink
    end
  end
end
