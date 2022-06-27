# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Force `belongs_to` with `optional: true` option.
      #
      # @example
      #
      #   # bad
      #   belongs_to :group
      #
      #   # good
      #   belongs_to :group, optional: true
      #
      #   # good
      #   belongs_to :group, optional: false
      #
      #   # good (We cannot identify offenses in this case.)
      #   belongs_to :group, options
      #
      class BelongsToOptional < Base
        extend AutoCorrector

        MSG = 'Specify :optional option.'

        RESTRICT_ON_SEND = %i[
          belongs_to
        ].freeze

        def_node_matcher :without_options?, <<~PATTERN
          (send _ _ _ (block ...)?)
        PATTERN

        def_node_matcher :with_hash_options?, <<~PATTERN
          (send _ _ _ (block ...)? (hash ...))
        PATTERN

        def_node_matcher :with_optional?, <<~PATTERN
          (send _ _ _ (block ...)? (hash <(pair (sym :optional) _) ...>))
        PATTERN

        # @param [RuboCop::AST::SendNode] node
        def on_send(node)
          return unless without_options?(node) || (with_hash_options?(node) && !with_optional?(node))

          add_offense(node) do |corrector|
            corrector.insert_after(node.arguments[-1], ', optional: true')
          end
        end
      end
    end
  end
end
