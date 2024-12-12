# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0]

A foundational release that makes the gem installable and usable outside of its
original host application.

### Breaking changes

- All models, factories and strategies are now namespaced under
  `NeedleInAHaystack::` (e.g. `NeedleInAHaystack::HaystackTag`). Update any
  references in host applications.
- `Taggable` is no longer a standalone ActiveRecord model. It is now a concern
  (`NeedleInAHaystack::Taggable`) that you `include` into your own models.
- `HaystackOntology` is now a plain Ruby object instead of an
  `ActiveRecord::Base` subclass (it never had a table).

### Fixed

- Removed a hardcoded absolute path (`/Users/frans/...`) that caused the gem to
  raise `Errno::ENOENT` on load on any other machine.
- `HaystackOntology.find_tag` now correctly descends through `children` for
  dotted paths (`"site.building"`); it previously failed for nested paths.
- `HaystackTag#full_path` no longer emits a leading `" > "` for root tags.
- `HaystackTag#descendants` now uses breadth-first traversal (one query per
  tree level) instead of one query per node.
- `HaystackTag#ancestors` / `#category` resolve in a single pass without
  repeated queries.

### Changed

- The ontology YAML now ships inside the gem and is resolved via
  `NeedleInAHaystack.configuration.ontology_path`; the duplicate
  `lib/haystack_ontology.yml` was removed.
- The database adapter (mysql2, pg, sqlite3, …) is no longer a runtime
  dependency. Runtime dependencies are limited to `activerecord`,
  `activesupport` and `railties`.
- Dropped the redundant, O(n)-query `ensure_identity` validation in favour of
  the existing uniqueness-within-parent validation.
- Added a `NeedleInAHaystack::Taggable` query API: `tagged_with`,
  `tagged_with_any`, `add_haystack_tag(s)`, `remove_haystack_tag`,
  `haystack_tagged_with?`.

## [1.1.0]

- Initial internal release.
