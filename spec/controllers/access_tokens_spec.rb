require 'rails_helper'

RSpec.describe Api::V1::AccessTokensController, type: :controller do
  describe "#create" do
    context "when invalid request" do
      let(:error) do
        {
          "status": "401",
          "source": { "pointer": "/code" },
          "title":  "Authentication code is invalid",
          "detail": "You must provide valid code to exchange it for token."
        }
      end

      subject { post :create }

      it "should return a 401 status code" do
        subject
        expect(response).to have_http_status(401)
      end

      it "should return proper JSON body" do
        subject
        expect(json_body[:errors]).to include(error)
      end
    end

    context "when successful request" do
      let(:user_data) do
        {
          login: 'jsmith1',
          url: 'http://example.com',
          avatar_url: 'http://example.com/avatar',
          name: 'John Smith'
        }
      end

      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return('validaccesstoken')

        allow_any_instance_of(Octokit::Client).to receive(
          :user).and_return(user_data)
      end

      subject { post :create, params: { code: 'valid_code' } }

      it "should return 201 status code" do
        subject
        expect(response).to have_http_status(:created)
      end

      it "should return proper JSON body" do
        expect{ subject }.to change{ User.count }.by(1)
        
        user = User.find_by(login: "jsmith1")

        expect(json_body[:data][:attributes]).to eq(
          { token: user.access_token.token })
      end
    end
  end

  describe "#destroy" do
    context "when invalid request" do
      let(:authorization_error) do
        {
          "status": "403",
          "source": { "pointer": "/headers/authorization" },
          "title":  "Not authorized",
          "detail": "You do not have rights to access this resource."
        }
      end

      subject { delete :destroy }

      it "should return a 403 status code" do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it "should return proper JSON body" do
        subject
        expect(json_body[:errors]).to include(authorization_error)
      end
    end

    context "when valid request" do

    end
  end

end
