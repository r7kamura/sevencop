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

        MSG = 'Sort method definition in alphabetical order.'

        # @param node [RuboCop::AST::DefNode]
        def on_def(node)
          previous_older_sibling = find_previous_older_sibling(node)
          return unless previous_older_sibling

          add_offense(
            range_with_comments(node)
          ) do |corrector|
            swap(
              range_with_comments_and_lines(previous_older_sibling),
              range_with_comments_and_lines(node),
              corrector: corrector
            )
          end
        end
        alias on_defs on_def

        private

        # @param node [RuboCop::AST::DefNode]
        # @return [RuboCop::AST::DefNode]
        def find_previous_older_sibling(node)
          previous_siblings_in_same_section_of(node).find do |sibling|
            next if sibling.type != node.type

            (sort_key_of(sibling) <=> sort_key_of(node)) == 1
          end
        end

        # @param node [RuboCop::AST::Node]
        # @return [Array<RuboCop::AST::Node>]
        def previous_siblings_in_same_section_of(node)
          return node.left_siblings if node.defs_type?

          node.left_siblings.reverse.take_while do |sibling|
            !visibility_block?(sibling)
          end.reverse
        end

        # @param node [RuboCop::AST::Node]
        # @return [Paresr::Source::Range]
        def range_with_comments(node)
          comment = processed_source.ast_with_comments[node].first
          if comment
            node.location.expression.with(begin_pos: comment.location.expression.begin_pos)
          else
            node.location.expression
          end
        end

        # @param node [RuboCop::AST::Node]
        # @return [Parser::Source::Range]
        def range_with_comments_and_lines(node)
          range_by_whole_lines(
            range_with_comments(node),
            include_final_newline: true
          )
        end

        # @param node [RuboCop::AST::DefNode]
        # @return [#<=>]
        def sort_key_of(node)
          [
            node.method?(:initialize) ? 0 : 1,
            node.method_name
          ]
        end

        # @param range1 [Paresr::Source::Range]
        # @param range2 [Paresr::Source::Range]
        # @param corrector [RuboCop::AST::Corrector]
        def swap(range1, range2, corrector:)
          corrector.insert_before(
            range1,
            "#{range2.source}\n"
          )
          corrector.remove(range2)
        end
      end
    end
  end
end
