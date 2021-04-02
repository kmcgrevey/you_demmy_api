require 'rails_helper'

RSpec.describe "/comments", type: :request do
  let(:article) { create :article }

  describe "GET /index" do
    subject { get api_v1_article_comments_path(article.id) }
    
    it "renders a successful response" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "should only return comments belonging to article" do
      create_list(:comment, 3)
      comment = create(:comment, article_id: article.id)

      subject
 
      expect(json_body[:data].length).to eq(1)
      expect(json_body[:data].first[:id]).to eq(comment.id.to_s)
    end

    it "paginates results" do
      comment1, comment2, comment3 = create_list(:comment, 3, article_id: article.id)

      get api_v1_article_comments_path(article.id),
        params: { page: { number: 2, size: 1 } }

      expect(json_body[:data].length).to eq(1)
      expect(json_body[:data].first[:id]).to eq(comment2.id.to_s)
    end

    it "should have proper JSON body" do
      comment = create(:comment, article_id: article.id)

      subject

      expect(json_body[:data].first[:attributes]).to eq(content: comment.content)
    end

    it "should have related objects information in the response" do
      create(:comment, article_id: article.id)

      subject

      expect(json_body[:data].first[:relationships]).to have_key(:article)
      expect(json_body[:data].first[:relationships]).to have_key(:user)
    end
  end

  describe "POST /create" do
 
    context "when not authorized" do
      subject { post api_v1_article_comments_path(article.id) }
      it_behaves_like "forbidden_requests"
    end

    context "when authorized" do
      let(:valid_attributes) { { content: "Some test comment content" } }
      let(:invalid_attributes) { { content: "" } }
      let(:user) { create :user }
      
      before { allow_any_instance_of(ApplicationController)
        .to receive(:current_user).and_return(user) }

      context "with valid parameters" do
        subject {
          post api_v1_article_comments_path(article.id),
            params: { article_id: article.id, comment: valid_attributes }
          }

        it "returns 201 status code" do
          subject
          expect(response).to have_http_status(:created)
        end

        it "creates a new Comment" do
          expect { subject }.to change(article.comments, :count).by(1)
        end
    
        it "renders a JSON response with the new comment" do
          subject
          expect(json_body[:data][:attributes]).to eq({ content: "Some test comment content" })
        end
      end

      context "with invalid parameters" do
        subject {
          post api_v1_article_comments_path(article.id),
            params: { article_id: article.id, comment: invalid_attributes }
        }

        it "should return 422 status code" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end
        
        it "does not create a new Comment" do
          expect { subject }.to change(article.comments, :count).by(0)
        end

        it "renders a JSON response with errors for the new comment" do
          subject
          expect(response.content_type).to eq("application/json")
        end
      end
    end
  end

end
