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
    import = create_import
    import.run!

    if import.completed?
      imported_companies = Company.where(import_id: import.id).includes(:addresses)
      render json: {
        data: CompanySerializer.list(imported_companies),
        metadata: { total_count: import.imported_count }
      }, status: :created
    else
      bad_request(import.error_log)
    end
  end

  def import_async
    import_id = create_import.id
    ImportCompaniesJob.perform_later(import_id)

    render json: {
      import_id: import_id
    }, status: :created
  end

  private

  def create_import
    Import.create!(file: import_file_param)
  end

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
