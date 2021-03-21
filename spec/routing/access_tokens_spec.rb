require 'rails_helper'

RSpec.describe "access tokens routes" do
  it "should route to access_tokens#create" do
    expect(post "/api/v1/login").to route_to("api/v1/access_tokens#create")
  end

  it "should route to access-tokens#destroy" do
    expect(delete "/api/v1/logout").to route_to("api/v1/access_tokens#destroy")
  end

end