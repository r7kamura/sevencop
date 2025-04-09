# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Sort `group` in alphabetical order.
      #
      # Note that the sort key is computed from the sorted and concatenated `group` arguments.
      # For example, the sort key for `group :test, :development` is `development-test`.
      #
      # @example
      #   # bad
      #   group :test do
      #     gem 'rspec'
      #   end
      #
      #   group :development do
      #     gem 'better_errors'
      #   end
      #
      #   # good
      #   group :development do
      #     gem 'better_errors'
      #   end
      #
      #   group :test do
      #     gem 'rspec'
      #   end
      class BundlerGemGroupOrdered < Base
        extend AutoCorrector

        include RangeHelp

        include ::Sevencop::CopConcerns::Ordered

        MSG = 'Sort `group` in alphabetical order.'

        RESTRICT_ON_SEND = %i[
          group
        ].freeze

        # @param [RuboCop::AST::SendNode] node
        # @return [void]
        def on_send(node)
          block_node = node.block_node
          return unless block_node

          previous_older_sibling = find_previous_older_sibling(block_node)
          return unless previous_older_sibling

          add_offense(block_node) do |corrector|
            corrector.swap(
              range_with_comments_and_lines(previous_older_sibling),
              range_with_comments_and_lines(block_node)
            )
          end
        end
        alias on_csend on_send

        private

        # @param [RuboCop::AST::BlockNode] node
        # @return [String, nil]
        def calculate_sort_key(node)
          return unless node.send_node.arguments.all? { |argument| argument.respond_to?(:value) }

          node.send_node.arguments.map(&:value).sort.join('-')
        end

        # @param [RuboCop::AST::BlockNode] node
        # @return [RuboCop::AST::BlockNode, nil]
        def find_previous_older_sibling(node)
          node.left_siblings.grep(::RuboCop::AST::Node).reverse.find do |sibling|
            break unless sibling.block_type?
            break unless sibling.method?(:group)

            current_sort_key = calculate_sort_key(node)
            sibling_sort_key = calculate_sort_key(sibling)
            break unless current_sort_key
            break unless sibling_sort_key

            calculate_sort_key(node) < calculate_sort_key(sibling)
          end
        end
      end
    end
  end
end
