# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Use `expect(response).to have_http_status(code)` instead of `is_expected.to eq(code)`.
      #
      # @example
      #   # bad
      #   is_expected.to eq(200)
      #
      #   # good
      #   expect(response).to have_http_status(200)
      #
      #   # bad
      #   is_expected.to eq(:ok)
      #
      #   # good
      #   expect(response).to have_http_status(:ok)
      class RSpecRailsStatusCodeCheckBySubject < Base
        extend AutoCorrector

        MSG = 'Use `expect(response).to have_http_status(code)` instead of `is_expected.to eq(code)`.'

        RESTRICT_ON_SEND = %i[
          to
        ].freeze

        # @param [RuboCop::AST::SendNode] node
        # @return [void]
        def on_send(node)
          return unless is_expected_to_eq_code?(node)

          add_offense(node) do |corrector|
            corrector.insert_before(node, "subject\n")
            corrector.replace(node.receiver, 'expect(response)')
            corrector.replace(node.first_argument.location.selector, 'have_http_status')
          end
        end

        private

        # @!method is_expected_to_eq_code?(node)
        #   @param [RuboCop::AST::SendNode] node
        #   @return [Boolean]
        def_node_matcher :is_expected_to_eq_code?, <<~PATTERN
          (send (send nil? :is_expected) :to (send nil? :eq {int sym}))
        PATTERN
      end
    end
  end
end
