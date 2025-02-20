# == Schema Information
#
# Table name: addresses
#
#  id          :bigint           not null, primary key
#  city        :string           not null
#  country     :string           not null
#  postal_code :string
#  street      :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint           not null
#
# Indexes
#
#  index_addresses_on_company_id                                  (company_id)
#  index_addresses_on_company_id_and_country_and_city_and_street  (company_id,country,city,street) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Address < ApplicationRecord
  belongs_to :company

  validates :street, :city, :country, presence: true
  validates :street, uniqueness: { scope: %i[company_id country city] }

  def uniq_hash
    Digest::MD5.hexdigest("#{company_id}#{country}#{city}#{street}")
  end
end
