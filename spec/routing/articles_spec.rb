require 'rails_helper'

RSpec.describe "/articles routes" do
  it "routes to articles#index" do
    aggregate_failures do
      expect(get "/api/v1/articles").to route_to("api/v1/articles#index")
      expect(get "/api/v1/articles?page[number]=3").to route_to("api/v1/articles#index", page: { "number" => "3" })
    end
  end

end