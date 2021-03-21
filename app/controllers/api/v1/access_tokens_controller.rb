class Api::V1::AccessTokensController < ApplicationController
  skip_before_action :authorize!, only: :create

  def create
    auth = UserAuthenticatorService.new(params[:code])
    auth.perform

    render json: AccessTokenSerializer.new(auth.access_token),
      status: 201
  end

  def destroy
    current_user.access_token.destroy
  end

end
