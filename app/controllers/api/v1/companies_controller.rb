class Api::V1::CompaniesController < ApplicationController
  def create
    company = Company.new(company_params)

    if company.save
      render json: CompanySerializer.new(company), status: :created
    else
      bad_request(company.errors)
    end
  end

  def import
    importer = FileImporter.new(CompanyCsvParser.new(import_file_param.path))

    if importer.import
      render json: {
        data: CompanySerializer.list(importer.imported_objects),
        metadata: { total_count: importer.imported_objects.size }
      }, status: :created
    else
      bad_request(importer.errors)
    end
  end

  def import_async
    # FIXME: import_file should be persisted before delegating job
    ImportCompaniesJob.perform_later(import_file_param.path)
  end

  private

  def import_file_param
    params.expect(:file)
  end

  def company_params
    params.require(:company).permit(
      :name, :registration_number,
      addresses_attributes: [ :street, :city, :postal_code, :country ]
    )
  end
end
