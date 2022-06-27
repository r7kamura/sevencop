# sevencop

[![test](https://github.com/r7kamura/sevencop/actions/workflows/test.yml/badge.svg)](https://github.com/r7kamura/sevencop/actions/workflows/test.yml)
[![Gem Version](https://badge.fury.io/rb/sevencop.svg)](https://rubygems.org/gems/sevencop)

Custom cops for [RuboCop](https://github.com/rubocop/rubocop).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sevencop', require: false
```

And then execute:

```
bundle install
```

Or install it yourself as:

```
gem install sevencop
```

## Usage

```yaml
# .rubocop.yml
require:
  - sevencop
```

## Cops

### Sevencop/BelongsToOptional

Force `belongs_to` with `optional: true` option.

```ruby
# bad
belongs_to :group

# good
belongs_to :group, optional: true

# good
belongs_to :group, optional: false

# good
belongs_to :group, options
```

This is useful for migration of `config.active_record.belongs_to_required_by_default`.

`Enabled: false` by default.

### Sevencop/OrderField

Identifies a String including "field" is passed to `order` or `reorder`.

```ruby
# bad
articles.order('field(id, ?)', a)

# good
articles.order(Arel.sql('field(id, ?)'), a)

# bad
reorder('field(id, ?)', a)

# good
reorder(Arel.sql('field(id, ?)'), a)
```

`Enabled: false` by default.

### Sevencop/RedundantExistenceCheck

Identifies redundant existent check before file operation.

```ruby
# bad
FileUtils.mkdir(a) unless FileTest.exist?(a)

# good
FileUtils.mkdir_p(a)

# bad
FileUtils.rm(a) if FileTest.exist?(a)

# good
FileUtils.rm_f(a)
```

### Sevencop/UniquenessValidatorExplicitCaseSensitivity

Identifies use of UniquenessValidator without :case_sensitive option.

```ruby
# bad
validates :name, uniqueness: true

# good
validates :name, uniqueness: { case_sensitive: true }

# good
validates :name, uniqueness: { case_sensitive: false }

# bad
validates :name, uniqueness: { allow_nil: true, scope: :user_id }

# good
validates :name, uniqueness: { allow_nil: true, scope: :user_id, case_sensitive: true }
```

Useful to keep the same behavior between Rails 6.0 and 6.1 where case insensitive collation is used in MySQL.

`Enabled: false` by default.
