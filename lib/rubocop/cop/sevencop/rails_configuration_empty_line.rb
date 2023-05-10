# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Put an empty line between Rails configuration items.
      #
      # @example
      #   # bad
      #   config.a = true
      #   config.b = true
      #
      #   # good
      #   config.a = true
      #
      #   config.b = true
      class RailsConfigurationEmptyLine < Base
        extend AutoCorrector

        MSG = 'Put an empty line between configuration items.'

        RESTRICT_ON_SEND = %i[
          config
        ].freeze

        # @param [RuboCop::AST::SendNode] node
        # @return [void]
        def on_send(node)
          configuration_item = find_configuration_item_end(node)
          return unless check_if_configuration_item(configuration_item)

          previous_sibling = find_previous_sibling(configuration_item)
          return unless previous_sibling

          return if previous_sibling.source_range.end.with(
            end_pos: configuration_item.source_range.begin_pos
          ).source.include?("\n\n")

          add_offense(configuration_item) do |corrector|
            corrector.insert_after(previous_sibling, "\n")
          end
        end

        private

        # @!method check_if_configuration_item(node)
        #   @param [RuboCop::AST::Node] node
        #   @return [Boolean]
        def_node_search :check_if_configuration_item, <<~PATTERN
          (send nil? :config)
        PATTERN

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
        # @return [RuboCop::AST::Node]
        def find_configuration_item_end(node)
          find_modifier_end(
            find_chain_end(node)
          )
        end

        # @param [RuboCop::AST::Node] node
        # @return [RuboCop::AST::Node]
        def find_modifier_end(node)
          node = node.parent while node.parent.respond_to?(:modifier_form?) && node.parent.modifier_form?
          node
        end

        # @param [RuboCop::AST::Node] node
        # @return [RuboCop::AST::Node, nil]
        def find_previous_sibling(node)
          return unless check_if_under_begin(node)

          node.left_siblings.grep(::RuboCop::AST::Node).reverse.find do |sibling|
            check_if_configuration_item(sibling)
          end
        end

        # @param [RuboCop::AST::Node] node
        # @return [RuboCop::AST::Node]
        def find_receiver_root(node)
          node = node.receiver while node.receiver
          node
        end
      end
    end
  end
end
