# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Combine examples in same group in the time-consuming kinds of specs.
      #
      # @example
      #
      #   # bad
      #   context 'when user is logged in' do
      #     it 'returns 200' do
      #       subject
      #       expect(response).to have_http_status(200)
      #     end
      #
      #     it 'creates Foo' do
      #       expect { subject }.to change(Foo, :count).by(1)
      #     end
      #   end
      #
      #   # good
      #   context 'when user is logged in' do
      #     it 'creates Foo and returns 200' do
      #       expect { subject }.to change(Foo, :count).by(1)
      #       expect(response).to have_http_status(200)
      #     end
      #   end
      #
      class RSpecExamplesInSameGroup < Base
        extend AutoCorrector

        EXAMPLE_METHOD_NAMES_REGULAR = ::Set[
          :it,
          :its,
          :specify,
          :example,
          :scenario,
        ].freeze

        MSG = 'Combine examples in the same group in the time-consuming kinds of specs.'

        # @param node [RuboCop::AST::BlockNode]
        # @return [void]
        def on_block(node)
          return unless example?(node)

          previous_sibling_example = previous_sibling_example_of(node)
          return unless previous_sibling_example

          add_offense(node)
        end
        alias on_numblock on_block

        private

        # @!method example?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :example?, <<~PATTERN
          (block
            (send nil? EXAMPLE_METHOD_NAMES_REGULAR ...)
            ...
          )
        PATTERN

        # @param node [RuboCop::AST::BlockNode]
        # @return [RuboCop::AST::BlockNode, nil]
        def previous_sibling_example_of(node)
          node.left_siblings.find do |sibling|
            sibling.is_a?(::RuboCop::AST::Node) && example?(sibling)
          end
        end
      end
    end
  end
end
