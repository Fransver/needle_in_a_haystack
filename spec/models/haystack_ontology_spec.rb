require "rails_helper"

RSpec.describe NeedleInAHaystack::HaystackOntology do
  after { described_class.reload! }

  describe ".find_tag" do
    it "finds a top-level node" do
      node = described_class.find_tag("site")
      expect(node["name"]).to eq("site")
      expect(node["path"]).to eq("site")
      expect(node["description"]).to be_present
    end

    it "descends through children for a dotted path" do
      node = described_class.find_tag("site.building")
      expect(node["name"]).to eq("building")
      expect(node["path"]).to eq("site.building")
    end

    it "returns nil for unknown paths and nil input" do
      expect(described_class.find_tag("does.not.exist")).to be_nil
      expect(described_class.find_tag("site.nope")).to be_nil
      expect(described_class.find_tag(nil)).to be_nil
    end
  end

  describe ".import_full_ontology" do
    it "materialises the tree and wires up parents" do
      described_class.import_full_ontology

      site = NeedleInAHaystack::HaystackTag.find_by(name: "site")
      building = NeedleInAHaystack::HaystackTag.find_by(name: "building")

      expect(site).to be_present
      expect(site.root?).to be true
      expect(building.parent_tag).to eq(site)
    end

    it "is idempotent" do
      described_class.import_full_ontology
      count = NeedleInAHaystack::HaystackTag.count
      described_class.import_full_ontology
      expect(NeedleInAHaystack::HaystackTag.count).to eq(count)
    end
  end

  describe ".find_or_create_tag" do
    it "creates a tag from the ontology" do
      tag = described_class.find_or_create_tag("site.building")
      expect(tag.name).to eq("building")
      expect(tag.description).to be_present
    end

    it "returns nil when the path is unknown" do
      expect(described_class.find_or_create_tag("nope")).to be_nil
    end
  end
end
