require 'rails_helper'

RSpec.describe UserAuthenticatorService, type: :service do
  context "when initialized with code" do
    let(:authenticator) { described_class.new(code: "sample") }
    let(:authenticator_class) { UserAuthenticatorService::Oauth }

    describe "#initialize" do
      it "should initialize correct authenticator" do
        expect(authenticator_class).to receive(:new).with("sample")
        authenticator
      end
    end
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
  end

end
