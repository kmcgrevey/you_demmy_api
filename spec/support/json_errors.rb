require 'rails_helper'

shared_examples "unauthenticated_requests" do
  let(:authentication_error) do
    {
      "status": "401",
      "source": { "pointer": "/code" },
      "title":  "Authentication code is invalid",
      "detail": "You must provide valid code to exchange it for token."
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

shared_examples "unauthorized_requests" do
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
