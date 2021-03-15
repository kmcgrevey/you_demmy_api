require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "#validations" do
    subject { build(:article) }

    it { should validate_presence_of :title }
    it { should validate_presence_of :content }
    it { should validate_presence_of :slug }
    it { should validate_uniqueness_of :slug }
  end
  
end
