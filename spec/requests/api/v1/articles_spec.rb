# json_body defined in ApiHelpers module to DRY, added to rails_helper

require "rails_helper"

RSpec.describe Api::V1::ArticlesController, type: :request do
  describe "#index" do
    it "returns a succesful response" do
      get "/api/v1/articles"
      
      expect(response).to have_http_status(:ok)
    end

    it "returns a list of articles with newest first" do
      article1 = create(:article, created_at: 1.hour.ago)
      article2 = create(:article)

      get "/api/v1/articles"

      expect(json_body[:data].class).to be(Array)
      expect(json_body[:data].count).to eq(2)
      expect(json_body[:data].first[:type]).to eq("article")
      
      ids = json_body[:data].map { |article| article[:id].to_i }
      expect(ids).to eq([article2.id, article1.id])
    end

    it "paginates results" do
      article1, article2, article3 = create_list(:article, 3)

      get "/api/v1/articles", params: { page: { number: 2, size: 1 } }

      expect(json_body[:data].length).to eq(1)
      expect(json_body[:data].first[:id]).to eq(article2.id.to_s)
    end

    it "contains pagination links in the response" do
      article1, article2, article3 = create_list(:article, 3)

      get "/api/v1/articles", params: { page: { number: 2, size: 1 } }

      expect(json_body[:links].length).to eq(5)
      expect(json_body[:links].keys).to contain_exactly(
        :first, :prev, :next, :last, :self
        )
    end
  end

  describe "#show" do
    let(:article) { create(:article) }

    subject { get "/api/v1/articles/#{article.id}" }

    before { subject }
    
    it "returns a successful response" do
      expect(response).to have_http_status(:ok)
    end

    it "returns a proper JSON response" do
      expect(json_body[:data][:id]).to eq(article.id.to_s)
      expect(json_body[:data][:type]).to eq("article")
      expect(json_body[:data][:attributes]).to eq(
        title: article.title,
        content: article.content,
        slug: article.slug
      )
    end      
  end

end