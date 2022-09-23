# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Sort `autoload` in alphabetical order.
      #
      # @example
      #   # bad
      #   autoload :B, 'b'
      #   autoload :A, 'a'
      #
      #   # good
      #   autoload :A, 'a'
      #   autoload :B, 'b'
      class AutoloadOrdered < Base
        extend AutoCorrector

        include RangeHelp

        MSG = 'Sort `autoload` in alphabetical order.'

        RESTRICT_ON_SEND = %i[
          autoload
        ].freeze

        # @param node [RuboCop::AST::SendNode]
        def on_send(node)
          previous_older_autoload = find_previous_older_autoload(node)
          return unless previous_older_autoload

          add_offense(node) do |corrector|
            swap(
              range_by_whole_lines(
                previous_older_autoload.location.expression,
                include_final_newline: true
              ),
              range_by_whole_lines(
                node.location.expression,
                include_final_newline: true
              ),
              corrector: corrector
            )
          end
        end

        private

        # @param node [RuboCop::AST::SendNode]
        # @return [RuboCop::AST::SendNode]
        def find_previous_older_autoload(node)
          node.left_siblings.find do |sibling|
            next unless sibling.send_type?
            next unless sibling.method?(:autoload)

            node.first_argument.source < sibling.first_argument.source
          end
        end

        # @param range1 [Paresr::Source::Range]
        # @param range2 [Paresr::Source::Range]
        # @param corrector [RuboCop::AST::Corrector]
        def swap(range1, range2, corrector:)
          corrector.insert_before(range1, range2.source)
          corrector.remove(range2)
        end
      end
    end
  end
end