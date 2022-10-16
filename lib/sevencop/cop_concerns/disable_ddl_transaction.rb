# frozen_string_literal: true

module Sevencop
  module CopConcerns
    module DisableDdlTransaction
      class << self
        def included(klass)
          super
          klass.class_eval do
            # @!method disable_ddl_transaction?(node)
            #   @param node [RuboCop::AST::SendNode]
            #   @return [Boolean]
            def_node_matcher :disable_ddl_transaction?, <<~PATTERN
              (send
                nil?
                :disable_ddl_transaction!
                ...
              )
            PATTERN
          end
        end
      end

      private

      # @param corrector [RuboCop::Cop::Corrector]
      # @param node [RuboCop::AST::SendNode]
      # @return [void]
      def insert_disable_ddl_transaction(
        corrector,
        node
      )
        corrector.insert_before(
          node.each_ancestor(:def).first,
          "disable_ddl_transaction!\n\n  "
        )
      end

      # @param node [RuboCop::AST::SendNode]
      # @return [Boolean]
      def within_disable_ddl_transaction?(node)
        node.each_ancestor(:def).first&.left_siblings&.any? do |sibling|
          sibling.is_a?(::RuboCop::AST::SendNode) &&
            disable_ddl_transaction?(sibling)
        end
      end
    end
  end
end
