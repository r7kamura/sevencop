# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Sort method definition keyword arguments in alphabetical order.
      #
      # @example
      #   # bad
      #   def foo(b:, a:); end
      #
      #   # good
      #   def foo(a:, b:); end
      #
      #   # bad
      #   def foo(c:, d:, b: 1, a: 2); end
      #
      #   # good
      #   def foo(c:, d:, a: 2, b: 1); end
      class MethodDefinitionKeywordArgumentOrdered < Base
        extend AutoCorrector

        MSG = 'Sort method definition keyword arguments in alphabetical order.'

        # @param node [RuboCop::AST::ArgNode]
        def on_kwarg(node)
          previous_older_kwarg = find_previous_older_sibling(node)
          return unless previous_older_kwarg

          add_offense(node) do |corrector|
            corrector.insert_before(
              previous_older_kwarg,
              "#{node.source}, "
            )
            corrector.remove(
              node.location.expression.with(
                begin_pos: node.left_sibling.location.expression.end_pos
              )
            )
          end
        end
        alias on_kwoptarg on_kwarg

        private

        # @param node [RuboCop::AST::ArgNode]
        # @return [RuboCop::AST::ArgNode]
        def find_previous_older_sibling(node)
          node.left_siblings.find do |sibling|
            next if sibling.type != node.type

            sibling.name > node.name
          end
        end
      end
    end
  end
end
