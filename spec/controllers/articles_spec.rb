require 'rails_helper'

RSpec.describe Api::V1::ArticlesController, type: :controller do
  describe "#create" do
    subject { post :create }
    
    context "when no code provided" do
      it_behaves_like "unauthorized_requests"
    end
   
    context "when invalid code provided" do
      before { request.headers["authorization"] = "Invalid token" }
      it_behaves_like "unauthorized_requests"
    end

    context "when authorized" do
      let(:access_token) { create :access_token }
      before { request.headers["authorization"] = "Bearer #{access_token.token}" }

      context "when invalid parameters provided" do
        let(:invalid_attributes) do
          {
            data: {
              attributes: {
                title: "",
                content: ""
              }
            }
          }
        end

        subject { post :create, params: invalid_attributes }

        it "should return 422 status code" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        xit "should return proper error JSON" do
          # need to refactor test due to reliance on 
          # depricated 'active_model_sericalizers gem
          subject
          expect(json_body[:errors]).to include(
            {
              "source" => { "pointer" => "/data/attributes/title" },
              "detail" =>  "can't be blank"
            },
            {
              "source" => { "pointer" => "/data/attributes/content" },
              "detail" =>  "can't be blank"
            },
            {
              "source" => { "pointer" => "/data/attributes/slug" },
              "detail" =>  "can't be blank"
            }
          )
        end
      end

      context "when success request sent" do
        let(:valid_attributes) do
          {
            data: {
              attributes: {
                title: "Test Title",
                content: "Test article content",
                slug: "test-title-slug"
              }
            }
          }
        end

        subject { post :create, params: valid_attributes }

        it "should have 201 status code" do
          subject
          expect(response).to have_http_status(:created)
        end

        it "should have proper JSON body" do
          subject
          expect(json_body[:data][:attributes]).to include(valid_attributes[:data][:attributes])
        end

        it "should create the article" do
          expect { subject }.to change{ Article.count }.by(1)
        end
      end
    end
  end

  describe "#update" do
    let(:user) { create :user }
    let(:article) { create :article, user: user }
    let(:access_token) { user.create_access_token }

    subject { patch :update, params: { id: article.id } }

    context "when no code provided" do
      it_behaves_like "unauthorized_requests"
    end
   
    context "when invalid code provided" do
      before { request.headers["authorization"] = "Invalid token" }
      it_behaves_like "unauthorized_requests"
    end

    context "when trying to update not owned article" do
      let(:other_user) { create :user }
      let(:other_article) { create :article, user: other_user }

      subject { patch :update, params: { id: other_article.id } }
      before { request.headers["authorization"] = "Bearer #{access_token.token}" }

      it_behaves_like "unauthorized_requests"
    end

    context "when authorized" do
      before { request.headers["authorization"] = "Bearer #{access_token.token}" }

      context "when invalid parameters provided" do
        let(:invalid_attributes) do
          {
            data: {
              attributes: {
                title: "Updated Title",
                content: ""
              }
            }
          }
        end

        subject { patch :update, params: invalid_attributes.merge(id: article.id) }

        it "should return 422 status code" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context "when success request sent" do
        before { request.headers["authorization"] = "Bearer #{access_token.token}" }

        let(:valid_attributes) do
          {
            data: {
              attributes: {
                title: "Updated Test Title",
                content: "Updated test article content"
              }
            }
          }
        end

        subject { patch :update, params: valid_attributes.merge(id: article.id) }

        it "should have 200 status code" do
          subject
          expect(response).to have_http_status(:ok)
        end

        it "should have proper JSON body" do
          subject
          expect(json_body[:data][:attributes]).to include(valid_attributes[:data][:attributes])
        end

        it "should update the article" do
          subject
          expect(article.reload.title).to eq(valid_attributes[:data][:attributes][:title])
        end
      end
    end
  end
  
  describe "#destroy" do
    let(:user) { create :user }
    let(:article) { create :article, user: user }
    let(:access_token) { user.create_access_token }

    subject { delete :destroy, params: { id: article.id } }

    context "when no code provided" do
      it_behaves_like "unauthorized_requests"
    end
   
    context "when invalid code provided" do
      before { request.headers["authorization"] = "Invalid token" }
      it_behaves_like "unauthorized_requests"
    end

    context "when trying to remove not owned article" do
      let(:other_user) { create :user }
      let(:other_article) { create :article, user: other_user }

      subject { delete :destroy, params: { id: other_article.id } }
      before { request.headers["authorization"] = "Bearer #{access_token.token}" }

      it_behaves_like "unauthorized_requests"
    end

    context "when authorized" do
      before { request.headers["authorization"] = "Bearer #{access_token.token}" }

      context "when success request sent" do
        before { request.headers["authorization"] = "Bearer #{access_token.token}" }

        subject { delete :destroy, params: { id: article.id } }

        it "should have 204 status code" do
          subject
          expect(response).to have_http_status(:no_content)
        end

        it "should have empty JSON body" do
          subject
          expect(response.body).to be_blank
        end

        it "should remove the article" do
          article
          expect { subject }.to change{ user.articles.count }.by(-1)
        end
      end
    end
  end

end