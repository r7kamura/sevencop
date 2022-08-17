# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Identifies a String including "field" is passed to `order` or `reorder`.
      #
      # @safety
      #   This cop is unsafe because it can register a false positive.
      #
      # @example
      #
      #   # bad
      #   articles.order('field(id, ?)', a)
      #
      #   # good
      #   articles.order(Arel.sql('field(id, ?)'), a)
      #
      #   # bad
      #   reorder('field(id, ?)', a)
      #
      #   # good
      #   reorder(Arel.sql('field(id, ?)'), a)
      #
      class OrderField < Base
        extend AutoCorrector

        MSG = 'Wrap safe SQL String by `Arel.sql`.'

        RESTRICT_ON_SEND = %i[
          order
          reorder
        ].freeze

        # @!method order_with_field?(node)
        def_node_matcher :order_with_field?, <<~PATTERN
          (send
            _ _
            {
              (str /field\(.+\)/i) |
              (dstr <(str /field\(.+\)/i) ...>)
            }
            ...
          )
        PATTERN

        # @param [RuboCop::AST::SendNode] node
        def on_send(node)
          return unless order_with_field?(node)

          first_argument_node = node.arguments.first
          add_offense(first_argument_node) do |corrector|
            corrector.replace(
              node.arguments.first,
              "Arel.sql(#{first_argument_node.source})"
            )
          end
        end
      end
    end
  end
end
