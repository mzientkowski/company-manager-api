# == Schema Information
#
# Table name: companies
#
#  id                  :bigint           not null, primary key
#  name                :string           not null
#  registration_number :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  import_id           :string
#
# Indexes
#
#  index_companies_on_import_id            (import_id)
#  index_companies_on_registration_number  (registration_number) UNIQUE
#
class Company < ApplicationRecord
  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses

  validates :name, presence: true, length: { maximum: 256 }
  validates :registration_number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }
  validates :addresses, presence: { message: "must have at least one" }

  validate :validate_uniq_addresses

  def validate_uniq_addresses
    if addresses.present? && addresses.map(&:uniq_hash).uniq.size != addresses.size
      errors.add(:addresses, "must be unique")
    end
  end
end
