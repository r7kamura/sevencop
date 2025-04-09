# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Always use `as` option on routing methods.
      #
      # @example
      #   # bad
      #   delete "/users/:id" => "users#destroy"
      #   get    "/users/:id" => "users#show"
      #
      #   # good
      #   delete "/users/:id" => "users#destroy", as: "user"
      #   get    "/users/:id" => "users#show", as: nil
      class RailsRouteAs < Base
        MSG = "Always use `as` option on routing methods. Use `as: nil` if you don't need named routes."

        RESTRICT_ON_SEND = %i[
          delete
          get
          head
          patch
          post
          put
        ].freeze

        # @param [RuboCop::AST::SendNode] node
        # @return [void]
        def on_send(node)
          last_argument = node.last_argument
          return unless last_argument&.hash_type?
          return if last_argument.pairs.any? { |pair| pair.key.value == :as }

          add_offense(node)
        end
        alias on_csend on_send
      end
    end
  end
end
