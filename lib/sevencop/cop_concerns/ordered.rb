# frozen_string_literal: true

module Sevencop
  module CopConcerns
    module Ordered
      private

      # @param node [RuboCop::AST::Node]
      # @return [Paresr::Source::Range]
      def range_with_comments(node)
        comment = processed_source.ast_with_comments[node].first
        if comment
          node.location.expression.with(
            begin_pos: [
              comment.location.expression.begin_pos,
              node.location.expression.begin_pos
            ].min,
            end_pos: [
              comment.location.expression.end_pos,
              node.location.expression.end_pos
            ].max
          )
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

      # @param range1 [Paresr::Source::Range]
      # @param range2 [Paresr::Source::Range]
      # @param corrector [RuboCop::AST::Corrector]
      # @param newline [Boolean]
      def swap(
        range1,
        range2,
        corrector:,
        newline: false
      )
        inserted = range2.source
        inserted += "\n" if newline
        corrector.insert_before(range1, inserted)
        corrector.remove(range2)
      end
    end
  end
end
