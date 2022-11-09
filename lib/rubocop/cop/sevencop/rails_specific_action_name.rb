# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Use only specific action names.
      #
      # @example
      #   # bad
      #   class UsersController < ApplicationController
      #     def articles
      #     end
      #   end
      #
      #   # good
      #   class UserArticlesController < ApplicationController
      #     def index
      #     end
      #   end
      class RailsSpecificActionName < Base
        include VisibilityHelp

        MSG = 'Use only specific action names.'

        # @param node [RuboCop::AST::DefNode]
        # @return [void]
        def on_def(node)
          return unless bad?(node)

          add_offense(node.location.name)
        end

        private

        # @param node [RuboCop::AST::DefNode]
        # @return [Boolean]
        def action?(node)
          node_visibility(node) == :public
        end

        # @param node [RuboCop::AST::DefNode]
        # @return [Boolean]
        def bad?(node)
          action?(node) &&
            !configured_action_name?(node)
        end

        # @param node [RuboCop::AST::DefNode]
        # @return [Boolean]
        def configured_action_name?(node)
          configured_action_names.include?(node.method_name.to_s)
        end

        # @return [Array<String>]
        def configured_action_names
          cop_config['ActionNames']
        end
      end
    end
  end
end
