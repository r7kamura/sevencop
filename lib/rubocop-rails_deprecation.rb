# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/rails_deprecation'
require_relative 'rubocop/rails_deprecation/version'
require_relative 'rubocop/rails_deprecation/inject'

RuboCop::RailsDeprecation::Inject.defaults!

require_relative 'rubocop/cop/rails_deprecation_cops'
