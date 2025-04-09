# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Combine examples in same group in the time-consuming kinds of specs.
      #
      # @example
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
      #   # bad - IncludeSharedExamples: true
      #   context 'when user is logged in' do
      #     it 'returns 200' do
      #       subject
      #       expect(response).to have_http_status(200)
      #     end
      #
      #     includes_examples 'creates Foo'
      #   end
      class RSpecExamplesInSameGroup < Base
        METHOD_NAMES_FOR_REGULAR_EXAMPLE = %i[
          example
          it
          its
          scenario
          specify
        ].to_set.freeze

        METHOD_NAMES_FOR_SHARED_EXAMPLES = %i[
          include_examples
          it_behaves_like
          it_should_behave_like
        ].to_set.freeze

        MSG = 'Combine examples in the same group in the time-consuming kinds of specs.'

        RESTRICT_ON_SEND = [
          *METHOD_NAMES_FOR_REGULAR_EXAMPLE,
          *METHOD_NAMES_FOR_SHARED_EXAMPLES
        ].freeze

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def on_send(node)
          node = node.block_node || node

          return unless example?(node)

          previous_sibling_example = previous_sibling_example_of(node)
          return unless previous_sibling_example

          add_offense(node)
        end
        alias on_csend on_send

        private

        # @param node [RuboCop::AST::BlockNode, RuboCop::AST::SendNode]
        # @return [Boolean]
        def example?(node)
          if include_shared_examples?
            regular_example?(node) || shared_example?(node)
          else
            regular_example?(node)
          end
        end

        # @return [Boolean]
        def include_shared_examples?
          cop_config['IncludeSharedExamples']
        end

        # @param node [RuboCop::AST::BlockNode, RuboCop::AST::SendNode]
        # @return [RuboCop::AST::BlockNode, RuboCop::AST::SendNode, nil]
        def previous_sibling_example_of(node)
          return unless node.parent&.begin_type?

          node.left_siblings.find do |sibling|
            sibling.is_a?(::RuboCop::AST::Node) && example?(sibling)
          end
        end

        # @param node [RuboCop::AST::BlockNode, RuboCop::AST::SendNode]
        # @return [Boolean]
        def regular_example?(node)
          METHOD_NAMES_FOR_REGULAR_EXAMPLE.include?(node.method_name)
        end

        # @param node [RuboCop::AST::BlockNode, RuboCop::AST::SendNode]
        # @return [Boolean]
        def shared_example?(node)
          METHOD_NAMES_FOR_SHARED_EXAMPLES.include?(node.method_name)
        end
      end
    end
  end
end
