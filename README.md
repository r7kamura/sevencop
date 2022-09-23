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

Require sevencop from your .rubocop.yml:

```yaml
# .rubocop.yml
require:
  - sevencop
```

then enable the cops you want to use:

```yaml
# .rubocop.yml
Sevencop/BelongsToOptional:
  Enabled: true
```

## Cops

All cops are `Enabled: false` by default.

### Sevencop/AutoloadOrdered

Sort `autoload` in alphabetical order within their section.

```ruby
# bad
autoload :B, 'b'
autoload :A, 'a'

# good
autoload :A, 'a'
autoload :B, 'b'

# good
autoload :B, 'b'
autoload :D, 'd'

autoload :A, 'a'
autoload :C, 'a'
```

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

### Sevencop/FactoryBotCreateList

Finds possible substitutions for `FactoryBot.create_list`.

```ruby
# bad
Array.new(2) do
  create(:user)
end

# good
create_list(:user, 2)

# good
Array.new(2) do |i|
  create(:user, order: i)
end
```

### Sevencop/HashLiteralOrder

Sort Hash literal entries by key.

```ruby
# bad
{
  b: 1,
  a: 1,
  c: 1
}

# good
{
  a: 1,
  b: 1,
  c: 1
}
```

### Sevencop/InferredSpecType

Identifies redundant spec type.

```ruby
# bad
# spec/models/user_spec.rb
RSpec.describe User, type: :model

# good
# spec/models/user_spec.rb
RSpec.describe User

# good
# spec/models/user_spec.rb
RSpec.describe User, type: :request
```

### Sevencop/MethodDefinitionMultilineArguments

Inserts new lines between method definition parameters.

```ruby
# bad
def foo(a, b)
end

# good
def foo(
  a,
  b
)

# good
def foo(a)
end
```

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

### Sevencop/WhereNot

Identifies passing multi-elements Hash literal to `where.not`.

```ruby
# bad
where.not(key1: value1, key2: value2)

# good
where.not(key1: value1).where.not(key2: value2)
```
