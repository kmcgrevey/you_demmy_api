require 'rails_helper'

RSpec.describe UserAuthenticatorService, type: :service do
  let(:user) { create :user, login: "jsmith", password: "password" }

  shared_examples "token_authenticator" do
    it "should create and set users access token" do
      expect(authenticator.authenticator).to receive(:perform)
        .and_return(true)
      expect(authenticator.authenticator).to receive(:user)
        .at_least(:once).and_return(user)

      expect { authenticator.perform }.to change{ AccessToken.count}.by(1)
      expect(authenticator.access_token).to be_present
    end
  end

  context "when initialized with code" do
    let(:authenticator) { described_class.new(code: "sample") }
    let(:authenticator_class) { UserAuthenticatorService::Oauth }

    describe "#initialize" do
      it "should initialize correct authenticator" do
        expect(authenticator_class).to receive(:new).with("sample")
        authenticator
      end
    end

      it_behaves_like "token_authenticator"
  end

  context "when initialized with login and password" do
    let(:authenticator) { described_class.new(login: "jsmith", password: "password") }
    let(:authenticator_class) { UserAuthenticatorService::Standard }

    describe "#initialize" do
      it "should initialize correct authenticator" do
        expect(authenticator_class).to receive(:new).with("jsmith", "password")
        authenticator
      end
    end
    
    it_behaves_like "token_authenticator"
  end

end
