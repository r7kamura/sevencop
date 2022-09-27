# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Identifies use of UniquenessValidator without :case_sensitive option.
      # Useful to keep the same behavior between Rails 6.0 and 6.1 where case insensitive collation is used in MySQL.
      #
      # @safety
      #   This cop is unsafe because it can register a false positive.
      #
      # @example
      #
      #   # bad
      #   validates :name, uniqueness: true
      #
      #   # good
      #   validates :name, uniqueness: { case_sensitive: true }
      #
      #   # good
      #   validates :name, uniqueness: { case_sensitive: false }
      #
      #   # bad
      #   validates :name, uniqueness: { allow_nil: true, scope: :user_id }
      #
      #   # good
      #   validates :name, uniqueness: { allow_nil: true, scope: :user_id, case_sensitive: true }
      #
      class UniquenessValidatorExplicitCaseSensitivity < Base
        extend AutoCorrector

        MSG = 'Specify :case_sensitivity option on use of UniquenessValidator.'

        RESTRICT_ON_SEND = %i[validates].freeze

        # @!method validates_uniqueness?(node)
        def_node_matcher :validates_uniqueness?, <<~PATTERN
          (send nil? :validates
            _
            (hash
              <
                (pair
                  (sym :uniqueness)
                  {true | (hash ...)}
                )
              >
              ...
            )
          )
        PATTERN

        # @!method validates_uniqueness_with_case_sensitivity?(node)
        def_node_matcher :validates_uniqueness_with_case_sensitivity?, <<~PATTERN
          (send nil? :validates
            _
            (hash
              <
                (pair
                  (sym :uniqueness)
                  (hash <(pair (sym :case_sensitive) _) ...>)
                )
                ...
              >
            )
          )
        PATTERN

        # @param [RuboCop::AST::SendNode] node
        def find_uniqueness_value(node)
          node.arguments[1].pairs.find { |pair| pair.key.value == :uniqueness }.value
        end

        # @param [RuboCop::AST::SendNode] node
        def on_send(node)
          return unless validates_uniqueness?(node) && !validates_uniqueness_with_case_sensitivity?(node)

          uniqueness_value = find_uniqueness_value(node)
          add_offense(uniqueness_value) do |corrector|
            if uniqueness_value.true_type?
              corrector.replace(
                uniqueness_value.source_range,
                '{ case_sensitive: true }'
              )
            else
              corrector.insert_after(
                uniqueness_value.pairs.last.source_range,
                ', case_sensitive: true'
              )
            end
          end
        end
      end
    end
  end
end
