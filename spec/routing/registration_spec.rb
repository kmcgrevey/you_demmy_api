require 'rails_helper'

describe "registration routes" do
  it "routes to registration#create" do
    expect(post "/api/v1/sign_up").to route_to("api/v1/registration#create")
  end
end
