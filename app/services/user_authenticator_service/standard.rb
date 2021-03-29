class UserAuthenticatorService::Standard < UserAuthenticatorService
  class AuthenticationError < StandardError; end

  def initialize(login: nil, password: nil)

  end

  def perform
    raise AuthenticationError
  end

end
