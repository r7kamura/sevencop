# frozen_string_literal: true

require 'pathname'
require 'yaml'

require_relative 'sevencop/inject'
require_relative 'sevencop/version'

module Sevencop
  PROJECT_ROOT = ::Pathname.new(__dir__).parent.expand_path.freeze

  CONFIG_DEFAULT = PROJECT_ROOT.join('config', 'default.yml').freeze

  CONFIG = ::YAML.safe_load(CONFIG_DEFAULT.read).freeze

  private_constant(:CONFIG_DEFAULT, :PROJECT_ROOT)
end

Sevencop::Inject.defaults!

require_relative 'rubocop/cop/sevencop'
