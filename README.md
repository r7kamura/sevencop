# sevencop

[![test](https://github.com/r7kamura/sevencop/actions/workflows/test.yml/badge.svg)](https://github.com/r7kamura/sevencop/actions/workflows/test.yml)

Opinionated custom cops for [RuboCop](https://github.com/rubocop/rubocop).

## Usage

Install `sevencop` gem:

```ruby
# Gemfile
gem 'sevencop', require: false
```

then require `sevencop` and enable the cops you want to use on .rubocop.yml:

```yaml
# .rubocop.yml
require:
  - sevencop

Sevencop/MethodDefinitionOrdered:
  Enabled: true
```

Note that all cops are `Enabled: false` by default.

## Cops

- [Sevencop/AutoloadOrdered](lib/rubocop/cop/sevencop/autoload_ordered.rb)
- [Sevencop/FactoryBotAssociationOption](lib/rubocop/cop/sevencop/factory_bot_association_option.rb)
- [Sevencop/FactoryBotAssociationStyle](lib/rubocop/cop/sevencop/factory_bot_association_style.rb)
- [Sevencop/HashElementOrdered](lib/rubocop/cop/sevencop/hash_element_ordered.rb)
- [Sevencop/MethodDefinitionArgumentsMultiline](lib/rubocop/cop/sevencop/method_definition_arguments_multiline.rb)
- [Sevencop/MethodDefinitionInIncluded](lib/rubocop/cop/sevencop/method_definition_in_included.rb)
- [Sevencop/MethodDefinitionKeywordArgumentOrdered](lib/rubocop/cop/sevencop/method_definition_keyword_argument_ordered.rb)
- [Sevencop/MethodDefinitionOrdered](lib/rubocop/cop/sevencop/method_definition_ordered.rb)
- [Sevencop/RailsBelongsToOptional](lib/rubocop/cop/sevencop/rails_belongs_to_optional.rb)
- [Sevencop/RailsInferredSpecType](lib/rubocop/cop/sevencop/rails_inferred_spec_type.rb)
- [Sevencop/RailsMigrationAddCheckConstraint](lib/rubocop/cop/sevencop/rails_migration_add_check_constraint.rb)
- [Sevencop/RailsMigrationAddColumnWithDefaultValue](lib/rubocop/cop/sevencop/rails_migration_add_column_with_default_value.rb)
- [Sevencop/RailsMigrationAddForeignKey](lib/rubocop/cop/sevencop/rails_migration_add_foreign_key.rb)
- [Sevencop/RailsMigrationAddIndexConcurrently](lib/rubocop/cop/sevencop/rails_migration_add_index_concurrently.rb)
- [Sevencop/RailsMigrationBatchInTransaction](lib/rubocop/cop/sevencop/rails_migration_batch_in_transaction.rb)
- [Sevencop/RailsMigrationBatchWithThrottling](lib/rubocop/cop/sevencop/rails_migration_batch_with_throttling.rb)
- [Sevencop/RailsMigrationChangeColumn](lib/rubocop/cop/sevencop/rails_migration_change_column.rb)
- [Sevencop/RailsMigrationChangeColumnNull](lib/rubocop/cop/sevencop/rails_migration_change_column_null.rb)
- [Sevencop/RailsMigrationCreateTableForce](lib/rubocop/cop/sevencop/rails_migration_create_table_force.rb)
- [Sevencop/RailsMigrationJsonb](lib/rubocop/cop/sevencop/rails_migration_jsonb.rb)
- [Sevencop/RailsMigrationRenameColumn](lib/rubocop/cop/sevencop/rails_migration_rename_column.rb)
- [Sevencop/RailsMigrationRenameTable](lib/rubocop/cop/sevencop/rails_migration_rename_table.rb)
- [Sevencop/RailsMigrationReservedWordMysql](lib/rubocop/cop/sevencop/rails_migration_reserved_word_mysql.rb)
- [Sevencop/RailsMigrationUniqueIndexColumnsCount](lib/rubocop/cop/sevencop/rails_migration_unique_index_columns_count.rb)
- [Sevencop/RailsOrderField](lib/rubocop/cop/sevencop/rails_order_field.rb)
- [Sevencop/RailsUniquenessValidatorExplicitCaseSensitivity](lib/rubocop/cop/sevencop/rails_uniqueness_validator_explicit_case_sensitivity.rb)
- [Sevencop/RailsWhereNot](lib/rubocop/cop/sevencop/rails_where_not.rb)
- [Sevencop/RequireOrdered](lib/rubocop/cop/sevencop/require_ordered.rb)
- [Sevencop/RSpecDescribeHttpEndpoint](lib/rubocop/cop/sevencop/rspec_describe_http_endpoint.rb)
- [Sevencop/RSpecExamplesInSameGroup](lib/rubocop/cop/sevencop/rspec_examples_in_same_group.rb)
