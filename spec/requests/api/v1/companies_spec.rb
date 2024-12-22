require 'swagger_helper'

describe 'Companies API' do
  path '/api/v1/companies' do
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
          expect(json['errors']).to eq(["Name can't be blank",
                                        "Registration number can't be blank",
                                        "Registration number is not a number",
                                        "Addresses must have at least one"
                                       ])
        end
      end
    end
  end
end
