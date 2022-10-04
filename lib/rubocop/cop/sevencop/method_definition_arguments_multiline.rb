# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Inserts new lines between method definition arguments.
      #
      # @example
      #   # bad
      #   def foo(a, b)
      #   end
      #
      #   # good
      #   def foo(
      #     a,
      #     b
      #   )
      #   end
      #
      #   # good
      #   def foo(a)
      #   end
      class MethodDefinitionArgumentsMultiline < Base
        extend AutoCorrector

        MSG = 'Insert new lines between method definition arguments.'

        # @param node [RuboCop::AST::ArgsNode]
        def on_args(node)
          return unless method_args?(node)
          return if multilined?(node)

          add_offense(node) do |corrector|
            autocorrect(corrector, node)
          end
        end

        private

        # @param corrector [RuboCop::AST::Corrector]
        # @param node [RuboCop::AST::ArgsNode]
        # @return [String]
        def autocorrect(
          corrector,
          node
        )
          indent = ' ' * node.parent.location.expression.column

          corrector.replace(
            node.location.expression.with(
              begin_pos: node.parent.location.name.end_pos
            ),
            [
              "(\n#{indent}  ",
              node.children.map(&:source).join(",\n#{indent}  "),
              "\n#{indent})"
            ].join
          )
        end

        # @return [Boolean]
        def method_args?(node)
          !node.parent.nil? && node.parent.def_type?
        end

        # @param node [RuboCop::AST::ArgsNode]
        # @return [Boolean]
        def multilined?(node)
          node.children.map do |child|
            child.location.expression.line
          end.uniq.length == node.children.length
        end
      end
    end
  end
end
