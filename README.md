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
Sevencop/BelongsToOptional:
  Enabled: true
```

## Cops

See YARD comments in each cop class for details:

- [Sevencop/BelongsToOptional](lib/rubocop/cop/sevencop/belongs_to_optional.rb)
- [Sevencop/HashElementOrdered](lib/rubocop/cop/sevencop/hash_element_ordered.rb)
- [Sevencop/InferredSpecType](lib/rubocop/cop/sevencop/inferred_spec_type.rb)
- [Sevencop/MethodDefinitionArgumentsMultiline](lib/rubocop/cop/sevencop/method_definition_arguments_multiline.rb)
- [Sevencop/MethodDefinitionKeywordArgumentsOrdered](lib/rubocop/cop/sevencop/method_definition_keyword_arguments_ordered.rb)
- [Sevencop/MethodDefinitionOrdered](lib/rubocop/cop/sevencop/method_definition_ordered.rb)
- [Sevencop/OrderField](lib/rubocop/cop/sevencop/order_field.rb)
- [Sevencop/UniquenessValidatorExplicitCaseSensitivity](lib/rubocop/cop/sevencop/uniqueness_validator_explicit_case_sensitivity.rb)
- [Sevencop/WhereNot](lib/rubocop/cop/sevencop/where_not.rb)

Note that all cops are `Enabled: false` by default.
