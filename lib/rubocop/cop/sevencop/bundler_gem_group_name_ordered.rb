# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Sort `group` names in alphabetical order.
      #
      # @example
      #   # bad
      #   group :test, :development do
      #     gem 'rspec-rails'
      #   end
      #
      #   # good
      #   group :development, :test do
      #     gem 'rspec-rails'
      #   end
      class BundlerGemGroupNameOrdered < Base
        extend AutoCorrector

        include RangeHelp

        include ::Sevencop::CopConcerns::Ordered

        MSG = 'Sort `group` names in alphabetical order.'

        RESTRICT_ON_SEND = %i[
          group
        ].freeze

        # @param [RuboCop::AST::SendNode] node
        # @return [void]
        def on_send(node)
          node.arguments.select(&:sym_type?).each do |argument|
            previous_older_sibling = find_previous_older_sibling(argument)
            next unless previous_older_sibling

            add_offense(argument) do |corrector|
              corrector.swap(previous_older_sibling, argument)
            end
          end
        end

        private

        # @param [RuboCop::AST::SymbolNode] node
        # @return [RuboCop::AST::Node, nil]
        def find_previous_older_sibling(node)
          node.left_siblings.grep(::RuboCop::AST::Node).reverse.find do |sibling|
            node.source < sibling.source
          end
        end
      end
    end
  end
end
