# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Sort `require` and `require_relative` in alphabetical order.
      #
      # @example
      #   # bad
      #   require 'b'
      #   require 'a'
      #
      #   # good
      #   require 'a'
      #   require 'b'
      #
      #   # bad
      #   require_relative 'b'
      #   require_relative 'a'
      #
      #   # good
      #   require_relative 'a'
      #   require_relative 'b'
      #
      #   # good
      #   require 'a'
      #   require 'd'
      #
      #   require 'b'
      #   require 'c'
      #
      #   # good
      #   require 'b'
      #   require_relative 'c'
      #   require 'a'
      class RequireOrdered < Base
        extend AutoCorrector

        include RangeHelp

        include ::Sevencop::CopConcerns::Ordered

        RESTRICT_ON_SEND = %i[
          require
          require_relative
        ].freeze

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def on_send(node)
          previous_older_sibling = find_previous_older_sibling(node)
          return unless previous_older_sibling

          add_offense(
            node,
            message: "Sort `#{node.method_name}` in alphabetical order."
          ) do |corrector|
            swap(
              range_with_comments_and_lines(previous_older_sibling),
              range_with_comments_and_lines(node),
              corrector: corrector
            )
          end
        end

        private

        # @param node [RuboCop::AST::SendNode]
        # @return [RuboCop::AST::SendNode, nil]
        def find_previous_older_sibling(node)
          node.left_siblings.reverse.find do |sibling|
            break unless sibling.send_type?
            break if sibling.method_name != node.method_name
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
          !node1.location.expression.with(
            end_pos: node2.location.expression.end_pos
          ).source.include?("\n\n")
        end
      end
    end
  end
end
