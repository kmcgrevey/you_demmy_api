require "rails_helper"

RSpec.describe Api::V1::CommentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/articles/1/comments")
        .to route_to("api/v1/comments#index", article_id: "1")
    end

    it "routes to #create" do
      expect(post: "/api/v1/articles/1/comments")
        .to route_to("api/v1/comments#create", article_id: "1")
    end
  end

end
