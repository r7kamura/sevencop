# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Sort method definition in alphabetical order.
      #
      # @example
      #   # bad
      #   def b; end
      #   def a; end
      #
      #   # good
      #   def a; end
      #   def b; end
      #
      #   # good
      #   def b; end
      #   def c; end
      #   private
      #   def a; end
      #   def d; end
      #
      #   # good
      #   def initialize; end
      #   def a; end
      class MethodDefinitionOrdered < Base
        extend AutoCorrector

        include RangeHelp
        include VisibilityHelp

        include ::Sevencop::CopConcerns::Ordered

        MSG = 'Sort method definition in alphabetical order.'

        # @param node [RuboCop::AST::DefNode]
        # @return [void]
        def on_def(node)
          previous_older_sibling = find_previous_older_sibling(node)
          return unless previous_older_sibling

          add_offense(node) do |corrector|
            swap(
              range_with_comments_and_lines(previous_older_sibling),
              range_with_comments_and_lines(node),
              corrector: corrector,
              newline: true
            )
          end
        end
        alias on_defs on_def

        private

        # @param node [RuboCop::AST::DefNode]
        # @return [RuboCop::AST::DefNode, nil]
        def find_previous_older_sibling(node)
          previous_siblings_in_same_section_of(node).find do |sibling|
            next if sibling.type != node.type

            (sort_key_of(sibling) <=> sort_key_of(node)) == 1
          end
        end

        # @param node [RuboCop::AST::Node]
        # @return [Array<RuboCop::AST::Node>]
        def previous_siblings_in_same_section_of(node)
          siblings = node.left_siblings.grep(::RuboCop::AST::Node)
          return siblings if node.defs_type?

          siblings.reverse.take_while do |sibling|
            !visibility_block?(sibling)
          end
        end

        # @param node [RuboCop::AST::DefNode]
        # @return [#<=>]
        def sort_key_of(node)
          [
            node.method?(:initialize) ? 0 : 1,
            node.method_name
          ]
        end
      end
    end
  end
end
