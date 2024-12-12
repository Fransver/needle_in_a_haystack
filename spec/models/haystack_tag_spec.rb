require "rails_helper"

RSpec.describe HaystackTag, type: :model do
  describe "validations and associations" do
    subject { build(:haystack_tag) }

    # Validaties
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }

    # Associaties
    it { is_expected.to belong_to(:parent_tag).class_name("HaystackTag").optional }
    it { is_expected.to have_many(:children).class_name("HaystackTag").with_foreign_key("parent_tag_id").dependent(:destroy).inverse_of(:parent_tag) }
    it { is_expected.to have_many(:haystack_taggings).dependent(:destroy) }
    it { is_expected.to have_many(:taggables).through(:haystack_taggings).source(:taggable) }

    context "when creating duplicate names" do
      it "validates uniqueness within same parent" do
        parent = create(:haystack_tag)
        create(:haystack_tag, name: "test", parent_tag: parent)
        duplicate = build(:haystack_tag, name: "test", parent_tag: parent)

        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:name]).to include("Must be unique in same category")
      end

      it "allows same name under different parents" do
        parent1 = create(:haystack_tag)
        parent2 = create(:haystack_tag)
        create(:haystack_tag, name: "test", parent_tag: parent1)
        tag2 = build(:haystack_tag, name: "test", parent_tag: parent2)

        expect(tag2).to be_valid
      end
    end

    context "when validating identity" do
      it "Ensures uniqueness within the same parent" do
        parent = create(:haystack_tag)
        create(:haystack_tag, name: "unique_name", parent_tag: parent)
        duplicate = build(:haystack_tag, name: "unique_name", parent_tag: parent)

        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:name]).to include("Must be unique in same category")
      end
    end
  end

  describe "hierarchy functionality" do
    let(:root) { create(:haystack_tag, name: "root") }
    let(:child) { create(:haystack_tag, name: "child", parent_tag: root) }
    let(:grandchild) { create(:haystack_tag, name: "grandchild", parent_tag: child) }

    context "when testing basic hierarchy methods" do
      before { grandchild } # Ensure the complete hierarchy exists

      it "correctly identifies node positions" do
        expect(root.root?).to be true
        expect(child.root?).to be false
        expect(grandchild.leaf?).to be true
        expect(child.leaf?).to be false
      end

      it "calculates correct depth" do
        expect(root.depth).to eq(0)
        expect(child.depth).to eq(1)
        expect(grandchild.depth).to eq(2)
      end

      it "returns correct ancestors" do
        expect(grandchild.ancestors).to eq([child, root])
        expect(child.ancestors).to eq([root])
        expect(root.ancestors).to be_empty
      end
    end

    context "with path operations" do
      before { grandchild }

      it "finds tags by valid paths" do
        expect(described_class.find_by_path("root")).to eq(root)
        expect(described_class.find_by_path("root.child")).to eq(child)
        expect(described_class.find_by_path("root.child.grandchild")).to eq(grandchild)
      end

      it "handles invalid paths appropriately" do
        expect(described_class.find_by_path("invalid")).to be_nil
        expect(described_class.find_by_path("root.invalid")).to be_nil
        expect(described_class.find_by_path("root.child.invalid")).to be_nil
      end
    end

    context "when sibling and descendant operations are performed" do
      let(:sibling) { create(:haystack_tag, name: "sibling", parent_tag: root) }

      before do
        grandchild
        sibling
      end

      it "returns all descendants" do
        expect(root.descendants).to contain_exactly(child, grandchild, sibling)
        expect(child.descendants).to contain_exactly(grandchild)
        expect(grandchild.descendants).to be_empty
      end
    end
  end
end
