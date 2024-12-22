class Api::V1::CompaniesController < ApplicationController
  def create
    company = Company.new(company_params)

    if company.save
      render json: CompanySerializer.new(company), status: :created
    else
      bad_request(company.errors.full_messages)
    end
  end

  private

  def company_params
    params.require(:company).permit(
      :name, :registration_number,
      addresses_attributes: [ :street, :city, :postal_code, :country ]
    )
  end
end
