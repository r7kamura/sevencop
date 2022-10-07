# frozen_string_literal: true

module Sevencop
  module CopConcerns
    module Ordered
      private

      # @param range1 [Paresr::Source::Range]
      # @param range2 [Paresr::Source::Range]
      # @return [Paresr::Source::Range]
      def add_range(
        range1,
        range2
      )
        range1.with(
          begin_pos: [range1.begin_pos, range2.begin_pos].min,
          end_pos: [range1.end_pos, range2.end_pos].max
        )
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
