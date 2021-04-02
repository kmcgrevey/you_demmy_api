require 'rails_helper'

shared_examples "unauthorized_standard_requests" do
  let(:authentication_error) do
    {
      "status": "401",
      "source": { "pointer": "/data/attributes/password" },
      "title":  "Invalid login or password",
      "detail": "You must provide valid credentials to exchange them for token."
    }
  end

  it "should return a 401 status code" do
    subject
    expect(response).to have_http_status(401)
  end

  it "should return proper JSON body" do
    subject
    expect(json_body[:errors]).to include(authentication_error)
  end
end

shared_examples_for "unauthorized_oauth_requests" do
  let(:authentication_error) do
    {
      "status": "401",
      "source": { "pointer": "/code" },
      "title":  "Authentication code is invalid",
      "detail": "You must provide valid code in order to exchange it for token."
    }
  end

  it 'should return 401 status code' do
    subject
    expect(response).to have_http_status(401)
  end

  it 'should return proper JSON body' do
    subject
    expect(json_body[:errors]).to include(authentication_error)
  end
end

shared_examples "forbidden_requests" do
  let(:authorization_error) do
    {
      "status": "403",
      "source": { "pointer": "/headers/authorization" },
      "title":  "Not authorized",
      "detail": "You do not have rights to access this resource."
    }
  end

  it "should return a 403 status code" do
    subject
    expect(response).to have_http_status(:forbidden)
  end

  it "should return proper error JSON body" do
    subject
    expect(json_body[:errors]).to include(authorization_error)
  end
end
