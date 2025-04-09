# frozen_string_literal: true

require 'lint_roller'

module Sevencop
  class Plugin < ::LintRoller::Plugin
    def about
      ::LintRoller::About.new(
        description: 'Opinionated custom cops for RuboCop.',
        homepage: 'https://github.com/r7kamura/sevencop',
        name: 'sevencop',
        version: VERSION
      )
    end

    def rules(_context)
      ::LintRoller::Rules.new(
        config_format: :rubocop,
        type: :path,
        value: "#{__dir__}/../../config/default.yml"
      )
    end

    def supported?(context)
      context.engine == :rubocop
    end
  end
end
