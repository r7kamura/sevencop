# frozen_string_literal: true

require_relative 'sevencop/cop_concerns'
require_relative 'sevencop/rubocop_extension'
require_relative 'sevencop/version'

require_relative 'rubocop/cop/sevencop/autoload_ordered'
require_relative 'rubocop/cop/sevencop/factory_bot_association_option'
require_relative 'rubocop/cop/sevencop/factory_bot_association_style'
require_relative 'rubocop/cop/sevencop/hash_element_ordered'
require_relative 'rubocop/cop/sevencop/method_definition_arguments_multiline'
require_relative 'rubocop/cop/sevencop/method_definition_in_included'
require_relative 'rubocop/cop/sevencop/method_definition_keyword_argument_ordered'
require_relative 'rubocop/cop/sevencop/method_definition_ordered'
require_relative 'rubocop/cop/sevencop/rails_belongs_to_optional'
require_relative 'rubocop/cop/sevencop/rails_inferred_spec_type'
require_relative 'rubocop/cop/sevencop/rails_migration_add_check_constraint'
require_relative 'rubocop/cop/sevencop/rails_migration_add_foreign_key'
require_relative 'rubocop/cop/sevencop/rails_migration_add_index_concurrency'
require_relative 'rubocop/cop/sevencop/rails_migration_change_column_null'
require_relative 'rubocop/cop/sevencop/rails_migration_jsonb'
require_relative 'rubocop/cop/sevencop/rails_migration_unique_index_columns_count'
require_relative 'rubocop/cop/sevencop/rails_migration_reserved_word_mysql'
require_relative 'rubocop/cop/sevencop/rails_order_field'
require_relative 'rubocop/cop/sevencop/rails_uniqueness_validator_explicit_case_sensitivity'
require_relative 'rubocop/cop/sevencop/rails_where_not'
require_relative 'rubocop/cop/sevencop/require_ordered'
require_relative 'rubocop/cop/sevencop/rspec_describe_http_endpoint'
require_relative 'rubocop/cop/sevencop/rspec_examples_in_same_group'
