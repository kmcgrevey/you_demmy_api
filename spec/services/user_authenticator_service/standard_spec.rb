require 'rails_helper'

describe UserAuthenticatorService::Standard do
  describe "#perform" do
    let(:authenticator) { described_class.new('jsmith', 'password') }

    subject { authenticator.perform }

    shared_examples "invalid authentication" do
      before { user }

      it "should raise an error" do
        expect{ subject }.to raise_error(
          UserAuthenticatorService::Standard::AuthenticationError
        )
        expect(authenticator.user).to be_nil
      end
    end

    context "when invalid login" do
      let(:user) {create :user, login: "jdoe", password: "password"}
      it_behaves_like "invalid authentication"
    end

    context "when invalid password" do
      let(:user) {create :user, login: "jsmith", password: "wrong"}
      it_behaves_like "invalid authentication"
    end

    context "when successful credentials" do

    end
  end 

end