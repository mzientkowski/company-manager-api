class Company < ApplicationRecord
  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses

  validates :name, presence: true, length: { maximum: 256 }
  validates :registration_number, presence: true, uniqueness: true, numericality: { only_integer: true }
  validates :addresses, presence: { message: "must have at least one" }
end
