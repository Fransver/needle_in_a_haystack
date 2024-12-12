# Needle in a Haystack

<img src="storage/logo.jpg" alt="Needle in a Haystack logo" width="40%">

[![CI](https://github.com/Fransver/needle_in_a_haystack/actions/workflows/ci.yml/badge.svg)](https://github.com/Fransver/needle_in_a_haystack/actions/workflows/ci.yml)

A Rails engine that implements the [Project Haystack](https://project-haystack.org)
tagging ontology. It gives you:

- a **hierarchical tag tree** (`HaystackTag`) — every tag has at most one parent
  and any number of children;
- a **polymorphic tagging layer** (`HaystackTagging` + the `Taggable` concern)
  so you can attach those tags to *any* of your models;
- an **ontology importer** that builds the tag tree from a YAML definition;
- composable **query strategies** for finding records by their tags.

It was built for managing building and equipment data, but it works for any
problem that needs a shared, hierarchical tag vocabulary.

## Table of contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Concepts](#concepts)
- [Tagging your models](#tagging-your-models)
- [The tag hierarchy](#the-tag-hierarchy)
- [The ontology](#the-ontology)
- [Query strategies](#query-strategies)
- [Extending: factories and strategies](#extending-factories-and-strategies)
- [Development](#development)

## Installation

Add the gem to your application's `Gemfile`:

```ruby
gem "needle_in_a_haystack"
```

Then install the gem and copy its migration into your app:

```bash
bundle install
bin/rails needle_in_a_haystack:install:migrations
bin/rails db:migrate
```

This creates two tables: `haystack_tags` (the hierarchy) and `haystack_taggings`
(the polymorphic join). The gem does not lock you to a database driver — add
whichever adapter your app uses (`mysql2`, `pg`, `sqlite3`, …) yourself.

## Configuration

All configuration is optional. To point the ontology importer at your own YAML
file, add an initializer:

```ruby
# config/initializers/needle_in_a_haystack.rb
NeedleInAHaystack.configure do |config|
  config.ontology_path = Rails.root.join("config/haystack_ontology.yml")
end
```

When unset, the ontology shipped with the gem is used.

## Concepts

| Class | Responsibility |
| --- | --- |
| `NeedleInAHaystack::HaystackTag` | A node in the tag hierarchy. |
| `NeedleInAHaystack::HaystackTagging` | Polymorphic join between a tag and a tagged record. |
| `NeedleInAHaystack::Taggable` | Concern you include in your own models. |
| `NeedleInAHaystack::HaystackOntology` | Loads YAML and materialises the tag tree. |
| `NeedleInAHaystack::HaystackFactory` | Creates tags/taggings via a pluggable strategy. |
| `NeedleInAHaystack::QueryContext` + `*Strategy` | Find records by their tags. |

All classes live under the `NeedleInAHaystack` namespace.

## Tagging your models

Include the `Taggable` concern in any model you want to tag:

```ruby
class Point < ApplicationRecord
  include NeedleInAHaystack::Taggable
end
```

That gives every instance a tagging API:

```ruby
temp = NeedleInAHaystack::HaystackTag.find_by(name: "temp")
sensor = NeedleInAHaystack::HaystackTag.find_by(name: "sensor")

point.add_haystack_tag(temp)            # attach one tag
point.add_haystack_tags(temp, sensor)   # attach several
point.haystack_tagged_with?("temp")     # => true
point.haystack_tags                      # => [#<HaystackTag temp>, ...]
point.remove_haystack_tag(temp)         # => true
```

…and class-level lookups:

```ruby
Point.tagged_with(temp, sensor)   # records carrying ALL of these tags
Point.tagged_with_any(temp, sensor) # records carrying ANY of these tags
```

## The tag hierarchy

`HaystackTag` models a tree. A tag is unique by name *within its parent*, so the
same name may appear under different parents.

```ruby
HaystackTag = NeedleInAHaystack::HaystackTag

site     = HaystackTag.create!(name: "site",     description: "A location")
building = HaystackTag.create!(name: "building", description: "A structure", parent_tag: site)
floor    = HaystackTag.create!(name: "floor",    description: "A floor", parent_tag: building)

floor.full_path     # => "site > building > floor"
floor.ancestors     # => [building, site]   (nearest first)
floor.depth         # => 2
floor.root?         # => false
floor.leaf?         # => true
floor.category      # => "site"             (the root it descends from)
site.descendants    # => [building, floor]  (breadth-first)
building.siblings   # => []

HaystackTag.find_by_path("site.building.floor") # => floor
HaystackTag.find_by_path("site.missing")        # => nil
```

Circular references are rejected by validation, and a tag's name must be unique
within its parent.

## The ontology

The ontology is a nested YAML file. Each node has a `description`, an optional
`marker`, and an optional `children` map:

```yaml
site:
  description: A geographical location in the built environment
  children:
    building:
      description: A structure on a site
      children:
        floor:
          description: A floor in a building
```

Import it into the database:

```ruby
# Build the entire tree
NeedleInAHaystack::HaystackOntology.import_full_ontology

# …or via the rake task
# bin/rails needle_in_a_haystack:import_ontology

# Look up a node definition by dotted path
NeedleInAHaystack::HaystackOntology.find_tag("site.building")
# => { "description" => "A structure on a site", "name" => "building", "path" => "site.building", ... }

# Find or create a single tag from the ontology
NeedleInAHaystack::HaystackOntology.find_or_create_tag("site.building.floor")
```

Imports are idempotent: running them again updates existing tags instead of
duplicating them.

## Query strategies

Finding records by tag uses the Strategy pattern, so you can swap query
behaviour without changing call sites. Each strategy returns an
`ActiveRecord::Relation`, so results stay composable.

```ruby
include NeedleInAHaystack

# Records with a single tag
QueryContext.new(FindPointsWithTagStrategy.new(Point, temp)).execute

# Records with ANY of the given tags
QueryContext.new(FindByTagsStrategy.new(Point, [temp, sensor])).execute

# Records with ALL of the given tags
QueryContext.new(FindPointsWithMultipleTagsStrategy.new(Point, [temp, sensor])).execute
```

For everyday use the `Taggable.tagged_with` / `tagged_with_any` helpers cover the
same ground; the strategies are there when you need to compose or extend query
behaviour.

## Extending: factories and strategies

Tag creation goes through `HaystackFactory`, which delegates to a `TagStrategy`.
Two are provided — `DefaultTagStrategy` (ad-hoc) and `OntologyTagStrategy`
(idempotent import). Provide your own to customise creation:

```ruby
class MyTagStrategy < NeedleInAHaystack::TagStrategy
  def create_tag(name, description)
    NeedleInAHaystack::HaystackTag.create(name: name, description: description)
  end

  def update_tag(tag, attributes)
    tag.update(attributes)
    tag
  end
end

factory = NeedleInAHaystack::HaystackFactory.new(MyTagStrategy.new)
```

Likewise, add a new query strategy by subclassing `QueryStrategy` and
implementing `#execute`:

```ruby
class RecentlyTaggedStrategy < NeedleInAHaystack::QueryStrategy
  def initialize(model)
    super()
    @model = model
  end

  def execute
    @model.joins(:haystack_taggings).where(haystack_taggings: { created_at: 1.week.ago.. })
  end
end
```

## Development

```bash
git clone https://github.com/Fransver/needle_in_a_haystack.git
cd needle_in_a_haystack
bundle install
bundle exec rspec
bundle exec rubocop
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines and
[CHANGELOG.md](CHANGELOG.md) for the release history. Released under the
[MIT License](LICENSE).
