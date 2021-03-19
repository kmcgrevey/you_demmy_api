class Api::V1::AccessTokensController < ApplicationController

  def create
    auth = UserAuthenticatorService.new(params[:code])
    auth.perform
  end
end
