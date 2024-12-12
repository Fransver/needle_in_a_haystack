require "rails_helper"

RSpec.describe NeedleInAHaystack::Taggable do
  let(:widget) { Widget.create!(name: "w1") }
  let(:temp) { create(:haystack_tag, name: "temp") }
  let(:sensor) { create(:haystack_tag, name: "sensor") }

  describe "#add_haystack_tag" do
    it "attaches a tag" do
      widget.add_haystack_tag(temp)
      expect(widget.haystack_tags).to contain_exactly(temp)
    end

    it "is idempotent" do
      widget.add_haystack_tag(temp)
      widget.add_haystack_tag(temp)
      expect(widget.haystack_taggings.count).to eq(1)
    end
  end

  describe "#add_haystack_tags" do
    it "attaches several tags at once" do
      widget.add_haystack_tags(temp, sensor)
      expect(widget.haystack_tags).to contain_exactly(temp, sensor)
    end
  end

  describe "#remove_haystack_tag" do
    it "detaches a tag" do
      widget.add_haystack_tag(temp)
      expect(widget.remove_haystack_tag(temp)).to be true
      expect(widget.reload.haystack_tags).to be_empty
    end
  end

  describe "#haystack_tagged_with?" do
    it "reports presence by tag name" do
      widget.add_haystack_tag(temp)
      expect(widget.haystack_tagged_with?("temp")).to be true
      expect(widget.haystack_tagged_with?("sensor")).to be false
    end
  end

  describe ".tagged_with / .tagged_with_any" do
    let(:other) { Widget.create!(name: "w2") }

    before do
      widget.add_haystack_tags(temp, sensor)
      other.add_haystack_tag(temp)
    end

    it "matches records carrying ALL tags" do
      expect(Widget.tagged_with(temp, sensor)).to contain_exactly(widget)
    end

    it "matches records carrying ANY tag" do
      expect(Widget.tagged_with_any(temp, sensor)).to contain_exactly(widget, other)
    end

    it "returns nothing for an empty tag list" do
      expect(Widget.tagged_with).to be_empty
      expect(Widget.tagged_with_any).to be_empty
    end
  end
end
