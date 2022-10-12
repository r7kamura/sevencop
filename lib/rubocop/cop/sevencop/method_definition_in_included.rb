# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Do not define methods in `included` blocks.
      #
      # @example
      #   # bad
      #   module A
      #     extend ::ActiveSupport::Concern
      #
      #     included do
      #       def foo
      #       end
      #     end
      #   end
      #
      #   # good
      #   module A
      #     extend ::ActiveSupport::Concern
      #
      #     def foo
      #     end
      #   end
      class MethodDefinitionInIncluded < RuboCop::Cop::Base
        extend AutoCorrector

        include RangeHelp
        include VisibilityHelp

        MSG = 'Do not define methods in `included` blocks.'

        # @param node [RuboCop::AST::DefNode]
        # @return [void]
        def on_def(node)
          block = find_ancestor_included_block(node)
          return unless block

          add_offense(node) do |corrector|
            corrector.insert_before(
              range_with_comments_and_lines(block),
              "#{range_with_comments_and_lines(node).source}\n".sub(
                /\bdef /, "#{node_visibility(node)} def "
              )
            )
            corrector.remove(
              range_with_comments_and_lines(node)
            )
          end
        end

        private

        # @param range1 [Parser::Source::Range]
        # @param range2 [Parser::Source::Range]
        # @return [Parser::Source::Range]
        def add_range(
          range1,
          range2
        )
          range1.with(
            begin_pos: [range1.begin_pos, range2.begin_pos].min,
            end_pos: [range1.end_pos, range2.end_pos].max
          )
        end

        # @param node [RuboCop::AST::DefNode]
        # @return [RuboCop::AST::BlockNode, nil]
        def find_ancestor_included_block(node)
          if node.parent&.block_type?
            node.parent if node.parent.method?(:included)
          elsif node.parent&.begin_type?
            node.parent.parent if node.parent.parent&.block_type? && node.parent.parent&.method?(:included)
          end
        end

        # @param node [RuboCop::AST::DefNode]
        # @return [Boolean]
        def private?(node)
          node_visibility(node) == :private
        end

        # @param node [RuboCop::AST::Node]
        # @return [Paresr::Source::Range]
        def range_with_comments(node)
          ranges = [
            node,
            *processed_source.ast_with_comments[node]
          ].map do |element|
            element.location.expression
          end
          ranges.reduce do |result, range|
            add_range(result, range)
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
      end
    end
  end
end
