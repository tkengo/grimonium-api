class Api::ApplicationController < ApplicationController
  after_action :cors
  skip_before_action :verify_authenticity_token

  def render_validation_error(message = '', errors = [])
    render json: {
      message: message,
      errors: errors,
    }, status: :unprocessable_entity
  end

  def cors
    response.header['Access-Control-Allow-Origin'] = '*'
  end
end
