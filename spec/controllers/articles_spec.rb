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

    context "when invalid parameters provided" do

    end
  end


end