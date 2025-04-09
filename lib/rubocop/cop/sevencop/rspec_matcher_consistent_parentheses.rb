# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Keep consistent parentheses style in RSpec matchers.
      #
      # @example
      #   # bad
      #   is_expected.to eq 1
      #
      #   # good
      #   is_expected.to eq(1)
      class RSpecMatcherConsistentParentheses < Base
        extend AutoCorrector

        MSG = 'Keep consistent parentheses style in RSpec matchers.'

        RESTRICT_ON_SEND = %i[to].freeze

        # @param [RuboCop::AST::SendNode] node
        # @return [void]
        def on_send(node)
          return unless to?(node)

          first_argument = node.first_argument
          return unless inconsistent?(first_argument)

          add_offense(first_argument) do |corrector|
            add_parentheses(first_argument, corrector)
          end
        end
        alias on_csend on_send

        private

        # @!method expectation?(node)
        #   @param [RuboCop::AST::SendNode] node
        #   @return [Boolean]
        def_node_matcher :expectation?, <<~PATTERN
          (send nil? { :is_expected :expect } ...)
        PATTERN

        # @param [RuboCop::AST::Node, nil] node
        # @return [Boolean]
        def inconsistent?(node)
          node&.send_type? && missing_parentheses?(node)
        end

        # @param [RuboCop::AST::SendNode] node
        # @return [Boolean]
        def missing_parentheses?(node)
          !node.arguments.empty? &&
            !node.operator_method? &&
            !node.parenthesized?
        end

        # @param [RuboCop::AST::SendNode] node
        # @return [Boolean]
        def to?(node)
          expectation?(node.receiver)
        end
      end
    end
  end
end
