require 'swagger_helper'

describe 'Companies API' do
  path '/api/v1/companies' do
    get 'Retrieves Companies' do
      parameter name: "page[number]", in: :query, type: :number, required: false, getter: :page_number
      parameter name: "page[limit]", in: :query, type: :number, required: false, getter: :page_limit
      parameter name: "filter[import_id]", in: :query, type: :string, required: false, getter: :filter_import_id
      produces 'application/json'

      before do
        create(:company, name: 'Example Co#1', registration_number: 123456789, import_id: SecureRandom.uuid, addresses: [
          build(:address, street: '456 Elm St', city: 'New York', postal_code: '90001'),
          build(:address, street: '123 Main St', city: 'New York', postal_code: '10001')
        ])
        create(:company, name: 'Example Co#2', registration_number: 987654321, addresses: [
          build(:address, street: '789 Oak St', city: 'Chicago', postal_code: '60601')
        ])
      end

      response '200', 'Companies paginated' do
        schema '$ref' => '#/components/schemas/companies_index'

        let(:page_number) { 2 }
        let(:page_limit) { 1 }

        run_test! do |response|
          json = JSON.parse(response.body)
          json['data'] = json['data'].map { |c| c.deep_except!("id") }
          expect(json).to match_snapshot('requests/api/v1/companies/companies_paginated')
        end
      end

      response '200', 'Companies filtred by import_id' do
        schema '$ref' => '#/components/schemas/companies_index'

        let(:filter_import_id) { Company.first.import_id }

        run_test! do |response|
          json = JSON.parse(response.body)
          json['data'] = json['data'].map { |c| c.deep_except!("id") }
          expect(json).to match_snapshot('requests/api/v1/companies/companies_filtred_by_import_id')
        end
      end

      response '200', 'Companies' do
         schema '$ref' => '#/components/schemas/companies_index'

        run_test! do |response|
          json = JSON.parse(response.body)
          json['data'] = json['data'].map { |c| c.deep_except!("id") }
          expect(json).to match_snapshot('requests/api/v1/companies/companies')
        end
      end
    end

    post 'Create a Company with Addresses' do
      tags 'Companies'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :company, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          registration_number: { type: :integer },
          addresses_attributes: { '$ref' => '#/components/schemas/addresses' }
        },
        required: %i[name registration_number addresses_attributes]
      }

      response '201', 'Company created' do
        schema '$ref' => '#/components/schemas/company'
        let(:company) do
          attributes_for(:company).merge(addresses_attributes: Array.new(2) { attributes_for(:address) })
        end

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['addresses'].size).to eq(2)
        end
      end

      response '400', 'Bad request' do
        schema '$ref' => '#/components/schemas/bad_request'
        let(:company) { { name: '' } }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json).to match_snapshot('requests/api/v1/companies/create_bad_request')
        end
      end

      path '/api/v1/companies/import' do
        post 'Bulk Import Companies via CSV' do
          tags 'Companies'
          consumes 'multipart/form-data'
          produces 'application/json'

          parameter name: :file, in: :formData, schema: {
            type: :object,
            properties: {
              file: { type: :string, format: :binary }
            },
            required: [ :file ]
          }

          response '201', 'Companies imported successfully' do
            schema type: :object,
                   properties: {
                     data: { type: :array,
                             items: { '$ref' => '#/components/schemas/company' }
                     },
                     metadata: { type: :object,
                                 properties: {
                                   total_count: { type: :number }
                                 }
                     }
                   },
                   required: [ :data, :metadata ]
            let(:file) { fixture_file_upload('companies.csv', 'text/csv') }

            run_test! do |response|
              json = JSON.parse(response.body)
              expect(json['data'].size).to eq(2)
              expect(Company.count).to eq(2)

              json['data'] = json['data'].map { |c| c.deep_except!("id") }
              expect(json).to match_snapshot('requests/api/v1/companies/import')
            end
          end

          response '400', 'Invalid CSV file' do
            schema '$ref' => '#/components/schemas/bad_request'
            let(:file) { fixture_file_upload('invalid_data_companies.csv', 'text/csv') }

            run_test! do |response|
              json = JSON.parse(response.body)
              expect(json['errors']).to eq([ "Addresses street can't be blank", "Csv invalid data for company starting at row: 4" ])
              expect(Company.count).to eq(0)
            end
          end

          context "with duplicates" do
            response '400', 'Invalid CSV file' do
              schema '$ref' => '#/components/schemas/bad_request'
              let(:file) { fixture_file_upload('invalid_uniq_companies.csv', 'text/csv') }

              run_test! do |response|
                json = JSON.parse(response.body)
                expect(json['errors']).to eq([ "Registration number has already been taken", "Csv invalid data for company starting at row: 4" ])
                expect(Company.count).to eq(0)
              end
            end

            context "when company already exist in db" do
              before do
                create(:company, registration_number: 123456789)
              end

              response '400', 'Data already exists in db' do
                schema '$ref' => '#/components/schemas/bad_request'
                let(:file) { fixture_file_upload('companies.csv', 'text/csv') }

                run_test! do |response|
                  json = JSON.parse(response.body)
                  expect(json['errors']).to eq([ "Registration number has already been taken", "Csv invalid data for company starting at row: 2" ])
                  expect(Company.count).to eq(1)
                  expect(Address.count).to eq(1)
                end
              end
            end
          end

          response '400', 'Bad request' do
            schema '$ref' => '#/components/schemas/bad_request'
            let(:file) { }

            run_test! do |response|
              json = JSON.parse(response.body)
              expect(json['errors']).to eq([ "param is missing or the value is empty or invalid: file" ])
            end
          end
        end
      end

      path '/api/v1/companies/import_async' do
        post 'Bulk async Import Companies via CSV' do
          tags 'Companies'
          consumes 'multipart/form-data'
          produces 'application/json'

          parameter name: :file, in: :formData, schema: {
            type: :object,
            properties: {
              file: { type: :string, format: :binary }
            },
            required: [ :file ]
          }

          response '201', 'Companies import created successfully' do
            schema type: :object,
                   properties: {
                     import_id: { type: :string }
                   },
                   required: [ :import_id ]
            let(:file) { fixture_file_upload('companies.csv', 'text/csv') }

            before do
              ActiveJob::Base.queue_adapter.enqueued_jobs = []
            end

            run_test! do |response|
              import_id = JSON.parse(response.body).fetch('import_id')
              import = Import.find(import_id)
              expect(import.status).to eq(Import.statuses[:pending])

              scheduled_jobs = ActiveJob::Base.queue_adapter.enqueued_jobs
              expect(scheduled_jobs.count).to eq(1)
              expect(scheduled_jobs.first['job_class']).to eq('ImportCompaniesJob')
              expect(scheduled_jobs.first['arguments']).to eq([ import_id ])
            end
          end

          response '400', 'Bad request' do
            schema '$ref' => '#/components/schemas/bad_request'
            let(:file) { }

            run_test! do |response|
              json = JSON.parse(response.body)
              expect(json['errors']).to eq([ "param is missing or the value is empty or invalid: file" ])
            end
          end
        end
      end
    end
  end
end
