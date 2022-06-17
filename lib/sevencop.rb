# frozen_string_literal: true

require 'pathname'
require 'yaml'

require_relative 'sevencop/inject'
require_relative 'sevencop/version'

require_relative 'rubocop/cop/sevencop/redundant_existence_check'
require_relative 'rubocop/cop/sevencop/uniqueness_validator_explicit_case_sensitivity'

module Sevencop
  PROJECT_ROOT = ::Pathname.new(__dir__).parent.expand_path.freeze

  CONFIG_DEFAULT = PROJECT_ROOT.join('config', 'default.yml').freeze

  CONFIG = ::YAML.safe_load(CONFIG_DEFAULT.read).freeze

  private_constant(:CONFIG_DEFAULT, :PROJECT_ROOT)
end

Sevencop::Inject.defaults!
