# frozen_string_literal: true

require_relative 'sevencop/rubocop_extension'
require_relative 'sevencop/version'

require_relative 'rubocop/cop/sevencop/autoload_ordered'
require_relative 'rubocop/cop/sevencop/belongs_to_optional'
require_relative 'rubocop/cop/sevencop/hash_literal_order'
require_relative 'rubocop/cop/sevencop/inferred_spec_type'
require_relative 'rubocop/cop/sevencop/method_definition_keyword_arguments_ordered'
require_relative 'rubocop/cop/sevencop/method_definition_multiline_arguments'
require_relative 'rubocop/cop/sevencop/order_field'
require_relative 'rubocop/cop/sevencop/redundant_existence_check'
require_relative 'rubocop/cop/sevencop/to_s_with_argument'
require_relative 'rubocop/cop/sevencop/uniqueness_validator_explicit_case_sensitivity'
require_relative 'rubocop/cop/sevencop/where_not'
