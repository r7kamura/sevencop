# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Sort routes by path and HTTP method.
      #
      # @example
      #   # bad
      #   get "/users/:id" => "users#show"
      #   get "/users" => "users#index"
      #
      #   # good
      #   get "/users" => "users#index"
      #   get "/users/:id" => "users#show"
      #
      #   # bad
      #   post "/users" => "users#create"
      #   get  "/users" => "users#index"
      #
      #   # good
      #   get  "/users" => "users#index"
      #   post "/users" => "users#create"
      class RailsRouteOrdered < Base
        extend AutoCorrector

        include RangeHelp

        MSG = 'Sort routes by path and HTTP method.'

        RESTRICT_ON_SEND = %i[
          delete
          get
          head
          options
          patch
          post
          put
        ].freeze

        # @param [RuboCop::AST::SendNode] node
        # @return [void]
        def on_send(node)
          previous_older_sibling = find_previous_older_sibling(node)
          return unless previous_older_sibling

          add_offense(node) do |corrector|
            corrector.swap(
              range_with_comments_and_lines(previous_older_sibling),
              range_with_comments_and_lines(node)
            )
          end
        end

        private

        # @param [RuboCop::AST::SendNode] node
        # @return [Array<String>]
        def convert_to_comparison_key(node)
          [
            find_path_node(node).source.tr(':', '~'),
            node.method_name
          ]
        end

        # Find path node from both of the following styles:
        #   `get "/users" => "users#index`
        #   `get "/users", to: "users#index`
        # @param [RuboCop::AST::SendNode] node
        # @return [RuboCop::AST::Node, nil]
        def find_path_node(node)
          if node.first_argument.hash_type?
            node.first_argument.keys.first
          else
            node.first_argument
          end
        end

        # @param [RuboCop::AST::SendNode] node
        # @return [RuboCop::AST::SendNode, nil]
        def find_previous_older_sibling(node)
          node.left_siblings.grep(::RuboCop::AST::SendNode).reverse.find do |sibling|
            RESTRICT_ON_SEND.include?(sibling.method_name) &&
              (convert_to_comparison_key(sibling) <=> convert_to_comparison_key(node)).positive?
          end
        end
      end
    end
  end
end
