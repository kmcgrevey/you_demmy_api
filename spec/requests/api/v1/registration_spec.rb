require 'rails_helper'

describe Api::V1::RegistrationController do
  describe "#create" do
    subject { post "/api/v1/sign_up", params: params }

    context "when invalid data provided" do
      let(:params) do
        {
          data: {
            attributes: {
              login: nil,
              password: nil
            }
          }
        }
      end

      it "should return 422 status code" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should not create a user" do
        expect { subject }.not_to change{ User.count }
      end

      xit "should return error messages in the response body" do
        subject
        expect(json_body[:errors]).to include(
          {
            'source' => { 'pointer' => '/data/attributes/login' },
            'detail' => "can't be blank"
          },
          {
            'source' => { 'pointer' => '/data/attributes/password' },
            'detail' => "can't be blank"
          }      
        )
      end
    end

    context 'when valid data provided' do
      let(:params) do
        {
          data: {
            attributes: {
              login: 'jsmith',
              password: 'password'
            }
          }
        }
      end

      it 'should return 201 http status code' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'should create a user' do
        expect(User.exists?(login: 'jsmith')).to be_falsey
        expect{ subject }.to change{ User.count }.by(1)
        expect(User.exists?(login: 'jsmith')).to be_truthy
      end
    end
  end

end
