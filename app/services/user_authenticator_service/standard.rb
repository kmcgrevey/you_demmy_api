class UserAuthenticatorService::Standard < UserAuthenticatorService
  class AuthenticationError < StandardError; end

  def initialize(login, password)

  end

  def perform
    raise AuthenticationError
  end

end
