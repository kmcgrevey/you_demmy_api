require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "#validations" do
    subject { build(:article) }

    it { should validate_presence_of :title }
    it { should validate_presence_of :content }
    it { should validate_presence_of :slug }
    it { should validate_uniqueness_of :slug }
  end

  describe ".recent" do
    it "returns newest articles first" do
      article1 = create(:article, created_at: 1.hour.ago)
      article2 = create(:article)

      expect(described_class.recent).to eq([article2, article1])

      article2.update_column(:created_at, 4.hours.ago)

      expect(described_class.recent).to eq([article1, article2])
    end
  end

end
