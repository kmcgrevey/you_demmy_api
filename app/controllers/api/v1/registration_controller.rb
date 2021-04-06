class Api::V1::RegistrationController < ApplicationController
  skip_before_action :authorize!, only: :create

  def create
    user = User.new(registration_params.merge(provider: "standard"))
    user.save!
    render json: user, status: 201
  rescue ActiveRecord::RecordInvalid
    render json: user, adapter: :json_api,
    serializer: ErrorSerializer,
    status: 422
  end

  private

  def registration_params
    params.require(:data).require(:attributes).
      permit(:login, :password) ||
      ApplicationController::Parameters.new
  end

end