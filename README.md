# sevencop

[![test](https://github.com/r7kamura/sevencop/actions/workflows/test.yml/badge.svg)](https://github.com/r7kamura/sevencop/actions/workflows/test.yml)

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
Sevencop/RailsBelongsToOptional:
  Enabled: true
```

## Cops

See YARD comments in each cop class for details:

- [Sevencop/HashElementOrdered](lib/rubocop/cop/sevencop/hash_element_ordered.rb)
- [Sevencop/MethodDefinitionArgumentsMultiline](lib/rubocop/cop/sevencop/method_definition_arguments_multiline.rb)
- [Sevencop/MethodDefinitionKeywordArgumentsOrdered](lib/rubocop/cop/sevencop/method_definition_keyword_arguments_ordered.rb)
- [Sevencop/MethodDefinitionOrdered](lib/rubocop/cop/sevencop/method_definition_ordered.rb)
- [Sevencop/RailsBelongsToOptional](lib/rubocop/cop/sevencop/rails_belongs_to_optional.rb)
- [Sevencop/RailsInferredSpecType](lib/rubocop/cop/sevencop/rails_inferred_spec_type.rb)
- [Sevencop/RailsOrderField](lib/rubocop/cop/sevencop/rails_order_field.rb)
- [Sevencop/RailsUniquenessValidatorExplicitCaseSensitivity](lib/rubocop/cop/sevencop/rails_uniqueness_validator_explicit_case_sensitivity.rb)
- [Sevencop/RailsWhereNot](lib/rubocop/cop/sevencop/rails_where_not.rb)

Note that all cops are `Enabled: false` by default.
