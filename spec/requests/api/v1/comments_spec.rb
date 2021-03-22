require 'rails_helper'

RSpec.describe "/comments", type: :request do
  let(:valid_headers) {
    {}
  }

  let(:article) { create :article }

  describe "GET /index" do
    it "renders a successful response" do
      get api_v1_article_comments_path(article.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    let(:valid_attributes) { { content: "Some test comment content" } }
    let(:invalid_attributes) { { content: "" } }

    context "when not authorized" do
      subject { post api_v1_article_comments_path(article.id) }
      it_behaves_like "unauthorized_requests"
    end

    context "when authorized" do
      let(:user) { create :user }
      
      before { allow_any_instance_of(ApplicationController)
        .to receive(:current_user).and_return(user) }

      context "with valid parameters" do
        it "creates a new Comment" do
          expect {
            post api_v1_article_comments_path(article.id),
              params: { article_id: article.id, comment: valid_attributes }
          }.to change(Comment, :count).by(1)
        end
    
        it "renders a JSON response with the new comment" do
          post api_v1_article_comments_path(article.id),
              params: { article_id: article.id, comment: valid_attributes }
          
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "does not create a new Comment" do
          expect {
            post api_v1_article_comments_path(article.id),
                params: { article_id: article.id, comment: invalid_attributes }
          }.to change(Comment, :count).by(0)
        end

        it "renders a JSON response with errors for the new comment" do
          post api_v1_article_comments_path(article.id),
              params: { article_id: article.id, comment: invalid_attributes }
              
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq("application/json")
        end
      end
    end
  end

end
