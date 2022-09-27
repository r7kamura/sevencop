# frozen_string_literal: true

require_relative 'sevencop/cop_concerns'
require_relative 'sevencop/rubocop_extension'
require_relative 'sevencop/version'

require_relative 'rubocop/cop/sevencop/autoload_ordered'
require_relative 'rubocop/cop/sevencop/hash_element_ordered'
require_relative 'rubocop/cop/sevencop/method_definition_arguments_multiline'
require_relative 'rubocop/cop/sevencop/method_definition_keyword_argument_ordered'
require_relative 'rubocop/cop/sevencop/method_definition_ordered'
require_relative 'rubocop/cop/sevencop/rails_belongs_to_optional'
require_relative 'rubocop/cop/sevencop/rails_inferred_spec_type'
require_relative 'rubocop/cop/sevencop/rails_order_field'
require_relative 'rubocop/cop/sevencop/rails_uniqueness_validator_explicit_case_sensitivity'
require_relative 'rubocop/cop/sevencop/rails_where_not'
require_relative 'rubocop/cop/sevencop/require_ordered'
