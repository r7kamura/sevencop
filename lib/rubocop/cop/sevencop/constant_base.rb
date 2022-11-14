# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Remove unnecessary `::` prefix from constant.
      #
      # @example
      #   # bad
      #   ::Const
      #
      #   # good
      #   Const
      #
      #   # bad
      #   class << self
      #     ::Const
      #   end
      #
      #   # good
      #   class << self
      #     Const
      #   end
      #
      #   # good
      #   class Klass
      #     ::Const
      #   end
      #
      #   # good
      #   class module
      #     ::Const
      #   end
      class ConstantBase < Base
        extend AutoCorrector

        MSG = 'Remove unnecessary `::` prefix from constant.'

        # @param node [RuboCop::AST::CbaseNode]
        # @return [void]
        def on_cbase(node)
          return unless bad?(node)

          add_offense(node) do |corrector|
            corrector.remove(node)
          end
        end

        private

        # @!method named_class_or_module?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :named_class_or_module?, <<~PATTERN
          ({class module} const ...)
        PATTERN

        # @param node [RuboCop::AST::CbaseNode]
        # @return [Boolean]
        def bad?(node)
          node.each_ancestor(:class, :module).none?
        end
      end
    end
  end
end
