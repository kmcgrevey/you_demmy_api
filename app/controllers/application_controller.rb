class ApplicationController < ActionController::API
  include JsonapiErrorsHandler
  
  class AuthorizationError < StandardError; end
  
  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }

  rescue_from UserAuthenticatorService::AuthenticationError, with:
    :authentication_error

  rescue_from AuthorizationError, with:
    :authorization_error

  ErrorMapper.map_errors!(
      'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound'
  )

  private

  def authentication_error
    error = {
      "status": "401",
      "source": { "pointer": "/code" },
      "title":  "Authentication code is invalid",
      "detail": "You must provide valid code to exchange it for token."
    }
    render json: { "errors": [ error ]}, status: 401
  end

  def authorization_error
    error = {
      "status": "403",
      "source": { "pointer": "/headers/authorization" },
      "title":  "Not authorized",
      "detail": "You do not have rights to access this resource."
    }
    render json: { "errors": [ error ]}, status: 403
  end

end
