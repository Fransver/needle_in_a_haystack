require "rails_helper"

RSpec.describe "Query strategies" do
  let(:temp) { create(:haystack_tag, name: "temp") }
  let(:sensor) { create(:haystack_tag, name: "sensor") }
  let(:both) { Widget.create!(name: "both") }
  let(:only_temp) { Widget.create!(name: "only_temp") }

  before do
    both.add_haystack_tags(temp, sensor)
    only_temp.add_haystack_tag(temp)
  end

  def run(strategy)
    NeedleInAHaystack::QueryContext.new(strategy).execute
  end

  describe NeedleInAHaystack::FindPointsWithTagStrategy do
    it "finds records with a single tag" do
      result = run(described_class.new(Widget, temp))
      expect(result).to contain_exactly(both, only_temp)
    end
  end

  describe NeedleInAHaystack::FindByTagsStrategy do
    it "finds records with ANY of the tags" do
      result = run(described_class.new(Widget, [temp, sensor]))
      expect(result).to contain_exactly(both, only_temp)
    end
  end

  describe NeedleInAHaystack::FindPointsWithMultipleTagsStrategy do
    it "finds records with ALL of the tags" do
      result = run(described_class.new(Widget, [temp, sensor]))
      expect(result).to contain_exactly(both)
    end
  end
end
