# frozen_string_literal: true

require 'rubocop'

require_relative 'config_loader'

RuboCop::ConfigLoader.instance_variable_set(
  :@default_configuration,
  Sevencop::ConfigLoader.call(
    path: File.expand_path(
      '../../config/default.yml',
      __dir__
    )
  )
)
