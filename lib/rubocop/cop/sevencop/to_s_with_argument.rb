# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Identifies passing any argument to `#to_s`.
      #
      # @example
      #
      #   # bad
      #   to_s(:delimited)
      #
      #   # good
      #   to_formatted_s(:delimited)
      #
      class ToSWithArgument < Base
        extend AutoCorrector

        MSG = 'Use `to_formatted_s(...)` instead of `to_s(...)`.'

        def_node_matcher :to_s_with_any_argument?, <<~PATTERN
          (call _ :to_s _+)
        PATTERN

        def on_send(node)
          return unless to_s_with_any_argument?(node)

          add_offense(node) do |rewriter|
            rewriter.replace(
              node.loc.selector,
              'to_formatted_s'
            )
          end
        end
        alias on_csend on_send
      end
    end
  end
end
