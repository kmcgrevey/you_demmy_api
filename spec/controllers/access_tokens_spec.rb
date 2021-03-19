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

    end
  end

end
