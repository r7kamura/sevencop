# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Identifies redundant spec type.
      # This is automatically set by `config.infer_spec_type_from_file_location!`.
      #
      # @example
      #
      #   # bad
      #   # spec/models/user_spec.rb
      #   RSpec.describe User, type: :model
      #
      #   # good
      #   # spec/models/user_spec.rb
      #   RSpec.describe User
      #
      #   # good
      #   # spec/models/user_spec.rb
      #   RSpec.describe User, type: :request
      #
      class RailsInferredSpecType < Base
        extend AutoCorrector

        # @return [Array<Hash>]
        INFERENCES = [
          { prefix: 'spec/channels/', type: :channel },
          { prefix: 'spec/controllers/', type: :controller },
          { prefix: 'spec/features/', type: :feature },
          { prefix: 'spec/generator/', type: :generator },
          { prefix: 'spec/helpers/', type: :helper },
          { prefix: 'spec/jobs/', type: :job },
          { prefix: 'spec/mailboxes/', type: :mailbox },
          { prefix: 'spec/mailers/', type: :mailer },
          { prefix: 'spec/models/', type: :model },
          { prefix: 'spec/requests/', type: :request },
          { prefix: 'spec/integration/', type: :request },
          { prefix: 'spec/api/', type: :request },
          { prefix: 'spec/routing/', type: :routing },
          { prefix: 'spec/system/', type: :system },
          { prefix: 'spec/views/', type: :view }
        ].freeze

        MSG = 'Remove redundant spec type.'

        RESTRICT_ON_SEND = %i[
          describe
        ].freeze

        # @param [RuboCop::AST::SendNode] node
        def on_send(node)
          pair_node = describe_with_type(node)
          return unless pair_node
          return unless inferred_type?(pair_node)

          removable_node = detect_removable_node(pair_node)
          add_offense(removable_node) do |corrector|
            autocorrect(corrector, removable_node)
          end
        end

        private

        # @!method describe_with_type(node)
        #   @param [RuboCop::AST::SendNode] node
        #   @return [RuboCop::AST::PairNode, nil]
        def_node_matcher :describe_with_type, <<~PATTERN
          (send
            { (const nil? :RSpec) | nil? }
            _
            _
            _*
            ({ hash | kwargs }
              (pair ...)*
              $(pair (sym :type) sym)
              (pair ...)*
            )
          )
        PATTERN

        # @param [RuboCop::AST::Corrector] corrector
        # @param [RuboCop::AST::Node] node
        def autocorrect(
          corrector,
          node
        )
          corrector.remove(
            node.location.expression.with(
              begin_pos: node.left_sibling.location.expression.end_pos
            )
          )
        end

        # @param [RuboCop::AST::PairNode] node
        # @return [RuboCop::AST::Node]
        def detect_removable_node(node)
          if node.parent.pairs.size == 1
            node.parent
          else
            node
          end
        end

        # @return [String]
        def file_path
          processed_source.file_path
        end

        # @param [RuboCop::AST::PairNode] node
        # @return [Boolean]
        def inferred_type?(node)
          inferred_type_from_file_path.inspect == node.value.source
        end

        # @return [Symbol, nil]
        def inferred_type_from_file_path
          INFERENCES.find do |inference|
            break inference[:type] if file_path.include?(inference[:prefix])
          end
        end
      end
    end
  end
end
