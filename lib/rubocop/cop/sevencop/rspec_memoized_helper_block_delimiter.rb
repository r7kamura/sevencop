# frozen_string_literal: true

require 'set'

module RuboCop
  module Cop
    module Sevencop
      # Use do-end block delimiter on RSpec memoized helper.
      #
      # Since these helpers define methods, they should be written in the same style as `def`.
      #
      # @example
      #   # bad
      #   let(:foo) { 'bar' }
      #
      #   # good
      #   let(:foo) do
      #     'bar'
      #   end
      #
      #   # bad
      #   subject(:foo) { 'bar' }
      #
      #   # good
      #   subject(:foo) do
      #     'bar'
      #   end
      class RSpecMemoizedHelperBlockDelimiter < Base
        extend AutoCorrector

        include ConfigurableEnforcedStyle
        include RangeHelp

        MSG = 'Use do-end block delimiter on RSpec memoized helper.'

        # @param node [RuboCop::AST::BlockNode]
        # @return [void]
        def on_block(node) # rubocop:disable InternalAffairs/NumblockHandler
          return unless bad?(node)

          add_offense(
            node.location.begin.with(
              end_pos: node.location.end.end_pos
            )
          ) do |corrector|
            autocorrect(corrector, node)
          end
        end

        private

        # @!method memoized_helper?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :memoized_helper?, <<~PATTERN
          (block
            (send
              nil?
              {:let :subject}
              ...
            )
            ...
          )
        PATTERN

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::BlockNode]
        # @return [void]
        def autocorrect(
          corrector,
          node
        )
          corrector.insert_before(node.location.begin, ' ') unless whitespace_before?(node.location.begin)
          corrector.replace(node.location.begin, 'do')
          corrector.replace(node.location.end, 'end')
          wrap_in_newlines(corrector, node) if node.single_line?
        end

        # @param node [RuboCop::AST::BlockNode]
        # @return [Boolean]
        def bad?(node)
          memoized_helper?(node) && node.braces?
        end

        # @param range [Parser::Source::Range]
        # @return [Boolean]
        def whitespace_before?(range)
          range.source_buffer.source[range.begin_pos - 1].match?(/\s/)
        end

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::BlockNode]
        # @return [void]
        def wrap_in_newlines(
          corrector,
          node
        )
          corrector.wrap(
            node.location.begin.with(
              begin_pos: node.location.begin.end_pos,
              end_pos: node.location.end.begin_pos
            ),
            "\n",
            "\n"
          )
        end
      end
    end
  end
end
