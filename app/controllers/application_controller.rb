class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :handle_param_missing_error

  private

  def handle_param_missing_error(exception)
    bad_request(exception.message)
  end

  def bad_request(errors)
    render json: { errors: [ errors ].flatten }, status: :bad_request
  end
end
