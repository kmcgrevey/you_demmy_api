require 'rails_helper'

RSpec.describe "access tokens routes" do
  it "should route to access_tokens#create" do
    expect(post "/api/v1/login").to route_to("api/v1/access_tokens#create")
  end

  # it "routes to articles#show" do
  #   expect(get "/api/v1/articles/1").to route_to("api/v1/articles#show", id: "1")
  # end

end