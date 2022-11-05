# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Prefer `response.parsed_body` to `JSON.parse(response.body)`.
      #
      # @safety
      #   This cop is unsafe because Content-Type may not be `application/json`.
      #
      # @example
      #   # bad
      #   JSON.parse(response.body)
      #
      #   # good
      #   response.parsed_body
      class RSpecRailsResponseParsedBody < Base
        extend AutoCorrector

        MSG = 'Prefer `response.parsed_body` to `JSON.parse(response.body)`.'

        RESTRICT_ON_SEND = %i[parse].freeze

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def on_send(node)
          return unless bad?(node)

          add_offense(node) do |corrector|
            autocorrect(corrector, node)
          end
        end

        private

        # @!method json_parse_response_body?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :json_parse_response_body?, <<~PATTERN
          (send
            (const
              {nil? cbase}
              :JSON
            )
            :parse
            (send
              (send
                nil?
                :response
              )
              :body
            )
          )
        PATTERN
        alias bad? json_parse_response_body?

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def autocorrect(
          corrector,
          node
        )
          corrector.replace(node, 'response.parsed_body')
        end
      end
    end
  end
end
