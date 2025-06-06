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
      #
      #   # good
      #   autoload :A, 'a'
      #   autoload :D, 'd'
      #
      #   autoload :B, 'b'
      #   autoload :C, 'c'
      class AutoloadOrdered < Base
        extend AutoCorrector

        include RangeHelp

        include ::Sevencop::CopConcerns::Ordered

        MSG = 'Sort `autoload` in alphabetical order.'

        RESTRICT_ON_SEND = %i[
          autoload
        ].freeze

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def on_send(node)
          previous_older_sibling = find_previous_older_sibling(node)
          return unless previous_older_sibling

          add_offense(node) do |corrector|
            swap(
              range_with_comments_and_lines(previous_older_sibling),
              range_with_comments_and_lines(node),
              corrector: corrector
            )
          end
        end
        alias on_csend on_send

        private

        # @param node [RuboCop::AST::SendNode]
        # @return [RuboCop::AST::SendNode, nil]
        def find_previous_older_sibling(node)
          node.left_siblings.grep(::RuboCop::AST::Node).reverse.find do |sibling|
            break unless sibling.send_type?
            break unless sibling.method?(:autoload)
            break unless in_same_section?(sibling, node)

            node.first_argument.source < sibling.first_argument.source
          end
        end

        # @param node1 [RuboCop::AST::SendNode]
        # @param node2 [RuboCop::AST::SendNode]
        # @return [Boolean]
        def in_same_section?(
          node1,
          node2
        )
          !node1.source_range.with(
            end_pos: node2.source_range.end_pos
          ).source.include?("\n\n")
        end
      end
    end
  end
end
