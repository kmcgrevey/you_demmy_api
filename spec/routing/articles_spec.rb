require 'rails_helper'

RSpec.describe "/articles routes" do
  it "routes to articles#index" do
    aggregate_failures do
      expect(get "/api/v1/articles").to route_to("api/v1/articles#index")
      expect(get "/api/v1/articles?page[number]=3").to route_to("api/v1/articles#index", page: { "number" => "3" })
    end
  end

  it "routes to articles#show" do
    expect(get "/api/v1/articles/1").to route_to("api/v1/articles#show", id: "1")
  end
  
  it "routes to articles#create" do
    expect(post "/api/v1/articles").to route_to("api/v1/articles#create")
  end
  
  it "routes to articles#update" do
    expect(patch "/api/v1/articles/1").to route_to("api/v1/articles#update", id: "1")
    expect(put "/api/v1/articles/1").to route_to("api/v1/articles#update", id: "1")
  end
  
  it "routes to articles#destroy" do
    expect(delete "/api/v1/articles/1").to route_to("api/v1/articles#destroy", id: "1")
  end

end