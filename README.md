# Needle in a Haystack

<img src="storage/logo.jpg" alt="Logo" width="40%">

# Table of Contents

- [Needle in a Haystack](#needle-in-a-haystack)
  - [Models](#models)
    - [HaystackTag](#haystacktag)
      - [Attributes](#attributes)
      - [Validations](#validations)
      - [Associations](#associations)
      - [Methods](#methods)
      - [Example Usage](#example-usage)
    - [HaystackTagging](#haystacktagging)
      - [Associations](#associations-1)
      - [Example Usage](#example-usage-1)
  - [Ontology and Factory](#ontology-and-factory)
    - [HaystackOntology](#haystackontology)
      - [Key Methods](#key-methods)
      - [Example Usage](#example-usage-2)
    - [HaystackFactory](#haystackfactory)
      - [Key Methods](#key-methods-1)
      - [How They Work Together](#how-they-work-together)
      - [Example Usage](#example-usage-3)
  - [Query Strategies](#query-strategies)
    - [QueryContext](#querycontext)
      - [Example Usage](#example-usage-4)
    - [QueryStrategy](#querystrategy)
    - [FindByTagsStrategy](#findbytagsstrategy)
    - [FindPointsWithTagStrategy](#findpointswithtagstrategy)
  - [HaystackTag Validations and Associations](#haystacktag-validations-and-associations)
  - [Duplicate Name Validation](#duplicate-name-validation)
  - [Hierarchy Functionality](#hierarchy-functionality)
  - [Path Operations](#path-operations)
  - [Descendant and Sibling Operations](#descendant-and-sibling-operations)

## Models

### HaystackTag

The `HaystackTag` class represents tags in a hierarchical structure. Each tag can have a parent tag and multiple child tags. This model is used to create and manage a tree structure of tags.

#### Attributes

- `name`: The name of the tag (required and unique).
- `description`: A description of the tag (required).
- `parent_tag`: An optional reference to the parent tag.

#### Validations

- `name`: Must be present and unique.
- `description`: Must be present.
- `prevent_circular_reference`: Prevents circular references in the tag hierarchy.

#### Associations

- `belongs_to :parent_tag`: Refers to the parent tag.
- `has_many :children`: Refers to the child tags.
- `has_many :haystack_taggings`: Refers to the taggings that use this tag.
- `has_many :taggables`: Refers to the objects tagged with this tag.

#### Methods

- `ancestors`: Returns an array of all ancestor tags.
- `full_path`: Returns the full path of the tag in the tree structure.
- `self.find_by_path(path)`: Finds a tag based on a path.
- `descendants`: Returns an array of all descendant tags.
- `siblings`: Returns an array of all sibling tags.
- `root?`: Checks if the tag is a root tag.
- `leaf?`: Checks if the tag is a leaf tag.
- `depth`: Returns the depth of the tag in the tree structure.

#### Example Usage

```ruby
# Creating a new tag
root_tag = HaystackTag.create(name: "root", description: "Root tag")

# Creating a child tag
child_tag = HaystackTag.create(name: "child", description: "Child tag", parent_tag: root_tag)

# Getting the full path of a tag
puts child_tag.full_path # Output: "root > child"

# Getting all ancestor tags
ancestors = child_tag.ancestors
```

### HaystackTagging

The `HaystackTagging` class represents the relationship between tags and taggable objects (polymorphic). This model is used to tag objects with `HaystackTag` tags.

#### Associations

- `belongs_to :haystack_tag`: Refers to the `HaystackTag`.
- `belongs_to :taggable`: Refers to the taggable object (polymorphic).

#### Example Usage

```ruby
# Creating a new tagging
tag = HaystackTag.find_by(name: "child")
device = Device.find(1) # Example of a taggable object
tagging = HaystackTagging.create(haystack_tag: tag, taggable: device)

```

## Ontology and Factory

### HaystackOntology

The `HaystackOntology` class is responsible for managing the ontology of tags. It provides methods to load, find, and create tags based on a YAML configuration file.

#### Key Methods

- `self.tags`: Loads the tags from the `config/haystack_ontology.yml` file and caches them.
- `self.find_tag(path)`: Finds a tag based on a given path. It supports both flat and hierarchical paths.
- `self.find_tag_in_hierarchy(current_hash, target_key, path = [])`: Recursively searches for a tag in a nested hash structure.
- `self.create_tags`: Uses the `HaystackFactory` to create tags from the loaded ontology.
- `self.find_or_create_tag(name)`: Finds or creates a tag based on the name using the `HaystackFactory`.
- `self.import_full_ontology`: Imports the full ontology by creating all tags.

### HaystackFactory

The `HaystackFactory` class is responsible for creating and managing tags and taggings. It uses a strategy pattern to allow different tag creation strategies.

#### Key Methods

- `initialize(tag_strategy = DefaultTagStrategy.new)`: Initializes the factory with a given tag strategy.
- `create_tag(name, description)`: Creates a tag using the current strategy.
- `create_tagging(tag, taggable)`: Creates a tagging for a taggable object.
- `find_or_create_tag(name, attributes = {})`: Finds or creates a tag with the given attributes.
- `create_tags(tag_hash, parent_tag = nil)`: Recursively creates tags from a nested hash structure.

### How They Work Together

1. **Loading Tags**: `HaystackOntology` loads the tags from the YAML file using the `self.tags` method.
2. **Finding Tags**: `HaystackOntology` can find tags based on a path using the `self.find_tag` and `self.find_tag_in_hierarchy` methods.
3. **Creating Tags**: `HaystackOntology` uses the `self.create_tags` method to create tags. This method initializes a `HaystackFactory` with an `OntologyTagStrategy` and calls the factory's `create_tags` method.
4. **Finding or Creating Tags**: `HaystackOntology` uses the `self.find_or_create_tag` method to find or create a tag. This method initializes a `HaystackFactory` with an `OntologyTagStrategy` and calls the factory's `find_or_create_tag` method.
5. **Importing Full Ontology**: `HaystackOntology` uses the `self.import_full_ontology` method to import the full ontology by calling the `self.create_tags` method.

### Example Usage

```ruby
# Load and create all tags from the ontology
HaystackOntology.import_full_ontology

# Find a specific tag by path
tag = HaystackOntology.find_tag("root.child")

# Find or create a tag by name
tag = HaystackOntology.find_or_create_tag("child")
```

## Query Strategies

The query strategies are used to bind several data objects together based on their tags. This is achieved using the Strategy design pattern, which allows different query strategies to be implemented and executed dynamically.

### QueryContext

The `QueryContext` class is responsible for executing a given strategy. It takes a strategy as an argument and calls the `execute` method on that strategy.

#### Example Usage

```ruby
# Define a strategy
strategy = FindByTagsStrategy.new(Model, tags)

# Create a context with the strategy
context = QueryContext.new(strategy)

# Execute the strategy
result = context.execute
```

### QueryStrategy
The QueryStrategy class is an abstract base class for all query strategies. It defines an execute method that must be implemented by subclasses.

class CustomStrategy < QueryStrategy
  def execute
    # Custom query logic
  end
end
```ruby
  strategy = CustomStrategy.new
  context = QueryContext.new(strategy)
  result = context.execute
```

### FindByTagsStrategy
The FindByTagsStrategy class is a concrete implementation of QueryStrategy. It finds records that are associated with any of the given tags.

``` ruby
  tags = [tag1, tag2]
  strategy = FindByTagsStrategy.new(Model, tags)
  context = QueryContext.new(strategy)
  result = context.execute
```

### FindPointsWithTagStrategy
The FindPointsWithTagStrategy class is a concrete implementation of QueryStrategy. It finds records that are associated with a specific tag.



## HaystackTag Validations and Associations
The HaystackTag model includes comprehensive validations and associations to ensure data integrity and support hierarchical relationships.

``` ruby
RSpec.describe HaystackTag, type: :model do
  describe "validations and associations" do
    subject { build(:haystack_tag) }

    # Validations
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }

    # Associations
    it { is_expected.to belong_to(:parent_tag).class_name("HaystackTag").optional }
    it { is_expected.to have_many(:children).class_name("HaystackTag").with_foreign_key("parent_tag_id").dependent(:destroy).inverse_of(:parent_tag) }
    it { is_expected.to have_many(:haystack_taggings).dependent(:destroy) }
    it { is_expected.to have_many(:taggables).through(:haystack_taggings).source(:taggable) }
  end
```

# Duplicate Name Validation
HaystackTag ensures unique tag names within the same parent but allows identical names across different parents.

``` ruby
  context "when creating duplicate names" do
    it "validates uniqueness within the same parent" do
      parent = create(:haystack_tag)
      create(:haystack_tag, name: "test", parent_tag: parent)
      duplicate = build(:haystack_tag, name: "test", parent_tag: parent)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include("Must be unique in same category")
    end

    it "allows the same name under different parents" do
      parent1 = create(:haystack_tag)
      parent2 = create(:haystack_tag)
      create(:haystack_tag, name: "test", parent_tag: parent1)
      tag2 = build(:haystack_tag, name: "test", parent_tag: parent2)

      expect(tag2).to be_valid
    end
  end
```

# Hierarchy Functionality
The HaystackTag model supports hierarchical operations such as identifying roots, leaves, depth, and ancestor relationships.

``` ruby
  describe "hierarchy functionality" do
    let(:root) { create(:haystack_tag, name: "root") }
    let(:child) { create(:haystack_tag, name: "child", parent_tag: root) }
    let(:grandchild) { create(:haystack_tag, name: "grandchild", parent_tag: child) }

    context "basic hierarchy methods" do
      it "identifies root and leaf nodes correctly" do
        expect(root.root?).to be true
        expect(child.root?).to be false
        expect(grandchild.leaf?).to be true
        expect(child.leaf?).to be false
      end

      it "calculates depth accurately" do
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
  end
```

# Path Operations
HaystackTag provides methods for finding tags based on hierarchical paths.

``` ruby
  context "path operations" do
    it "retrieves tags by valid paths" do
      expect(HaystackTag.find_by_path("root")).to eq(root)
      expect(HaystackTag.find_by_path("root.child")).to eq(child)
      expect(HaystackTag.find_by_path("root.child.grandchild")).to eq(grandchild)
    end

    it "handles invalid paths gracefully" do
      expect(HaystackTag.find_by_path("invalid")).to be_nil
      expect(HaystackTag.find_by_path("root.invalid")).to be_nil
    end
  end
```

# Descendant and Sibling Operations
The HaystackTag model supports efficient retrieval of descendants and siblings.

``` ruby
  context "sibling and descendant operations" do
    let(:sibling) { create(:haystack_tag, name: "sibling", parent_tag: root) }

    it "returns all descendants correctly" do
      expect(root.descendants).to contain_exactly(child, grandchild, sibling)
      expect(child.descendants).to contain_exactly(grandchild)
      expect(grandchild.descendants).to be_empty
    end
  end
```