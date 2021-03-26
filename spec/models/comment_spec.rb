require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "#validations" do
    it { should validate_presence_of :content }

    it "should have a valid factory" do
      expect(build :comment).to be_valid
    end
  end
end
