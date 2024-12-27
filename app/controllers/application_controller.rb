class ApplicationController < ActionController::API
  rescue_from ActionDispatch::Http::Parameters::ParseError,
              ActionController::BadRequest,
              ActionController::ParameterMissing,
              Rack::QueryParser::ParameterTypeError,
              Rack::QueryParser::InvalidParameterError, with: :handle_default_bad_request_errors

  private

  def handle_default_bad_request_errors(exception)
    bad_request(exception.message)
  end

  def bad_request(errors)
    errors = [ errors ].flatten
    render json: {
      errors: errors.flat_map { |e| e.is_a?(ActiveModel::Errors) ? e.full_messages : e },
      details: errors.select { |e| e.is_a?(ActiveModel::Errors) }.map(&:to_hash)
    }, status: :bad_request
  end
end
