require 'rails_helper'

RSpec.describe "access tokens routes" do
  it "should route to access_tokens#create" do
    expect(post "/api/v1/login").to route_to("api/v1/access_tokens#create")
  end
  
end