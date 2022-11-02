# frozen_string_literal: true

require 'set'

module RuboCop
  module Cop
    module Sevencop
      # Insert empty line after `let`.
      #
      # Since `let` defines a method, it should be written in the same style as `def`.
      #
      # @example
      #   # bad
      #   context 'with something' do
      #     let(:foo) do
      #       'foo'
      #     end
      #     let(:bar) do
      #       'bar'
      #     end
      #   end
      #
      #   # good
      #   context 'with something' do
      #     let(:foo) do
      #       'foo'
      #     end
      #
      #     let(:bar) do
      #       'bar'
      #     end
      #   end
      #
      #   # good
      #   context 'with something' do
      #     let(:foo) do
      #       'foo'
      #     end
      #   end
      class RSpecEmptyLineAfterLet < Base
        extend AutoCorrector

        MSG = 'Insert empty line after `let`.'

        # @param node [RuboCop::AST::BlockNode]
        # @return [void]
        def on_block(node) # rubocop:disable InternalAffairs/NumblockHandler
          return unless bad?(node)

          add_offense(node) do |corrector|
            corrector.insert_after(node.location.end, "\n")
          end
        end

        private

        # @!method let?(node)
        #   @param node [RuboCop::AST::BlockNode]
        #   @return [Boolean]
        def_node_matcher :let?, <<~PATTERN
          (block
            (send
              nil?
              {:let :let!}
              ...
            )
            ...
          )
        PATTERN

        # @param node [RuboCop::AST::BlockNode]
        # @return [Boolean]
        def bad?(node)
          let?(node) &&
            !empty_line_after?(node) &&
            !last_child?(node)
        end

        # @param node [RuboCop::AST::BlockNode]
        # @return [Boolean]
        def empty_line_after?(node)
          processed_source[node.location.end.line].strip.empty?
        end

        # @param node [RuboCop::AST::BlockNode]
        # @return [Boolean]
        def last_child?(node)
          !node.parent&.begin_type? ||
            node.equal?(node.parent.children.last)
        end
      end
    end
  end
end
