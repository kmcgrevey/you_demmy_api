class ApplicationController < ActionController::API
  include JsonapiErrorsHandler
  
  class AuthorizationError < StandardError; end

  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }

  rescue_from UserAuthenticatorService::Oauth::AuthenticationError, with:
    :authentication_oauth_error
  
  rescue_from UserAuthenticatorService::Standard::AuthenticationError, with:
    :authentication_standard_error

  rescue_from AuthorizationError, with: :authorization_error

  before_action :authorize!

  ErrorMapper.map_errors!(
      'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound'
  )

  private

  def authorize!
    raise AuthorizationError unless current_user
  end

  def access_token
    provided_token = request.authorization&.gsub("Bearer ", "")
    @access_token = AccessToken.find_by(token: provided_token)
  end

  def current_user
    @current_user = access_token&.user
  end

  def authentication_oauth_error
    error = {
      "status": "401",
      "source": { "pointer": "/code" },
      "title":  "Authentication code is invalid",
      "detail": "You must provide valid code to exchange it for token."
    }
    render json: { "errors": [ error ]}, status: 401
  end
  
  def authentication_standard_error
    error = {
      "status": "401",
      "source": { "pointer": "/data/attributes/password" },
      "title":  "Invalid login or password",
      "detail": "You must provide valid credentials to exchange them for token."
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
