class Api::V1::AccessTokensController < ApplicationController
  
  def create
    auth = UserAuthenticatorService.new(params[:code])
    auth.perform

    render json: AccessTokenSerializer.new(auth.access_token),
      status: 201
  end

  def destroy
    provided_token = request.authorization&.gsub("Bearer ", "")
    access_token = AccessToken.find_by(token: provided_token)
    current_user = access_token&.user
    # &. syntax is safe navigation operator, allows to return nil if nil

    raise AuthorizationError unless current_user

    current_user.access_token.destroy
  end

end
