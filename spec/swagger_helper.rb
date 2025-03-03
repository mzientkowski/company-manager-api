# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Company Manager API V1',
        version: 'v1'
      },
      components: {
        schemas: {
          pagination: {
            type: :object,
            properties: {
              count: { type: :number },
              pages: { type: :number },
              limit: { type: :number },
              page: { type: :number },
              next: { type: :number, nullable: true },
              prev: { type: :number, nullable: true }
            }, required: %i[count pages limit page]
          },
          bad_request: {
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: { type: :string }
              },
              details: {
                type: :array,
                items: { type: :object }
              }
            }, required: %i[errors]
          },
          address: {
            type: :object,
            properties: {
              id: { type: :integer },
              street: { type: :string },
              city: { type: :string },
              postal_code: { type: :string, nullable: true },
              country: { type: :string }
            },
            required: %i[id street city country]
          },
          addresses: {
            type: :array,
            items: { '$ref' => '#/components/schemas/address' }
          },
          company: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              registration_number: { type: :integer },
              addresses: { '$ref' => '#/components/schemas/addresses' }
            },
            required: %i[id name registration_number]
          },
          companies: {
            type: :array,
            items: { '$ref' => '#/components/schemas/company' }
          },
          companies_index: {
            type: :object,
            properties: {
              data: { '$ref' => '#/components/schemas/companies' },
              pagination: { '$ref' => '#/components/schemas/pagination' }
            },
            required: [ :data, :pagination ]
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml

  config.openapi_all_properties_required = true
end
