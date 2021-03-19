require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  describe "#validations" do
    subject { build(:access_token) }

    it { should validate_presence_of :token }
    it { should validate_uniqueness_of :token }
    it { should belong_to :user }
  end

  describe "#generate_token" do
    it "should have a token present after inialize" do
      expect(AccessToken.new.token).to be_present
    end

    it "should generate uniq token" do
      user = create :user
      expect{ user.create_access_token }.to change{ AccessToken.count }.by(1)
      expect(user.build_access_token).to be_valid
    end
  end

end
