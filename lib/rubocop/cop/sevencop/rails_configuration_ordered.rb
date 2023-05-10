# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Sort Rails configuration items in alphabetical order.
      #
      # @safety
      #   This cop's autocorrection is unsafe because chainging code order can change the behavior of the program.
      #
      # @example
      #   # bad
      #   config.b1.b2 = true
      #   config.a1.a2 = true
      #
      #   # good
      #   config.a1.a2 = true
      #   config.b1.b2 = true
      #
      # @example IgnoredPatterns: ['config.load_defaults']
      #   # good
      #   config.load_defaults 7.1
      #   config.a1.a2 = true
      class RailsConfigurationOrdered < Base
        extend AutoCorrector

        include RangeHelp

        include ::Sevencop::CopConcerns::Ordered

        MSG = 'Sort configuration items in alphabetical order.'

        RESTRICT_ON_SEND = %i[
          config
        ].freeze

        # @param [RuboCop::AST::SendNode] node
        # @return [void]
        def on_send(node)
          chain_end = find_chain_end(node)
          return unless check_if_configuration_item(chain_end)

          previous_older_sibling = find_previous_older_sibling(chain_end)
          return unless previous_older_sibling

          add_offense(chain_end) do |corrector|
            swap(
              range_with_comments_and_lines(previous_older_sibling),
              range_with_comments_and_lines(chain_end),
              corrector: corrector
            )
          end
        end

        private

        # @param [RuboCop::AST::Node] node
        # @return [Boolean]
        def check_if_configuration_item(node)
          return unless node.call_type? || node.block_type?

          receiver_root = find_receiver_root(node)
          receiver_root.send_type? && receiver_root.method?(:config)
        end

        # @param [RuboCop::AST::Node] node
        # @return [Boolean]
        def check_if_ignored_configuration_item(node)
          ignored_patterns.any? do |ignored_pattern|
            node.source.start_with?(ignored_pattern)
          end
        end

        # @param [RuboCop::AST::Node] node
        # @return [Boolean]
        def check_if_under_begin(node)
          node.parent&.begin_type?
        end

        # @param [RuboCop::AST::SendNode] node
        # @return [RuboCop::AST::Node]
        def find_chain_end(node)
          node = node.parent while node.chained?
          node
        end

        # @param [RuboCop::AST::Node] node
        # @return [RuboCop::AST::Node, nil]
        def find_previous_older_sibling(node)
          return unless check_if_under_begin(node)

          node.left_siblings.grep(::RuboCop::AST::Node).find do |sibling|
            check_if_configuration_item(sibling) &&
              !check_if_ignored_configuration_item(sibling) &&
              sibling.source > node.source
          end
        end

        # @param [RuboCop::AST::Node] node
        # @return [RuboCop::AST::Node]
        def find_receiver_root(node)
          node = node.receiver while node.receiver
          node
        end

        # @return [Array<String>]
        def ignored_patterns
          cop_config['IgnoredPatterns']
        end
      end
    end
  end
end
