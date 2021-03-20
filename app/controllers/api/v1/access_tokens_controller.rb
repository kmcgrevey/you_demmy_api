class Api::V1::AccessTokensController < ApplicationController

  def create
    auth = UserAuthenticatorService.new(params[:code])
    auth.perform

    render json: {}, status: 201
  end
end
