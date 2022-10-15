# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Remove redundant options from FactoryBot associations.
      #
      # @example
      #   # bad
      #   association :user, factory: :user
      #
      #   # good
      #   association :user
      class FactoryBotAssociationOption < RuboCop::Cop::Base
        extend AutoCorrector

        include RangeHelp

        MSG = 'Remove redundant options from FactoryBot associations.'

        RESTRICT_ON_SEND = %i[association].freeze

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def on_send(node)
          association_name = association_name_from(node)
          factory_option = factory_option_from(node)
          return if !factory_option || association_name != factory_option.value.value

          add_offense(factory_option) do |corrector|
            autocorrect(corrector, factory_option)
          end
        end

        private

        # @!method association_name_from(node)
        #   @param node [RuboCop::AST::SendNode]
        #   @return [Symbol, nil]
        def_node_matcher :association_name_from, <<~PATTERN
          (send
            nil?
            _
            (sym $_)
            ...
          )
        PATTERN

        # @!method factory_option_from(node)
        #   @param node [RuboCop::AST::SendNode]
        #   @return [RuboCop::AST::PairNode, nil]
        def_node_matcher :factory_option_from, <<~PATTERN
          (send
            nil?
            _
            _
            (hash
              <
                $(pair
                  (sym :factory)
                  sym
                )
                ...
              >
            )
          )
        PATTERN

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::PairNode]
        # @return [void]
        def autocorrect(
          corrector,
          node
        )
          corrector.remove(
            range_with_surrounding_comma(
              range_with_surrounding_space(
                node.location.expression,
                side: :left
              ),
              :left
            )
          )
        end
      end
    end
  end
end
