# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Always check status code with `have_http_status`.
      #
      # @example
      #   # bad
      #   it 'creates a new post' do
      #     expect { subject }.to change(Post, :count).by(1)
      #   end
      #
      #   # good
      #   it 'creates a new post' do
      #     expect { subject }.to change(Post, :count).by(1)
      #     expect(response).to have_http_status(200)
      #   end
      #
      #   # good
      #   it 'creates a new post' do
      #     expect { subject }.to change(Post, :count).by(1)
      #     expect(response).to redirect_to(posts_path)
      #   end
      class RSpecRailsHaveHttpStatus < Base
        MSG = 'Always check status code with `have_http_status`.'

        EXAMPLE_METHOD_NAMES = %i[
          example
          it
          specify
        ].to_set.freeze

        STATUS_CHECK_METHOD_NAMES = %i[
          have_http_status
          redirect_to
        ].to_set.freeze

        # @param [RuboCop::AST::BlockNode] node
        # @return [void]
        def on_block(node) # rubocop:disable InternalAffairs/NumblockHandler
          return unless example_method?(node)
          return if including_status_check_method?(node)

          add_offense(node)
        end

        private

        # @!method example_method?(node)
        #   @param [RuboCop::AST::BlockNode] node
        #   @return [Boolean]
        def_node_matcher :example_method?, <<~PATTERN
          (block (send nil? EXAMPLE_METHOD_NAMES ...) ...)
        PATTERN

        # @!method including_status_check_method?(node)
        #   @param [RuboCop::AST::BlockNode] node
        #   @return [Boolean]
        def_node_search :including_status_check_method?, <<~PATTERN
          (send nil? STATUS_CHECK_METHOD_NAMES ...)
        PATTERN
      end
    end
  end
end
