# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Finds possible substitutions for `FactoryBot.create_list`.
      #
      # @example
      #
      #   # bad
      #   Array.new(2) do
      #     create(:user)
      #   end
      #
      #   # good
      #   create_list(:user, 2)
      #
      #   # good
      #   Array.new(2) do |i|
      #     create(:user, order: i)
      #   end
      #
      # @note
      #   This cop does not support `Integer#times` intentionally because it
      #   should be treated by `Performance/TimesMap` cop.
      #
      class FactoryBotCreateList < Base
        extend AutoCorrector

        MSG = 'Use `create_list` instead.'

        # @param node [RuboCop::AST::BlockNode]
        # @return [void]
        def on_block(node)
          count_node, factory_name_node, extra_argument_nodes = extract(node)
          return unless count_node

          add_offense(node) do |corrector|
            corrector.replace(
              node,
              format(
                'create_list(%<arguments>s)',
                arguments: [
                  factory_name_node,
                  count_node,
                  *extra_argument_nodes
                ].map(&:source).join(', ')
              )
            )
          end
        end

        private

        # @!method extract(node)
        #   @param node [RuboCop::AST::BlockNode]
        #   @return [Array(Integer, RuboCop::AST::SendNode)]
        def_node_matcher :extract, <<~PATTERN
          (block
            (send
              (const {nil? | cbase} :Array)
              :new
              $(int _)
            )
            (args)
            (send
              nil?
              :create
              $(sym _) $(...)?
            )
          )
        PATTERN

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::BlockNode]
        # @return [void]
        def autocorrect(corrector, node)
          count_node, factory_name_node, extra_argument_nodes = extract(node)
          corrector.replace(
            node,
            format(
              'create_list(%<arguments>s)',
              arguments: [
                factory_name_node,
                count_node,
                *extra_argument_nodes
              ].map(&:source).join(', ')
            )
          )
        end
      end
    end
  end
end
