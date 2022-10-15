# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Use consistent style in FactoryBot associations.
      #
      # @safety
      #   This cop may cause false-positives in `EnforcedStyle: explicit` case.
      #   It recognizes any method call that has no arguments as an implicit association
      #   but it might be a user-defined trait call.
      #
      # @example EnforcedStyle: implicit (default)
      #   # bad
      #   association :user
      #
      #   # good
      #   user
      #
      #   # good
      #   association :author, factory: user
      #
      # @example EnforcedStyle: explicit
      #   # bad
      #   user
      #
      #   # good
      #   association :user
      #
      #   # good (defined in NonImplicitAssociationMethodNames)
      #   skip_create
      class FactoryBotAssociationStyle < RuboCop::Cop::Base
        extend AutoCorrector

        include ConfigurableEnforcedStyle

        MSG = 'Use consistent style in FactoryBot associations.'

        RESTRICT_ON_SEND = %i[factory].freeze

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def on_send(node)
          bad_associations_in(node).each do |association|
            add_offense(association) do |corrector|
              autocorrect(corrector, association)
            end
          end
        end

        private

        # @!method explicit_association?(node)
        #   @param node [RuboCop::AST::SendNode]
        #   @return [Boolean]
        def_node_matcher :explicit_association?, <<~PATTERN
          (send
            nil?
            :association
            ...
          )
        PATTERN

        # @!method implicit_association?(node)
        #   @param node [RuboCop::AST::SendNode]
        #   @return [Boolean]
        def_node_matcher :implicit_association?, <<~PATTERN
          (send
            nil?
            !#non_implicit_association_method_name?
          )
        PATTERN

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::SendNode]
        def autocorrect(
          corrector,
          node
        )
          case style
          when :explicit
            autocorrect_to_explicit_style(corrector, node)
          when :implicit
            autocorrect_to_implicit_style(corrector, node)
          end
        end

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def autocorrect_to_explicit_style(
          corrector,
          node
        )
          corrector.replace(node, "association :#{node.method_name}")
        end

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def autocorrect_to_implicit_style(
          corrector,
          node
        )
          corrector.replace(node, node.first_argument.value.to_s)
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [Boolean]
        def autocorrectable_to_implicit_style?(node)
          node.arguments.one?
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [Boolean]
        def bad?(node)
          case style
          when :explicit
            bad_to_explicit_style?(node)
          when :implicit
            bad_to_implicit_style?(node)
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [Array<RuboCop::AST::SendNode>]
        def bad_associations_in(node)
          children_of_factory_block(node).select do |child|
            bad?(child)
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [Boolean]
        def bad_to_explicit_style?(node)
          implicit_association?(node)
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [Boolean]
        def bad_to_implicit_style?(node)
          explicit_association?(node) && autocorrectable_to_implicit_style?(node)
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [Array<RuboCop::AST::Node>]
        def children_of_factory_block(node)
          block = node.parent
          return [] unless block
          return [] unless block.block_type?

          if block.body.begin_type?
            block.body.children
          else
            [block.body]
          end
        end

        # @param method_name [Symbol]
        # @return [Boolean]
        def non_implicit_association_method_name?(method_name)
          cop_config['NonImplicitAssociationMethodNames'].include?(method_name.to_s)
        end
      end
    end
  end
end
