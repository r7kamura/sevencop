# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Remove pending-only test files.
      #
      # @example
      #   # bad
      #   RSpec.describe Post do
      #     pending "add some examples to (or delete) #{__FILE__}"
      #   end
      class RSpecPendingOnlyExampleGroup < ::RuboCop::Cop::Base
        MSG = 'Remove pending-only test files.'

        RESTRICT_ON_SEND = %i[
          describe
        ].freeze

        def on_send(node)
          block_node = node.parent
          return unless pending_only_example_group?(block_node)

          add_offense(block_node)
        end

        private

        # @!method pending_only_example_group?(node)
        def_node_matcher :pending_only_example_group?, <<~PATTERN
          (block
            (send (const nil? :RSpec) :describe ...)
            (args)
            (send nil? :pending ...)
          )
        PATTERN
      end
    end
  end
end
