require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#validations" do
    subject { build(:user) }

    it { should validate_presence_of :provider }
    it { should validate_presence_of :login }
    it { should validate_uniqueness_of :login }

    context "standard provider" do
      subject { build(:user, login: "jsmith", password: nil, provider: "standard") }

      it { should validate_presence_of :password }
    end
  end

end
