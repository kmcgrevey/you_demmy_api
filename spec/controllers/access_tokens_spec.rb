require 'rails_helper'
# NOTE: test setups moved to spec/support/json_errors.rb to DRY code

RSpec.describe Api::V1::AccessTokensController, type: :controller do
  describe "POST #create" do
    context "when no code provided" do
      subject { post :create }

      it_behaves_like "unauthenticated_requests"
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

  describe "DELETE #destroy" do
    subject { delete :destroy }
    
    context "when no authorization header provided" do
      it_behaves_like "unauthorized_requests"
    end

    context "when invalid authorization header provided" do
      before { request.headers["authorization"] = "Invalid token" }

      it_behaves_like "unauthorized_requests"
    end

    context "when valid request" do
      let(:user) { create :user }
      let(:access_token) { user.create_access_token }

      before { request.headers["authorization"] = "Bearer #{access_token.token}" }

      it "should return 204 status code" do
        subject
        expect(response).to have_http_status(:no_content)        
      end

      it "should remove proper access token" do
        expect{ subject }.to change{ AccessToken.count }.by(-1)
      end
    end
  end

end
