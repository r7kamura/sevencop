# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Use throttling in batch processing.
      #
      # @safety
      #   There are some cases where we should not do throttling,
      #   or the throttling is already done in a way that we cannot detect.
      #
      # @example
      #   # bad
      #   class BackfillSomeColumn < ActiveRecord::Migration[7.0]
      #     disable_ddl_transaction!
      #
      #     def change
      #       User.in_batches do |relation|
      #         relation.update_all(some_column: 'some value')
      #       end
      #     end
      #   end
      #
      #   # good
      #   class BackfillSomeColumnToUsers < ActiveRecord::Migration[7.0]
      #     disable_ddl_transaction!
      #
      #     def up
      #       User.in_batches do |relation|
      #         relation.update_all(some_column: 'some value')
      #         sleep(0.01)
      #       end
      #     end
      #   end
      class RailsMigrationBatchWithThrottling < RuboCop::Cop::Base
        extend AutoCorrector

        MSG = 'Use throttling in batch processing.'

        RESTRICT_ON_SEND = %i[
          update_all
        ].freeze

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def on_send(node)
          return unless wrong?(node)

          add_offense(node) do |corrector|
            autocorrect(corrector, node)
          end
        end

        private

        # @!method sleep?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :sleep?, <<~PATTERN
          (send
            nil?
            :sleep
            ...
          )
        PATTERN

        # @!method update_all?(node)
        #   @param node [RuboCop::AST::SendNode]
        #   @return [Boolean]
        def_node_matcher :update_all?, <<~PATTERN
          (send
            !nil?
            :update_all
            ...
          )
        PATTERN

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def autocorrect(
          corrector,
          node
        )
          corrector.insert_after(
            node,
            "\n#{' ' * node.location.column}sleep(0.01)"
          )
        end

        # @param node [RuboCop::AST::Node]
        # @return [Boolean]
        def in_block?(node)
          node.parent&.block_type? ||
            (node.parent&.begin_type? && node.parent.parent&.block_type?)
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [Boolean]
        def with_throttling?(node)
          (node.left_siblings + node.right_siblings).any? do |sibling|
            sleep?(sibling)
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [Boolean]
        def wrong?(node)
          update_all?(node) && in_block?(node) && !with_throttling?(node)
        end
      end
    end
  end
end
