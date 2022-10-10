# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Pass HTTP endpoint identifier to top-level `describe` on request-specs.
      #
      # @see https://github.com/r7kamura/rspec-request_describer
      #
      # @example
      #   # bad
      #   RSpec.describe 'Users'
      #
      #   # good
      #   RSpec.describe 'GET /users'
      class RSpecDescribeHttpEndpoint < Base
        MSG = 'Pass HTTP endpoint identifier to top-level `describe` on request-specs.'

        RESTRICT_ON_SEND = %i[
          describe
        ].freeze

        SUPPORTED_HTTP_METHODS = %w[
          DELETE
          GET
          PATCH
          POST
          PUT
        ].freeze

        DESCRIPTION_PATTERN = %r{\A#{::Regexp.union(SUPPORTED_HTTP_METHODS)} /}.freeze

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def on_send(node)
          return unless top_level_describe?(node)
          return unless node.first_argument
          return if http_endpoint_identifier?(node.first_argument)

          add_offense(node.first_argument)
        end

        private

        # @!method top_level_describe?(node)
        #   @param node [RuboCop::AST::SendNode]
        #   @return [Boolean]
        def_node_matcher :top_level_describe?, <<~PATTERN
          (send
            (const nil? :RSpec)
            :describe
            ...
          )
        PATTERN

        # @param node [RuboCop::AST::Node, nil]
        # @return [Boolean]
        def http_endpoint_identifier?(node)
          node&.str_type? && node.value.match?(DESCRIPTION_PATTERN)
        end
      end
    end
  end
end
