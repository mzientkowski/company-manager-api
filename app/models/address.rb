class Address < ApplicationRecord
  belongs_to :company

  validates :street, :city, :country, presence: true
end
