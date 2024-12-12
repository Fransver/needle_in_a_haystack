# Contributing

Thanks for your interest in improving Needle in a Haystack!

## Getting started

```bash
git clone https://github.com/Fransver/needle_in_a_haystack.git
cd needle_in_a_haystack
bundle install
bundle exec rspec
```

The test suite expects a database to be available. See `config/database.yml`
for the connection settings.

## Guidelines

- Keep changes focused and covered by specs (`spec/`).
- Run RuboCop before opening a pull request: `bundle exec rubocop`.
- Follow [Semantic Versioning](https://semver.org) and add a `CHANGELOG.md`
  entry describing your change.
- Public API additions should ship with documentation (README and inline
  comments).

## Reporting issues

Please open an issue at
<https://github.com/Fransver/needle_in_a_haystack/issues> with a minimal
reproduction where possible.
